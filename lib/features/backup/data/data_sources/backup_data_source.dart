import 'dart:async';
import 'dart:io';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/db/db_helper.dart';
import 'package:carma/core/errors/failure.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/googleapis_auth.dart';
import 'package:http/io_client.dart';
import 'package:icloud_storage/icloud_storage.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

abstract class DriveBackupDataSource {
  Future<Either<Failure, void>> uploadBackupToGoogleDrive();

  Future<Either<Failure, void>> uploadBackupToiCloud();

  Future<Either<Failure, void>> deleteBackupFromGoogleDrive();

  Future<Either<Failure, void>> restoreBackupFromGoogleDrive();

  Future<Either<Failure, void>> deleteBackupFromiCloud();

  Future<Either<Failure, void>> restoreBackupFromiCloud();
}

class DriveBackupDataSourceImpl extends DriveBackupDataSource {
  final GoogleSignIn _googleSignIn;
  final DbHelper dbHelper;
  final FlutterSecureStorage flutterSecureStorage;

  DriveBackupDataSourceImpl(
      this._googleSignIn, this.dbHelper, this.flutterSecureStorage);

  @override
  Future<Either<Failure, void>> uploadBackupToGoogleDrive() async {
    try {
      File file = await dbHelper.getDatabaseBackupFile();

      if (!await file.exists()) {
        return const Left(GeneralFailure('Backup file does not exist'));
      }

      String fileName = 'app_database.db';

      final authClient = await initializeAuthClient();

      if (authClient == null) {
        return const Left(
            GeneralFailure('Unable to backup to drive. User is not signed In'));
      }

      final driveApi = drive.DriveApi(authClient);

      final media = drive.Media(
        file.openRead(),
        await file.length(),
      );

      final existingFiles = await driveApi.files.list(
        q: "name = '$fileName' and trashed = false",
        spaces: 'drive',
      );

      if (existingFiles.files != null &&
          existingFiles.files!.isNotEmpty &&
          existingFiles.files!.first.id != null) {
        // Update the existing file
        final existingFileId = existingFiles.files!.first.id!;
        await driveApi.files.update(
          drive.File()..name = fileName,
          existingFileId,
          uploadMedia: media,
        );
        print('Updated file ID: $existingFileId');
      } else {
        // Create the file metadata
        final drive.File driveFile = drive.File();
        driveFile.name = fileName;
        driveFile.mimeType = "text/plain";

        // Upload the file
        final file = await driveApi.files.create(
          driveFile,
          uploadMedia: media,
        );
        print('Uploaded file ID: ${file.id}');
      }
      await flutterSecureStorage.write(
          key: Constants.LAST_BACKUP,
          value: DateFormat('dd MMM HH:mm').format(DateTime.now()));
      return const Right(unit);
    } catch (e) {
      print('Error uploading file: $e');
      return const Left(GeneralFailure('Unable to backup to drive'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBackupFromGoogleDrive() async {
    try {
      String fileName = 'app_database.db';

      final authClient = await initializeAuthClient();

      if (authClient == null) {
        return const Left(GeneralFailure(
            'Unable to delete from drive. User is not signed In'));
      }

      final driveApi = drive.DriveApi(authClient);

      final existingFiles = await driveApi.files.list(
        q: "name = '$fileName' and trashed = false",
        spaces: 'drive',
      );

      // TODO: Do necessary null check error handling
      if (existingFiles.files != null &&
          existingFiles.files!.isNotEmpty &&
          existingFiles.files!.first.id != null) {
        // Delete the file
        final fileId = existingFiles.files!.first.id!;
        await driveApi.files.delete(fileId);
        print('Deleted file ID: $fileId');
      } else {
        return const Left(GeneralFailure('File not found on Drive'));
      }

      return const Right(unit);
    } catch (e) {
      print('Error deleting file: $e');
      return const Left(GeneralFailure('Unable to delete from drive'));
    }
  }

  Future<AuthClient?> initializeAuthClient() async {
    AuthClient? authClient;
    await _googleSignIn.signInSilently();
    final GoogleSignInAccount? googleUser = _googleSignIn.currentUser;
    if (googleUser == null) return authClient;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    if (googleAuth.accessToken == null) {
      return authClient;
    }

    // Create AccessCredentials using the GoogleAuth object
    final accessCredentials = AccessCredentials(
      AccessToken('Bearer', googleAuth.accessToken!,
          DateTime.now().toUtc().add(const Duration(hours: 1))),
      null,
      ['https://www.googleapis.com/auth/drive.file'],
    );
    final httpClient = IOClient();
    authClient = authenticatedClient(httpClient, accessCredentials);
    return authClient;
  }

  @override
  Future<Either<Failure, void>> restoreBackupFromGoogleDrive() async {
    try {
      String fileName = 'app_database.db';

      final authClient = await initializeAuthClient();

      if (authClient == null) {
        return const Left(GeneralFailure('Unable to restore backup'));
      }

      final driveApi = drive.DriveApi(authClient);

      final existingFiles = await driveApi.files.list(
        q: "name = '$fileName' and trashed = false",
        spaces: 'drive',
      );

      if (existingFiles.files == null || existingFiles.files!.isEmpty) {
        return const Left(GeneralFailure('No backup found'));
      }

      // Get the file ID from Google Drive
      final fileId = existingFiles.files!.first.id!;
      final media = await driveApi.files.get(fileId,
          downloadOptions: drive.DownloadOptions.fullMedia) as drive.Media;

      // Save the downloaded file to a temporary location
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/$fileName');

      // Write the downloaded content to the temp file
      final fileStream = media.stream;
      await fileStream.listen((data) {
        tempFile.writeAsBytesSync(data, mode: FileMode.append);
      }).asFuture();

      // Restore the database from the downloaded backup file
      await dbHelper.restoreDatabase(tempFile);

      return const Right(null); // Successfully restored
    } catch (e) {
      print('Error restoring file: $e');
      return const Left(GeneralFailure('Unable to restore backup'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteBackupFromiCloud() async {
    try {
      final completer = Completer<void>();

      final existingFiles = await ICloudStorage.gather(
        containerId: 'iCloud.com.abdulmuizdev.carmaai',
        onUpdate: (stream) {
          stream.listen((updatedFileList) {
            print('FILES UPDATED');
            updatedFileList.forEach((file) => print('-- ${file.relativePath}'));
            completer.complete();
          }, onError: (err) {
            completer.completeError(err);
          });
        },
      );
      print('FILES GATHERED');
      await completer.future;

      // TODO: Do necessary null check error handling
      if (existingFiles.isNotEmpty) {
        // Delete the file
        final relativePath = existingFiles.first.relativePath;
        await ICloudStorage.delete(
          containerId: 'iCloud.com.abdulmuizdev.carmaai',
          relativePath: relativePath,
        );
        print('Deleted file ID: $relativePath');
      } else {
        return const Left(GeneralFailure('File not found on iCloud'));
      }

      return const Right(unit);
    } catch (e) {
      print('Error deleting file: $e');
      return const Left(GeneralFailure('Unable to delete from iCloud'));
    }
  }

  @override
  Future<Either<Failure, void>> restoreBackupFromiCloud() async {
    try {
      final completer = Completer<void>();

      final existingFiles = await ICloudStorage.gather(
        containerId: 'iCloud.com.abdulmuizdev.carmaai',
        onUpdate: (stream) {
          stream.listen((updatedFileList) {
            print('FILES UPDATED');
            updatedFileList.forEach((file) => print('-- ${file.relativePath}'));
            completer.complete();
          }, onError: (err) {
            completer.completeError(err);
          });
        },
      );
      print('FILES GATHERED');
      await completer.future;

      if (existingFiles.isEmpty) {
        return const Left(GeneralFailure('No backup found'));
      }

      // Get the file ID from Google Drive
      final relativePath = existingFiles.first.relativePath;

      // Save the downloaded file to a temporary location
      final tempDir = await getTemporaryDirectory();

      final completer2 = Completer<void>();
      String fileName = 'app_database.db';
      String destinationFilePath =
          '${tempDir.path}/$fileName'; // Full file path
      await ICloudStorage.download(
        containerId: 'iCloud.com.abdulmuizdev.carmaai',
        relativePath: relativePath,
        destinationFilePath: destinationFilePath,
        onProgress: (stream) {
          stream.listen(
            (progress) => print('Download File Progress: $progress'),
            onDone: () {
              print('Download File Done');
              completer2.complete();
            },
            onError: (err) {
              print('Download File Error: $err');
              completer2.completeError(err);
            },
            cancelOnError: true,
          );
        },
      );
      await completer2.future;
      final tempFile = File('${tempDir.path}/$fileName');

      // Restore the database from the downloaded backup file
      await dbHelper.restoreDatabase(tempFile);

      return const Right(unit); // Successfully restored
    } catch (e) {
      print('Error restoring file: $e');
      return const Left(GeneralFailure('Unable to restore backup'));
    }
  }

  @override
  Future<Either<Failure, void>> uploadBackupToiCloud() async {
    try {
      File file = await dbHelper.getDatabaseBackupFile();

      if (!await file.exists()) {
        return const Left(GeneralFailure('Backup file does not exist'));
      }

      final completer = Completer<void>();

      final result = await ICloudStorage.gather(
          containerId: 'iCloud.com.abdulmuizdev.carmaai');
      print(result);
      if (result.isNotEmpty) {
        print(result[0]);
      }

      // Upload to iCloud Documents
      await ICloudStorage.upload(
        containerId: 'iCloud.com.abdulmuizdev.carmaai',
        filePath: file.path,
        onProgress: (stream) {
          stream.listen(
            (value) {
              print('Received: $value');
            },
            onDone: () async {
              print('Stream is done');
              final existingFiles = await ICloudStorage.gather(
                containerId: 'iCloud.com.abdulmuizdev.carmaai',
              );
              print('FILES GATHERED');
              existingFiles.forEach((file) => print('-- ${file.relativePath}'));

              await flutterSecureStorage.write(
                  key: Constants.LAST_BACKUP,
                  value: DateFormat('dd MMM HH:mm').format(DateTime.now()));

              completer.complete();
            },
            onError: (error) {
              print('Stream error: $error');
              completer.completeError(error);
            },
          );
        },
      );
      print('upload method completed but upload in progress');
      await completer.future;
      print('everything is good to go');
      return const Right(unit);
    } catch (e) {
      print('Error uploading file: $e');
      return const Left(GeneralFailure('Unable to backup to iCloud'));
    }
  }
}

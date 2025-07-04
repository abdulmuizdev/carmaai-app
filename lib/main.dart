import 'dart:io';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:carma/features/backup/domain/use_cases/upload_backup_to_icloud_use_case.dart';
import 'package:carma/core/di/injection.dart';
import 'package:carma/features/splash/presentation/pages/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'features/backup/domain/use_cases/upload_backup_to_google_drive_use_case.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await requestATT();
  await setupLocator();
  // final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  //     FlutterLocalNotificationsPlugin();
  // const DarwinInitializationSettings darwinInitializationSettings =
  //     DarwinInitializationSettings(
  //   requestAlertPermission: true, // Request permission to show alerts
  //   requestBadgePermission: true, // Request permission to show badges
  //   requestSoundPermission: true, // Request permission to play sound
  // );
  // const AndroidInitializationSettings androidInitializationSettings =
  //     AndroidInitializationSettings('launch_background');
  //
  // const InitializationSettings initializationSettings = InitializationSettings(
  //   android: androidInitializationSettings,
  //   iOS: darwinInitializationSettings,
  // );
  //
  // await flutterLocalNotificationsPlugin.initialize(initializationSettings);

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // final backupResults =
  //     await locator<UploadBackupToGoogleDriveUseCase>().execute();
  // await backupResults.fold((left) async {
  //   print('Uploading backup failed: ${left.message}');
  //
  //   // try uploading to iCloud
  //   final backupResults2 = await locator<UploadBackupToIcloudUseCase>().execute();
  //   backupResults2.fold((left){
  //     print('Unable to upload to iCloud also');
  //   }, (right){
  //     print('Uploaded backup to iCloud');
  //   });
  // }, (right) {
  //   print('Uploaded backup to drive');
  // });
  runApp(const MyApp());
}
//
// Future<void> initPlatformState() async {
//   await Purchases.setLogLevel(LogLevel.debug);
//
//   PurchasesConfiguration configuration;
//   if (Platform.isIOS) {
//     configuration = PurchasesConfiguration('appl_ZNhrDjGsdyVAnwAmpYRrOjoJaAm');
//     await Purchases.configure(configuration);
//   }
// }

Future<void> requestATT() async {
  if (Platform.isIOS) {
    final status = await AppTrackingTransparency.trackingAuthorizationStatus;

    if (status == TrackingStatus.notDetermined) {
      final newStatus = await AppTrackingTransparency.requestTrackingAuthorization();
      print("Tracking permission: $newStatus");
    }
  }
}

@override
void dispose() {
  locator.reset(); // This will close any registered resources like DbHelper
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        indicatorColor: Colors.white,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}

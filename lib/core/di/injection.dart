import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:carma/app/app.dart';
import 'package:carma/common/domain/use_cases/restore_backup_from_icloud_use_case.dart';
import 'package:carma/common/presentation/bloc/google_sign_in_bloc.dart';
import 'package:carma/core/constants/constants.dart';
import 'package:carma/core/db/db_helper.dart';
import 'package:carma/features/add_financial_screen/data/data_sources/financial_type_data_source.dart';
import 'package:carma/features/add_financial_screen/data/data_sources/transaction_data_source.dart';
import 'package:carma/features/add_financial_screen/data/repositories/financial_type_repository_impl.dart';
import 'package:carma/features/add_financial_screen/data/repositories/transaction_repository_impl.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/financial_type_repository.dart';
import 'package:carma/features/add_financial_screen/domain/repositories/transaction_repository.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/delete_transaction_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/get_current_month_financials_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/get_expense_types_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/get_income_types_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/get_transactions_use_case.dart';
import 'package:carma/features/add_financial_screen/domain/use_cases/save_transaction_use_case.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/financial_type/financial_type_bloc.dart';
import 'package:carma/features/add_financial_screen/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:carma/features/backup/domain/use_cases/delete_backup_from_icloud_use_case.dart';
import 'package:carma/features/backup/domain/use_cases/upload_backup_to_icloud_use_case.dart';
import 'package:carma/features/charts/data/data_sources/Catag_wise_amount_data_source.dart';
import 'package:carma/features/charts/data/data_sources/lifetime_financials_data_source.dart';
import 'package:carma/features/charts/data/data_sources/month_wise_financials_data_source.dart';
import 'package:carma/features/charts/data/repositories/catag_wise_amount_repository_impl.dart';
import 'package:carma/features/charts/data/repositories/lifetime_financials_repository_impl.dart';
import 'package:carma/features/charts/data/repositories/month_wise_financials_repository_impl.dart';
import 'package:carma/features/charts/domain/repositories/catag_wise_amount_repository.dart';
import 'package:carma/features/charts/domain/repositories/lifetime_financials_repository.dart';
import 'package:carma/features/charts/domain/repositories/month_wise_financials_repository.dart';
import 'package:carma/features/charts/domain/use_cases/get_categ_wise_amount_expense_use_case.dart';
import 'package:carma/features/charts/domain/use_cases/get_categ_wise_amount_income_use_case.dart';
import 'package:carma/features/charts/domain/use_cases/get_lifetime_financials_use_case.dart';
import 'package:carma/features/charts/domain/use_cases/get_month_wise_financials_use_case.dart';
import 'package:carma/features/charts/presentation/bloc/catag_wise_amount/catag_wise_amount_bloc.dart';
import 'package:carma/features/charts/presentation/bloc/month_wise_financials/month_wise_financials_bloc.dart';
import 'package:carma/common/domain/use_cases/restore_backup_from_google_drive_use_case.dart';
import 'package:carma/features/google_sign_in/data/data_sources/google_sign_in_data_source.dart';
import 'package:carma/features/google_sign_in/data/repositories/google_sign_in_repository_impl.dart';
import 'package:carma/features/google_sign_in/domain/repositories/google_sign_in_repository.dart';
import 'package:carma/features/google_sign_in/domain/use_cases/google_sign_in_use_case.dart';
import 'package:carma/features/google_sign_in/domain/use_cases/google_sign_out_use_case.dart';
import 'package:carma/features/google_sign_in/domain/use_cases/is_user_signed_in_use_case.dart';
import 'package:carma/features/odometer/data/data_sources/odometer_data_source.dart';
import 'package:carma/features/odometer/data/repositories/odometer_repository_impl.dart';
import 'package:carma/features/odometer/domain/repositories/odometer_repository.dart';
import 'package:carma/features/odometer/domain/use_cases/analyze_odometer_with_ai_use_case.dart';
import 'package:carma/features/odometer/domain/use_cases/get_odometer_reading_use_case.dart';
import 'package:carma/features/odometer/domain/use_cases/update_odometer_reading_use_case.dart';
import 'package:carma/features/odometer/presentation/bloc/odometer_bloc.dart';
import 'package:carma/features/profile/data/data_sources/profile_data_source.dart';
import 'package:carma/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:carma/features/profile/domain/repositories/profile_repository.dart';
import 'package:carma/features/profile/domain/use_cases/get_signed_in_user_info_use_case.dart';
import 'package:carma/features/profile/presentation/bloc/profile_bloc.dart';
import 'package:carma/features/rate_app_service/rate_app_service.dart';

// import 'package:carma/features/reminder/main/presentation/bloc/reminder/reminder_bloc.dart';
import 'package:carma/features/settings/data/data_sources/settings_data_source.dart';
import 'package:carma/features/settings/data/repositories/settings_repository_impl.dart';
import 'package:carma/features/settings/domain/repositories/settings_repository.dart';
import 'package:carma/features/settings/domain/use_cases/change_sound_effect_settings_use_case.dart';
import 'package:carma/features/settings/domain/use_cases/delete_all_data_use_case.dart';
import 'package:carma/features/settings/domain/use_cases/get_sound_effect_setting_use_case.dart';
import 'package:carma/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:carma/features/splash/data/data_sources/initialization_data_source.dart';
import 'package:carma/features/splash/data/repositories/initialize_repository_impl.dart';
import 'package:carma/features/splash/domain/repositories/initialize_repository.dart';
import 'package:carma/features/splash/domain/use_cases/initialize_categories_use_case.dart';
import 'package:carma/features/splash/presentation/bloc/initialize_categories_bloc.dart';
import 'package:carma/features/subscription/controller/subscription_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:mixpanel_flutter/mixpanel_flutter.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../features/backup/data/data_sources/backup_data_source.dart';
import '../../features/backup/data/repositories/backup_repository_impl.dart';
import '../../features/backup/domain/repositories/backup_repository.dart';
import '../../features/backup/domain/use_cases/delete_backup_from_google_drive_use_case.dart';
import '../../features/backup/domain/use_cases/upload_backup_to_google_drive_use_case.dart';

final locator = GetIt.instance;

Future<void> setupLocator() async {
  locator.registerSingleton<App>(App());

  // locator.registerFactory(() => ReminderBloc());

  locator.registerLazySingleton(() => DbHelper());
  locator.registerFactory(() => http.Client());
  locator.registerFactory(() => const FlutterSecureStorage());
  locator.registerLazySingleton(
    () => GoogleSignIn(
      scopes: [
        Constants.SCOPE_EMAIL,
        Constants.SCOPE_DRIVE,
      ],
    ),
  );
  locator.registerSingletonAsync<Mixpanel>(() async {
    final mixpanel = await Mixpanel.init("c9c9819d3660d58c159c596ec1f31fc5",
        trackAutomaticEvents: false);
    if (await AppTrackingTransparency.trackingAuthorizationStatus ==
        TrackingStatus.denied) {
      mixpanel.optOutTracking();
    }
    return mixpanel;
  });

  locator.registerSingletonAsync<PackageInfo>(() async {
    final packageInfo = await PackageInfo.fromPlatform();
    return packageInfo;
  });

  locator.registerSingletonAsync<SharedPreferences>(() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs;
  });

  await locator.allReady();

  locator.registerFactory(
      () => TransactionBloc(locator(), locator(), locator(), locator()));
  locator.registerFactory(() => GetCurrentMonthFinancialsUseCase(locator()));
  locator.registerFactory(() => GetTransactionsUseCase(locator()));
  locator.registerFactory(() => SaveTransactionUseCase(locator()));
  locator.registerFactory(() => DeleteTransactionUseCase(locator()));
  locator.registerFactory<TransactionRepository>(
      () => TransactionRepositoryImpl(locator()));
  locator.registerFactory<TransactionDataSource>(
      () => TransactionDataSourceImpl(locator()));

  locator.registerFactory(() => InitializeCategoriesBloc(locator()));
  locator.registerFactory(() => InitializeCategoriesUseCase(locator()));
  locator.registerFactory<InitializeRepository>(
      () => InitializeRepositoryImpl(locator()));
  locator.registerFactory<InitializationDataSource>(
      () => InitializationDataSourceImpl(locator()));

  locator.registerFactory(() => FinancialTypeBloc(locator(), locator()));
  locator.registerFactory(() => GetIncomeTypesUseCase(locator()));
  locator.registerFactory(() => GetExpenseTypesUseCase(locator()));
  locator.registerFactory<FinancialTypeRepository>(
      () => FinancialTypeRepositoryImpl(locator()));
  locator.registerFactory<FinancialTypeDataSource>(
      () => FinancialTypeDataSourceImpl(locator()));

  locator.registerFactory(() => CategoryWiseAmountBloc(locator(), locator()));
  locator.registerFactory(() => GetCategoryWiseAmountExpenseUseCase(locator()));
  locator.registerFactory(() => GetCategoryWiseAmountIncomeUseCase(locator()));
  locator.registerFactory<CatagWiseAmountRepository>(
      () => CatagWiseAmountRepositoryImpl(locator()));
  locator.registerFactory<CatagWiseAmountDataSource>(
      () => CatagWiseAmountDataSourceImpl(locator()));

  locator.registerFactory(() => MonthWiseFinancialsBloc(locator(), locator()));
  locator.registerFactory(() => GetMonthWiseFinancialsUseCase(locator()));
  locator.registerFactory(() => GetLifetimeFinancialsUseCase(locator()));
  locator.registerFactory<MonthWiseFinancialsRepository>(
      () => MonthWiseFinancialsRepositoryImpl(locator()));
  locator.registerFactory<MonthWiseFinancialsDataSource>(
      () => MonthWiseFinancialsDataSourceImpl(locator()));
  locator.registerFactory<LifetimeFinancialsRepository>(
      () => LifetimeFinancialsRepositoryImpl(locator()));
  locator.registerFactory<LifeTimeFinancialsDataSource>(
      () => LifeTimeFinancialsDataSourceImpl(locator()));

  locator.registerFactory(() => SettingsBloc(locator(), locator(), locator()));
  locator.registerFactory(() => ChangeSoundEffectSettingsUseCase(locator()));
  locator.registerFactory(() => GetSoundEffectSettingUseCase(locator()));
  locator.registerFactory(() => DeleteAllDataUseCase(locator()));
  locator.registerFactory<SettingsRepository>(
      () => SettingsRepositoryImpl(locator()));
  locator.registerFactory<SettingsDataSource>(
      () => SettingsDataSourceImpl(locator(), locator()));

  locator.registerFactory(() => OdometerBloc(locator(), locator(), locator()));
  locator.registerFactory(() => GetOdometerReadingUseCase(locator()));
  locator.registerFactory(() => UpdateOdometerReadingUseCase(locator()));
  locator.registerFactory(() => AnalyzeOdometerWithAiUseCase(locator()));
  locator.registerFactory<OdometerRepository>(
      () => OdometerRepositoryImpl(locator()));
  locator.registerFactory<OdometerDataSource>(
      () => OdometerDataSourceImpl(locator(), locator()));

  locator.registerFactory(() =>
      GoogleSignInBloc(locator(), locator(), locator(), locator(), locator(), locator()));
  locator.registerFactory(() => GoogleSignInUseCase(locator()));
  locator.registerFactory(() => GoogleSignOutUseCase(locator()));
  locator.registerFactory(() => IsUserSignedInUseCase(locator()));
  locator.registerFactory<GoogleSignInRepository>(
      () => GoogleSignInRepositoryImpl(locator()));
  locator.registerFactory<GoogleSignInDataSource>(
      () => GoogleSignInDataSourceImpl(locator(), locator()));

  locator.registerFactory(() => ProfileBloc(locator()));
  locator.registerFactory(() => GetSignedInUserInfoUseCase(locator()));
  locator.registerFactory<ProfileRepository>(
      () => ProfileRepositoryImpl(locator()));
  locator.registerFactory<ProfileDataSource>(
      () => ProfileDataSourceImpl(locator(), locator()));

  locator.registerFactory(() => UploadBackupToGoogleDriveUseCase(locator()));
  locator.registerFactory(() => DeleteBackupFromGoogleDriveUseCase(locator()));
  locator.registerFactory(() => RestoreBackupFromGoogleDriveUseCase(locator()));

  locator.registerFactory(() => UploadBackupToIcloudUseCase(locator()));
  locator.registerFactory(() => DeleteBackupFromIcloudUseCase(locator()));
  locator.registerFactory(() => RestoreBackupFromIcloudUseCase(locator()));
  locator.registerFactory<BackupRepository>(
      () => BackupRepositoryImpl(locator()));
  locator.registerFactory<DriveBackupDataSource>(
      () => DriveBackupDataSourceImpl(locator(), locator(), locator()));

  locator.registerSingleton(SubscriptionController());
}

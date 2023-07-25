import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/Dio/dio_client.dart';
import 'package:light_fair_bd_new/data/datasource/apiservices/Dio/logging_interceptor.dart';
import 'package:light_fair_bd_new/provider/FormProvider.dart';
import 'package:light_fair_bd_new/provider/auth_provider.dart';
import 'package:light_fair_bd_new/provider/employee_provider.dart';
import 'package:light_fair_bd_new/provider/localization_provider.dart';
import 'package:light_fair_bd_new/provider/mobil_feed_provider.dart';
import 'package:light_fair_bd_new/provider/order_provider.dart';
import 'package:light_fair_bd_new/provider/theme_provider.dart';
import 'package:light_fair_bd_new/repository/auth_repo.dart';
import 'package:light_fair_bd_new/repository/employee_repo.dart';
import 'package:light_fair_bd_new/repository/mobil_feed_repo.dart';
import 'package:light_fair_bd_new/util/app_constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  sl.registerLazySingleton(() => DioClient(
        AppConstants.baseUrl,
        sl(),
        loggingInterceptor: sl(),
        sharedPreferences: sl(),
      ));

  //Repository
  sl.registerLazySingleton(() => AuthRepo(dioClient: sl(), sharedPreferences: sl()));

  sl.registerLazySingleton(() => EmployeeRepo(
        dioClient: sl(),
      ));
  sl.registerLazySingleton(() => MobilFeedRepo(
        dioClient: sl(),
      ));

//Provider
  sl.registerFactory(() => UserConfigurationProvider(
        sl(),
        authRepo: sl(),
        mobilFeedRepo: sl(),
      ));
  sl.registerLazySingleton(() => OrderProvider(employeeRepo: sl()));
  sl.registerLazySingleton(() => ThemeProvider(sharedPreferences: sl()));
  sl.registerFactory(() => LocalizationProvider(sharedPreferences: sl()));
  sl.registerLazySingleton(() => FormProvider());
  sl.registerLazySingleton(() => EmployeeProvider(employeeAttendanceRepo: sl()));
  sl.registerFactory(() => MobilFeedProvider(mobilFeedRepo: sl()));

  // External

  final sharedPreference = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreference);
  sl.registerLazySingleton(() => Dio());
  sl.registerLazySingleton(() => LoggingInterceptor());
}

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:pliiz_web/provider/main_provider.dart';
import 'package:pliiz_web/provider/navbar_screen_provider.dart';

GetIt locator = GetIt.instance;

void setupLocator() {
  locator.registerFactory(() => MainProvider());
  locator.registerFactory(() => NavBarScreenProvider());
  locator.registerLazySingleton<Dio>(() {
    Dio dio = Dio();
    dio.interceptors.add(LogInterceptor(requestBody: true, responseBody: true));
    return dio;
  });
}

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:oktoast/oktoast.dart';
import 'package:pliiz_web/helpers/routes.dart';
import 'package:pliiz_web/locator.dart';
import 'constants/app_colors.dart';
import 'screens/auth/auth_screen.dart';
import 'package:url_strategy/url_strategy.dart';

late GetStorage box;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  await Firebase.initializeApp(
      options: const FirebaseOptions(
          apiKey: "AIzaSyAxeuOAKY39WvPl-izvNkJfPgRJf6wvOTQ",
          authDomain: "pliiz-30879.firebaseapp.com",
          projectId: "pliiz-30879",
          storageBucket: "pliiz-30879.appspot.com",
          messagingSenderId: "108074233779",
          databaseURL: "https://pliiz-30879-default-rtdb.firebaseio.com",
          appId: "1:108074233779:web:c579f80e841678b87165c6"));
  await GetStorage.init();
  box = GetStorage('MyStorage');
  runApp(const MyApp());
  setupLocator();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.landscapeLeft,
        DeviceOrientation.landscapeRight,
      ],
    );
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        systemNavigationBarColor: AppColors.blackColor.withOpacity(0.01),
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    return OKToast(
      child: GetMaterialApp(
          title: 'Pliiz',
          debugShowCheckedModeBanner: false,
          getPages: allPages,
          theme: ThemeData(
            primarySwatch: Colors.red,
            primaryColor: AppColors.primaryColor,
            scaffoldBackgroundColor: AppColors.whiteColor,
            splashColor: Colors.orange,
          ),
          home: const AuthScreen(),
          ),
    );
  }
}

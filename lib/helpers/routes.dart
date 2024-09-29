import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/screens/auth/auth_screen.dart';
import 'package:pliiz_web/screens/auth/views/forget_password_page.dart';
import 'package:pliiz_web/screens/auth/views/verifcation_done_page.dart';
import 'package:pliiz_web/screens/cleints/detail_page.dart';
import 'package:pliiz_web/screens/cleints/veiw_menu.dart';
import 'package:pliiz_web/screens/nav_bar/nav_bar_screen.dart';
import '../controllers/auth_controller.dart';
import '../screens/cleints/employee_home.dart';

RoutKeys keys = RoutKeys();

List<GetPage> allPages = [
  GetPage(
      name: keys.homePage,
      page: () => const NavBarScreen(),
      middlewares: [
        AuthMiddleware(),
      ]
  ),
  GetPage(
      name: keys.verificationPage,
      page: () => const VerificationDonePage()
  ),
  GetPage(
      name: keys.verificationPage,
      page: () => const VerificationDonePage()
  ),
  GetPage(
      name: keys.forgetPasswordPage,
      page: () => const ForgetPasswordPage()
  ),
  GetPage(
      name: keys.detailPagePage,
      page: () => const DetailPage()
  ),
  GetPage(
      name: keys.loginPage,
      page: () => const AuthScreen()
  ),
  GetPage(
      name: keys.viewMenuPage,
      page: () => const ViewMenuPage()
  ),
  GetPage(
      name: keys.employeePage,
      page: () => const EmployeeHomePage()
  ),
];


class AuthMiddleware extends GetMiddleware {
  final auth = Get.put(AuthController());
  @override
  RouteSettings? redirect(String? route) {
    if(auth.auth.currentUser != null){
      return null;
    }else {
      return RouteSettings(name: RoutKeys().loginPage);
    }
  }
}


class RoutKeys {
  final String homePage = "/home";
  final String loginPage = "/login";
  final String signUpPage = "/sigup";
  //final String industryPage = "/industry";
  final String verificationPage = "/verification";
  final String forgetPasswordPage = "/account_recovery";
  final String detailPagePage = "/d";
  final String viewMenuPage = "/view";
  final String viewPdfEmp = "/employee/pdf";
  final String employeePage = "/employee";
}





import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/exports.dart';
import 'package:pliiz_web/controllers/auth_controller.dart';
import 'package:pliiz_web/screens/auth/views/signup_view.dart';

import 'views/login_view.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return GetBuilder(
        init: controller,
        builder: (_) {
          return Scaffold(
            body: Container(
              alignment: Alignment.center,
              margin: const EdgeInsets.all(16),
              child: ListView(
                shrinkWrap: true,
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 10,
                    runSpacing: 10,
                    children: [
                      Container(
                        width: w > 700 ? w / 2 - 150 : Get.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SvgPicture.asset(AppIcons.appIcon),
                            SizedBox(height: height(context) * 0.035),
                            Text(
                              'Let’s Know More\nabout us!',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                fontSize: height(context) * 0.063,
                                fontWeight: FontWeight.w700,
                                color:
                                    AppColors.secondaryColor.withOpacity(0.9),
                              ),
                            ),
                            SizedBox(height: height(context) * 0.003),
                            Text(
                              'Quia veritatis qui aut magnam rerum animi omnis exercitationem. Minus sapiente suscipit quaerat sint. '
                              'Possimus omnis vel ullam officiis. Itaque maxime asperiores omnis qui odio sunt hic. '
                              'Et ea tenetur pariatur dolorum est corrupti nostrum.',
                              textAlign: TextAlign.end,
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackColor.withOpacity(0.5),
                                fontSize: height(context) * 0.024,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        width: w > 700 ? w / 2 - 50 : w,
                        decoration: BoxDecoration(
                          color: AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(28.0),
                          boxShadow: shadowsOne,
                        ),
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.only(bottom: 40.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: w > 700 ? w / 2 - 150 : w,
                                decoration: BoxDecoration(
                                  color:
                                      AppColors.secondaryColor.withOpacity(0.3),
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(28.0),
                                    topLeft: Radius.circular(28.0),
                                  ),
                                ),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    TextButton(
                                      onPressed: () =>
                                          controller.changeView(state: true),
                                      autofocus: true,
                                      child: Text(
                                        'Login',
                                        style: montserratSemiBold.copyWith(
                                          fontSize: height(context) * 0.027,
                                          color: controller.isLoginView.value ==
                                                  true
                                              ? AppColors.whiteColor
                                              : AppColors.whiteColor
                                                  .withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: height(context) * 0.05),
                                    TextButton(
                                      onPressed: () => controller.changeView(state: false),
                                      autofocus: true,
                                      child: Text(
                                        'Register',
                                        style: montserratRegular.copyWith(
                                          fontSize: height(context) * 0.027,
                                          color: controller.isLoginView.value == true ? AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.4),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                               controller.isLoginView.value?
                              const LoginView()
                               :const SignupView(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

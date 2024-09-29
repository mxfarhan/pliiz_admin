import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/auth_controller.dart';
import 'package:pliiz_web/model/enums/viewstate.dart';
import 'package:pliiz_web/helpers/routes.dart';
import '../../../constants/exports.dart';
import '../../../widgets/custom_text_field.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);
  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final mailController = TextEditingController();
  final passwordController = TextEditingController();
  final login = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: login,
      builder: (_) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Visibility(
              visible: login.loginAsEmployee,
              child:  Text('Login As Employee',
              style: montserratBold.copyWith(
                fontSize: 16.0,
                fontWeight: FontWeight.w700,
                color: AppColors.whiteColor,
              ),
            ),),
            SizedBox(height: height(context) * 0.036),
            CustomTextField(
              controller: mailController,
              fieldColor: AppColors.whiteColor,
              fieldShadow: shadowsOne,
              obscureText: false,
              validator: (val) => val!.isEmpty ? 'Required' : null,
              suffixIcon: IconButton(
                onPressed: () {},
                icon: SvgPicture.asset(AppIcons.mailIcon),
              ),
              labelText: 'Email',
              hintText: 'Please enter your email',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor,
            ),

            /// pass field
            SizedBox(height: height(context) * 0.024),
            CustomTextField(
              controller: passwordController,
              fieldColor: AppColors.whiteColor,
              fieldShadow: shadowsOne,
              validator: (val) => val!.isEmpty ? 'Required' : null,
              obscureText: !login.showPassword,
              suffixIcon: IconButton(
                onPressed: login.changeShowPasswordState,
                icon: SvgPicture.asset(AppIcons.lockIcon),
              ),
              labelText: 'Password',
              hintText: 'Please enter your password',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor,
            ),

            /// forgot pass
            SizedBox(height: height(context) * 0.02),
            Padding(
              padding: EdgeInsets.symmetric(
                  horizontal: height(context) * 0.03),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 16.0,
                    width: 16.0,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.checkColor,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check,
                        color: AppColors.whiteColor,
                        size: 12.0,
                      ),
                    ),
                  ),
                  SizedBox(width: height(context) * 0.008),
                  Text(
                    'Remember me',
                    style: montserratRegular.copyWith(
                      fontSize: 12.0,
                      color: AppColors.whiteColor,
                    ),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Get.toNamed(RoutKeys().forgetPasswordPage),
                    child: Text(
                      'Forgot Password?',
                      style: montserratRegular.copyWith(
                        fontSize: 12.0,
                        color: AppColors.whiteColor.withOpacity(0.6),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height(context) * 0.1),

            /// login btn
            login.viewState == ViewState.busy
                ? const Center(
              child: CircularProgressIndicator(
                color: Colors.white,
              ),
            )
                : Bounceable(
              onTap: () => login.handleLogin(email: mailController.text, password: passwordController.text),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: height(context) * 0.07,
                    vertical: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: AppColors.whiteColor,
                  boxShadow: shadowsOne,
                ),
                child: Text('Login',
                  style: montserratBold.copyWith(
                    fontSize: 16.0,
                    color: AppColors.secondaryColor,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 19),
            Bounceable(
              onTap: () => login.changeType(true),
              child: Container(
                padding: EdgeInsets.symmetric(
                    horizontal: height(context) * 0.07,
                    vertical: 12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40.0),
                  color: Colors.red,
                  boxShadow: shadowsOne,
                ),
                child: Text(login.loginAsEmployee?"Login as Admin":'Login as Employee',
                  style: montserratBold.copyWith(
                    fontSize: 16.0,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
            /// login with social media btns
            // SizedBox(height: height(context) * 0.07),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Login with:',
            //       style: montserratRegular.copyWith(
            //         fontSize: 14.0,
            //         color: AppColors.whiteColor.withOpacity(0.5),
            //       ),
            //     ),
            //     SizedBox(width: height(context) * 0.01),
            //     Bounceable(
            //       onTap: login.handleGoogleSignUp,
            //       child: Container(
            //         height: height(context) * 0.06,
            //         width: height(context) * 0.06 + 100,
            //         decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(20),
            //           color: AppColors.whiteColor,
            //           boxShadow: shadowsOne,
            //         ),
            //         child: Row(
            //           mainAxisAlignment: MainAxisAlignment.center,
            //           children: [
            //             SvgPicture.asset(AppIcons.googleIcon),
            //             const SizedBox(width: 10),
            //             const Text("Google",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w700),),
            //           ],
            //         ),
            //       ),
            //     ),
            //     SizedBox(width: height(context) * 0.014),
            //   ],
            // ),
          ],
        );
      }
    );
  }
}

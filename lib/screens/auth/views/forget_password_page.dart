import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/auth_controller.dart';
import 'package:pliiz_web/model/enums/viewstate.dart';
import 'package:pliiz_web/widgets/custom_text_field.dart';
import '../../../constants/exports.dart';

class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({Key? key}) : super(key: key);

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  final login = Get.put(AuthController());
  final mailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    return GetBuilder(
        init: login,
        builder: (_) {
          return Scaffold(
            /// body
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
                            width: w> 700?w/2 - 150: Get.width,
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
                                    color: AppColors.secondaryColor.withOpacity(0.9),
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
                            width: w> 700?w/2 - 150: Get.width,
                            margin: EdgeInsets.symmetric(vertical: height(context) * 0.09),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(28.0),
                              boxShadow: shadowsOne,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(height: 60),
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
                                const SizedBox(height: 60),
                                login.viewState == ViewState.busy
                                    ? const Center(
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                                    : Bounceable(
                                  onTap: () {},
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: height(context) * 0.07,
                                        vertical: 12.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(40.0),
                                      color: AppColors.whiteColor,
                                      boxShadow: shadowsOne,
                                    ),
                                    child: Text('Send Recovery Email',
                                      style: montserratBold.copyWith(
                                        fontSize: 16.0,
                                        color: AppColors.secondaryColor,
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Bounceable(
                                  onTap: () => Get.back(),
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
                                const SizedBox(height: 60),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ]),
              )
          );
        }
    );
  }
}

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/model/enums/viewstate.dart';
import 'package:pliiz_web/model/user_model.dart';

import '../../../constants/exports.dart';
import '../../../controllers/auth_controller.dart';
import '../../../widgets/custom_text_field.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SignupView extends StatefulWidget {
  const SignupView({Key? key}) : super(key: key);

  @override
  State<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends State<SignupView> {
  final login = Get.put(AuthController());

  final companyController = TextEditingController();
  final contactNameController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final countryController = TextEditingController();
  final mailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  final AuthController controller = Get.put(AuthController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
        init: login,
        builder: (_) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// company field
              SizedBox(height: height(context) * 0.036),
              CustomTextField(
                controller: companyController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: false,
                validator: (val) => val!.isEmpty ? 'Required' : null,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.companyIcon),
                ),
                labelText: 'Company Name',
                hintText: 'Haider Graphics',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// contact name field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                controller: contactNameController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: false,
                validator: (val) => val!.isEmpty ? 'Required' : null,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.contactIcon),
                ),
                labelText: 'Contact Name',
                hintText: 'Enter Contact Name',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// address field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                validator: (val) => val!.isEmpty ? 'Required' : null,
                controller: addressController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: false,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.addressIcon),
                ),
                labelText: 'Address',
                hintText: 'Enter Company Address',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// city field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                validator: (val) => val!.isEmpty ? 'Required' : null,
                controller: cityController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: false,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.cityIcon),
                ),
                labelText: 'City',
                hintText: 'Enter City',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// Country field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                validator: (val) => val!.isEmpty ? 'Required' : null,
                controller: countryController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: false,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.countryIcon),
                ),
                labelText: 'Country',
                hintText: 'Enter Country',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// email field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                validator: (val) => val!.isEmpty ? 'Required' : null,
                controller: mailController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: false,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.mailIcon),
                ),
                labelText: 'Email',
                hintText: 'Enter Your Email',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// phone field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                validator: (val) => val!.isEmpty ? 'Required' : null,
                controller: phoneController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: false,
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.phoneIcon),
                ),
                labelText: 'Phone',
                hintText: 'Enter Phone Number',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// pass field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Required';
                  } else if (val.isNotEmpty && val.trim().length < 8) {
                    return 'Password should be eight character';
                  } else {
                    return null;
                  }
                },
                controller: passwordController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: !login.showPassword,
                suffixIcon: IconButton(
                  onPressed: login.changeShowPasswordState,
                  icon: SvgPicture.asset(AppIcons.eyeIcon),
                ),
                labelText: 'Password',
                hintText: 'Enter your password',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              /// confirm pass field
              SizedBox(height: height(context) * 0.024),
              CustomTextField(
                controller: confirmPasswordController,
                fieldColor: AppColors.whiteColor,
                fieldShadow: shadowsOne,
                obscureText: !login.showPassword,
                validator: (val) {
                  if (val!.isEmpty) {
                    return 'Required';
                  } else if (val.isNotEmpty &&
                      val.trim() != passwordController.text.trim()) {
                    return 'Password does\'t matched';
                  } else {
                    return null;
                  }
                },
                suffixIcon: IconButton(
                  onPressed: () {},
                  icon: SvgPicture.asset(AppIcons.eyeIcon),
                ),
                labelText: 'Confirm Password',
                hintText: 'Re-enter your password',
                labelTextColor: AppColors.blackColor.withOpacity(0.5),
                hintTextColor: AppColors.blackColor,
              ),

              SizedBox(height: height(context) * 0.07),
              login.viewState == ViewState.busy
                  ? const Center(
                      child: CircularProgressIndicator(
                        color: AppColors.whiteColor,
                      ),
                    )
                  : Bounceable(
                      onTap: () async {
                        UserModel user = UserModel(
                          email: mailController.text,
                          createdAt: FieldValue.serverTimestamp(),
                          address: addressController.text,
                          city: cityController.text,
                          companyName: companyController.text,
                          contactName: contactNameController.text,
                          country: countryController.text,
                          phone: phoneController.text,
                          isActive: false,
                        );
                        login.handleSignUp(
                            user: user, password: passwordController.text);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: height(context) * 0.07, vertical: 12.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: AppColors.whiteColor,
                          boxShadow: shadowsOne,
                        ),
                        child: Text(
                          'Register',
                          style: montserratBold.copyWith(
                            fontSize: 16.0,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
            ],
          );
        });
  }
}

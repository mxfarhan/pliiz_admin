import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/logo_controller.dart';

import '../../constants/exports.dart';
import '../../widgets/custom_text_field.dart';

class ActionTextDialog extends StatefulWidget {
  const ActionTextDialog({super.key});
  @override
  State<ActionTextDialog> createState() => _ActionTextDialogState();
}

class _ActionTextDialogState extends State<ActionTextDialog> {
  final logo = Get.put(LogoController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.4,
      height: Get.height * 0.30,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: height(context) * 0.03),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            'Enter Action Text',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
              fontSize: height(context) * 0.021,
            ),
          ),
          SizedBox(height: height(context) * 0.001),
          /// field
          SizedBox(
            width: height(context) * 0.5,
            child: CustomTextField(
              margin: 0.0,
              controller: logo.text,
              fieldColor:  AppColors.whiteColor,
              fieldShadow: shadowsTwo,
              obscureText: false,
              suffixIcon: null,
              labelText: 'Choose Action Text',
              hintText: 'This Text Show Above the Choices',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: height(context) * 0.02),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Bounceable(
                onTap: () => Get.back(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: height(context) * 0.03, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: AppColors.whiteColor,
                    boxShadow: shadowsOne,
                  ),
                  child: Text(
                    'Cancel',
                    style: montserratBold.copyWith(
                      fontSize: height(context) * 0.018,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 20),
              Bounceable(
                onTap: logo.addText,
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: height(context) * 0.03, vertical: 8.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: AppColors.whiteColor,
                    boxShadow: shadowsOne,
                  ),
                  child: Text(
                    'Generate',
                    style: montserratBold.copyWith(
                      fontSize: height(context) * 0.018,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: height(context) * 0.02),
        ],
      ),
    );
  }
  Widget headingText(text) {
    return Text('$text',
      style: GoogleFonts.openSans(
        fontSize: height(context) * 0.025,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }
}

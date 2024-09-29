import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/choices.controller.dart';
import 'package:pliiz_web/widgets/custom_text_field.dart';
import '../../constants/exports.dart';

class CreateChoiceDialog extends StatefulWidget {
  const CreateChoiceDialog({Key? key}) : super(key: key);
  @override
  State<CreateChoiceDialog> createState() => _CreateChoiceDialogState();
}

class _CreateChoiceDialogState extends State<CreateChoiceDialog> {
  final choice = Get.put(ChoicesController());
  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width * 0.5,
      height: Get.height * 0.60,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: height(context) * 0.03),
      child: Column(
        children: [
          Text(
            'Create New',
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
              controller: choice.title,
              fieldColor:  AppColors.whiteColor,
              fieldShadow: shadowsTwo,
              obscureText: false,
              suffixIcon: null,
              labelText: 'title',
              hintText: 'Customer take decision',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: height(context) * 0.02),
          SizedBox(
            width: height(context) * 0.5,
            child: CustomTextField(
              margin: 0.0,
              controller: choice.dialogMessage,
              fieldColor:  AppColors.whiteColor,
              fieldShadow: shadowsTwo,
              obscureText: false,
              suffixIcon: null,
              labelText: 'Dialog Message',
              hintText: 'Optional if you select file',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: height(context) * 0.02),
          SizedBox(
            width: height(context) * 0.5,
            child: CustomTextField(
              margin: 0.0,
              controller: choice.messageAfterConfirm,
              fieldColor:  AppColors.whiteColor,
              fieldShadow: shadowsTwo,
              obscureText: false,
              suffixIcon: null,
              labelText: 'Dialog Message after Confirm',
              hintText: 'Optional if you select file',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: height(context) * 0.02),
          SizedBox(
            width: height(context) * 0.5,
            child: CustomTextField(
              margin: 0.0,
              controller: choice.url,
              fieldColor:  AppColors.whiteColor,
              fieldShadow: shadowsTwo,
              obscureText: false,
              suffixIcon: null,
              labelText: 'Enter Url of Website',
              hintText: 'Enter Url of Website',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: height(context) * 0.024),
          GetBuilder(
            init: choice,
            builder: (_) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  choice.file!=null?Text(choice.name!):const Text("No File Selected"),
                  Bounceable(
                    onTap: () => choice.pickFile(),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: height(context) * 0.03, vertical: 8.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: AppColors.whiteColor,
                        boxShadow: shadowsOne,
                      ),
                      child: Text(
                        'Attach',
                        style: montserratBold.copyWith(
                          fontSize: height(context) * 0.018,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          ),
          SizedBox(height: height(context) * 0.024),
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
                onTap: () => choice.handleCreateChoice(),
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

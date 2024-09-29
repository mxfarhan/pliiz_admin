import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/model/choices_model.dart';
import 'package:pliiz_web/widgets/icon_button.dart';
import '../constants/exports.dart';

class ChoiceBox extends StatefulWidget {
  final ChoicesModel choices;
  final VoidCallback onTap;
  const ChoiceBox({Key? key,required this.choices,required this.onTap}) : super(key: key);
  @override
  State<ChoiceBox> createState() => _ChoiceBoxState();
}

class _ChoiceBoxState extends State<ChoiceBox> {
  final db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(left: 30),
        width: height(context) * 0.26,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              height: height(context) * 0.15,
              width: height(context) * 0.24,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Stack(
                children: [
                  Container(
                    height: height(context) * 0.15,
                    width: height(context) * 0.24,
                    decoration: BoxDecoration(
                      color: AppColors.greyColor,
                      borderRadius: BorderRadius.circular(24.0),
                    ),
                    child: Center(
                      child: SvgPicture.asset(
                        AppIcons.scanIcon,
                        height: height(context) * 0.1,
                        width: height(context) * 0.1,
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height(context) * 0.01),
            Text(
              widget.choices.title,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor,
                fontSize: height(context) * 0.021,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'info: ',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor,
                      fontSize: height(context) * 0.017,
                    ),
                  ),
                  TextSpan(
                    text: widget.choices.dialogMessage.isNotEmpty?widget.choices.dialogMessage:widget.choices.fileName,
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                      fontSize: height(context) * 0.017,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height(context) * 0.03),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(width: height(context) * 0.016),
                IconButtonWidget(onTap: () => deleteChoice(id: widget.choices.id), iconPath: AppIcons.deleteIcon),
                SizedBox(width: height(context) * 0.016),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void deleteChoice({required String id}) async {
    await db.collection(collectionChoices).doc(id).delete();
  }
}

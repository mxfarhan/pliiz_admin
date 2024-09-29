import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/exports.dart';
import 'package:pliiz_web/model/assign_model.dart';
class AssignedBox extends StatefulWidget {
  final AssignModel model;
  const AssignedBox({Key? key,required this.model}) : super(key: key);
  @override
  State<AssignedBox> createState() => _AssignedBoxState();
}

class _AssignedBoxState extends State<AssignedBox> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: Get.width,
      margin: const EdgeInsets.only(left: 16,right: 16,top: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: AppColors.greyColor,
              borderRadius: BorderRadius.circular(24.0),
            ),
            child: Stack(
              children: [
                Container(
                  padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
                  decoration: BoxDecoration(
                    color: AppColors.greyColor,
                    borderRadius: BorderRadius.circular(24.0),
                  ),
                  child: Center(
                    child: Text(widget.model.qrLocation ,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                        fontSize: height(context) * 0.028,
                      ),),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child:  Text(widget.model.cTitle,
              style: montserratBold.copyWith(
                fontSize: 15.0,
                color: AppColors.blackColor,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: 'Assigned By: ',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor,
                    fontSize: height(context) * 0.015,
                  ),
                ),
                TextSpan(
                  text: widget.model.employeeName,
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w700,
                    color: AppColors.blackColor,
                    fontSize: height(context) * 0.015,
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 16),
            child:  Text(fun(widget.model.stamp),
              style: montserratBold.copyWith(
                fontSize: 15.0,
                color: AppColors.blackColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

String fun(seconds){
  final d = DateTime.fromMillisecondsSinceEpoch(seconds.seconds * 1000);
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  }
  return "just now";
}
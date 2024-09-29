import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/auth_controller.dart';
import 'package:pliiz_web/model/assign_model.dart';
import 'package:pliiz_web/model/waiting_model.dart';
import 'package:pliiz_web/widgets/time_ago_widget.dart';
import '../constants/db_contansts.dart';
import '../constants/exports.dart';


class WaitingListBox extends StatefulWidget {
  final WaitingModel model;
  const WaitingListBox({Key? key,required this.model}) : super(key: key);
  @override
  State<WaitingListBox> createState() => _WaitingListBoxState();
}

class _WaitingListBoxState extends State<WaitingListBox> {
  final db = FirebaseFirestore.instance;
  final auth = Get.put(AuthController());
  final uui = FirebaseAuth.instance.currentUser!.uid;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      width: height(context) * 0.26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
            height: height(context) * 0.15,
            width: height(context) * 0.24,
            alignment: Alignment.center,
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
                    child: Text(widget.model.qrLocation ,
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w800,
                        color: AppColors.blackColor,
                        fontSize: height(context) * 0.038,
                      ),),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.model.qrTitle,
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
              fontSize: height(context) * 0.021,
            ),
          ),
          const SizedBox(height: 10),
         Container(
           margin: const EdgeInsets.all(16),
           child:  Text(widget.model.cTitle,
             style: montserratBold.copyWith(
               fontSize: 15.0,
               color: AppColors.blackColor,
             ),
           ),
         ),
          const SizedBox(height: 10),
          TimeAgoWidget(seconds: widget.model.stamp.seconds),
          const SizedBox(height: 10),
          Bounceable(
            onTap: () => handleConfirm(widget.model),
            child: Container(
              padding: const EdgeInsets.only(left: 16,right: 16,top: 8,bottom: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: AppColors.primaryColor,
                boxShadow: shadowsOne,
              ),
              child: Text('Confirm The Call',
                style: montserratBold.copyWith(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.whiteColor,
                  fontFamily: GoogleFonts.ibmPlexSans().fontFamily,
                ),
              ),
            ),
          ),
          SizedBox(height: height(context) * 0.01),
        ],
      ),
    );
  }
  void handleConfirm(WaitingModel x) async {
    var datetime = DateTime.now();
    final user = FirebaseAuth.instance.currentUser;
    String name = "";
    if(user != null){
      name = user.displayName??"";
    }
    getLoading();
    try{
      AssignModel assign = AssignModel(
        id: "",
        wId: x.wId,
        qrTitle: x.qrTitle,
        qrId: x.qrId,
        qrLocation: x.qrLocation,
        qrType: x.qrType,
        qrHola: "x.qrHola",
        cId: x.cId,
        cTitle: x.cTitle,
        stamp: FieldValue.serverTimestamp(),
        employeeName: "Tanveer Ahmad",
        employeeId: uui,
        employeeImage: name,
        companyId: uui,
        token: x.token,
        createdAt: "${datetime.year}:${datetime.month}:${datetime.day}",
        finalCall: true,
      );
      await db.collection(collectionAssign).add(assign.toMap());
      await db.collection(collectionWaiting).doc(x.wId).delete();
      Get.back();
      messageDialog(message: "Assigned");
    }catch(e){
      print(e);
      Get.back();
    }
  }
  void getLoading(){
    Get.dialog(
      Dialog(
        child: Container(
          width:250,
          height: 250,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
  void messageDialog({required String message}){
    Get.dialog(
        Dialog(
          child: Container(
            height:  Get.height>350?350:Get.width - 100,
            padding: const EdgeInsets.all(16),
            width: Get.width>350?350:Get.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  height: height(context) * 0.16,
                  width: height(context) * 0.16,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.whiteColor,
                  ),
                  child: Center(
                    child: SvgPicture.asset(AppIcons.doneIcon),
                  ),
                ),
                Text("Assigned",style: GoogleFonts.poppins(
                  fontSize: 26,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
                const SizedBox(height: 30),
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
                    child: Text('Back Now',
                      style: montserratBold.copyWith(
                        fontSize: 16.0,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        )
    );
  }
}


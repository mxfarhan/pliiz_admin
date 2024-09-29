import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/app_colors.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/main.dart';
import 'package:pliiz_web/model/qrcode_model.dart';
import 'package:pliiz_web/screens/dialogs/update_qrcode_dialog.dart';
import 'package:uuid/uuid.dart';
//import 'package:short_uuids/short_uuids.dart';

import 'choices.controller.dart';

class HomeController extends GetxController{

  var title = TextEditingController();
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  String updateId = "";
  String selectedIndustry = "";
  String selectedLocation = "";
  String selectedHola = "";
  String qrCodeType = "";

  void selectIndustry(String e) async{
    selectedIndustry = e;
    await box.write("Industry", e);
    update();
  }
  void selectLocation(e){
    selectedLocation = e;
    update();
  }
  void selectHola(e){
    selectedHola = e;
    update();
  }
  void addQrCode() async {
    try{
      if(title.text.isNotEmpty){
        // final translator = ShortUuid.init();
        // String id = translator.generate();
        String id = const Uuid().v4();
        QrCodeModel qr = QrCodeModel(
          userName: auth.currentUser!.displayName??"",
          userId: auth.currentUser!.uid,
          companyId: [],
          title: title.text,
          industry: box.read("Industry")??"",
          location: selectedLocation,
          hola: [],
          qrCodeId: id,
          type: qrCodeType,
          empId: [],
        );
        await db.collection(collectionQrCode).doc(id).set(qr.toJson());
        Get.back();
        title.clear();
        update();
        sToast("Qr Code Created Successfully");
      }
    }catch(_){
      toast("Failed to create Qr Code",bgColor: AppColors.secondaryColor);
    }
  }
  void deleteQrCode({required String id}) async {
    try{
      await db.collection(collectionQrCode).doc(id).delete();
      toast("Successfully Delete");
    }catch(_){
      toast("Failed to delete",bgColor: AppColors.secondaryColor);
    }
  }
  void submitUpdate() async {
    try{
      await db.collection(collectionQrCode).doc(updateId).update({
        "location": selectedLocation,
        "title": title.text,
        "hola": selectedHola,
      }
      );
      toast("Successfully Updated");
    }catch(_){
      toast("Failed to update",bgColor: AppColors.secondaryColor);
    }
  }
  void updateQrCode(QrCodeModel qrCodeModel){
    title.text = qrCodeModel.title;
    selectedHola = qrCodeModel.hola.first;
    selectedLocation = qrCodeModel.location;
    updateId = qrCodeModel.qrCodeId;
    update();
    Get.defaultDialog(
      title: '',
      content: const UpdateQrCodeDialog(),
      /// barrierDismissible: false,
    );
  }
}

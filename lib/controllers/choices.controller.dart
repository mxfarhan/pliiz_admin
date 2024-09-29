import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:oktoast/oktoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:pliiz_web/constants/app_colors.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/main.dart';
import 'package:pliiz_web/model/choices_model.dart';
import 'package:short_uuids/short_uuids.dart';

class ChoicesController extends GetxController{
  final db = FirebaseFirestore.instance;
  final storage = FirebaseStorage.instance;
  final title = TextEditingController();
  final dialogMessage = TextEditingController();
  final messageAfterConfirm = TextEditingController();
  final url = TextEditingController();
  final auth = FirebaseAuth.instance;
  Uint8List? file;
  String? name;
  bool isFile = false;

  Future putFile() async {
    String path = "menus/$name";
    await storage.ref(path).putData(file!);
  }
  void handleCreateChoice() async {
    final choice = db.collection(collectionChoices);
    try{
      final translator = ShortUuid.init();
      String id = translator.generate();
      ChoicesModel choices = ChoicesModel(
        id: id,
        title: title.text,
        isFile: isFile,
        dialogMessage: file!=null?"": dialogMessage.text,
        companyName: box.read("companyName")??"",
        userId: auth.currentUser!.uid,
        userName: auth.currentUser!.displayName??"",
        fileName: url.text.trim().isEmpty? (name??""):  url.text,
        isUrl: url.text.trim().isNotEmpty,
        messageAfterConform: messageAfterConfirm.text.isNotEmpty?messageAfterConfirm.text:"",
      );
      await choice.doc(id).set(choices.toMap());
      if(file != null){
        await putFile();
      }
      title.clear();
      dialogMessage.clear();
      name = null;
      file = null;
      Get.back();
      update();
    }catch(e){
      toast("Some went wrong ${e}",bgColor: AppColors.secondaryColor);
    }
  }
  void handleUpdateChoice() async {
    final choice = db.collection(collectionChoices);

  }
  void handleDeleteChoice() async {
    final choice = db.collection(collectionChoices);
  }
  void pickFile() async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if(result != null){
        name = result.files.first.name;
        file = result.files.first.bytes;
        update();
      }
    }catch(e){
      toast("error failed: $e");
    }
  }
}

void toast(message,{bgColor =  Colors.red}){
  PanaraInfoDialog.show(
    Get.context!,
    title: "",
    message: message,
    buttonText: "Okay",
    onTapDismiss: () => Get.back(),
    panaraDialogType: PanaraDialogType.normal,
    barrierDismissible: false, // optional parameter (default is true)
  );
}
void sToast(message,{bgColor =  Colors.red}){
  PanaraInfoDialog.show(
    Get.context!,
    title: "",
    message: message,
    buttonText: "Okay",
    onTapDismiss: () => Get.back(),
    panaraDialogType: PanaraDialogType.success,
    barrierDismissible: false, // optional parameter (default is true)
  );
}
import 'dart:typed_data';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/model/logo_model.dart';
import 'choices.controller.dart';

class LogoController extends GetxController{
  final uui = FirebaseAuth.instance.currentUser!.uid;
  var text = TextEditingController();
  final storage = FirebaseStorage.instance;
  final db = FirebaseFirestore.instance;
  String urlSet = "";
  Uint8List? file;

  void pickFile() async {
    try{
      FilePickerResult? result = await FilePicker.platform.pickFiles();
      if(result != null){
        file = result.files.first.bytes;
        getLoading();
        await storage.ref("logos/$uui.png").putData(file!);
        String url = await storage.ref("logos/$uui.png").getDownloadURL();
        LogoModel logoModel = LogoModel(
            url: url,
            createdAt: FieldValue.serverTimestamp(),
            updatedAt: FieldValue.serverTimestamp(),
            companyId: uui,
            text: text.text.isNotEmpty?text.text:""
        );
        try{
          await db.collection(collectionLogos).doc(uui).update(logoModel.toMap());
        }catch(_){
          await db.collection(collectionLogos).doc(uui).set(logoModel.toMap());
        }
        Get.back();
        update();
      }
    }catch(e){
      toast("error failed: $e");
    }
  }
  void addText() async {
    try{
      LogoModel logoModel = LogoModel(
        url: urlSet,
        createdAt: FieldValue.serverTimestamp(),
        updatedAt: FieldValue.serverTimestamp(),
        companyId: uui,
        text: text.text,
      );
      try{
        await db.collection(collectionLogos).doc(uui).update(logoModel.toMap());
      }catch(_){
        await db.collection(collectionLogos).doc(uui).set(logoModel.toMap());
      }
      Get.back();
      update();

    }catch(_){}
  }
  void updateSetTex(String t,String url){
    text.text = t;
    urlSet = url;
    update();
  }
  void getLoading(){
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        child: Container(
          width:250,
          height: 250,
          padding: const EdgeInsets.all(40),
          child: const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
            ],
          ),
        ),
      ),
    );
  }
}
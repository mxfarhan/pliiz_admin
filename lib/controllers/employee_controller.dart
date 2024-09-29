import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/model/employees_model.dart';
import 'package:pliiz_web/model/user_model.dart';
import '../constants/exports.dart';
import '../screens/dialogs/new_employee_dialog.dart';
import 'choices.controller.dart';

class EmployeeController extends GetxController{
  final auth = FirebaseAuth.instance;
  final db = FirebaseFirestore.instance;
  void createEmployee({required String title,required String email, required List<FakeModel> location}) async {
    List<String> lcs = [];
    for(var lc in location){
      lcs.add(lc.name);
    }
    Get.back();
    getLoading();
    final document = await db.collection(usersCollection).where("email", isEqualTo: email).limit(1).get();
    if(document.docs.isNotEmpty){
      Map<String, dynamic> json = document.docs[0].data();
      final String id = document.docs[0].id;
      UserModel user = UserModel.fromSnapshot(json);
      EmployeesModel employees = EmployeesModel(
        id: id,
        companyName: auth.currentUser!.displayName??"",
        companyId: auth.currentUser!.uid,
        locations: lcs,
        name: user.contactName,
        photoUrl: ""
      );
      for(var lc in location){
        await db.collection(collectionQrCode).doc(lc.id).update({
          "hola": FieldValue.arrayUnion([user.contactName]),
          "empId": FieldValue.arrayUnion([id]),
        });
       /* await db.collection(collectionQrCode).doc(lc.id).update({
          "hola": user.contactName,
          "empId": id,
        });
        */
      }
      await db.collection(collectionEmployees).doc(id).set(employees.toMap());
      Get.back();
      sToast("Employee Created Successfully");
    } else {
      Get.back();
      toast("No Data with this email");
    }
  }
  void updateLocation({required List<String> location,required List<String> oldLocation}) async {

  }
  void deleteEmployee({required String id,required String name}) async {
    getLoading();
    try{
      await db.collection(collectionEmployees).doc(id).delete();
      final querySnapshot = await db.collection(collectionQrCode).where("empId",isEqualTo: id).get();
      final documents = querySnapshot.docs;
      for (final document in documents) {
        await document.reference.update({
          "hola": FieldValue.arrayRemove([name]),
          "empId": FieldValue.arrayRemove([id]),
        }); // update the age field to 25
      }
      Get.back();
    }catch(_){
      Get.back();
    }
  }
  void updateEmployee(){

  }
  void getLoading(){
    Get.dialog(
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
  void messageDialog({required String message}){
    Get.dialog(
      Dialog(
        child: Container(
          width:250,
          height: 250,
          padding: const EdgeInsets.all(40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(message),
              const SizedBox(height: 50),
              Bounceable(
                onTap: () => Get.back(),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: AppColors.whiteColor,
                    boxShadow: shadowsOne,
                  ),
                  child: Text('Cancel',
                    style: montserratBold.copyWith(
                      fontSize: 20,
                      color: AppColors.secondaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/employee_controller.dart';
import 'package:pliiz_web/model/employees_model.dart';
import 'package:pliiz_web/model/qrcode_model.dart';

import '../constants/db_contansts.dart';
import '../constants/exports.dart';
import '../screens/dialogs/new_employee_dialog.dart';
import 'icon_button.dart';

class EmployeeBoxWidget extends StatefulWidget {
  final String? nameText;
  final String? tableText;
  final EmployeesModel employee;
  const EmployeeBoxWidget({
    Key? key,
    required this.nameText,
    required this.tableText,
    required this.employee,
  }) : super(key: key);

  @override
  State<EmployeeBoxWidget> createState() => _EmployeeBoxWidgetState();
}

class _EmployeeBoxWidgetState extends State<EmployeeBoxWidget> {
  final db = FirebaseFirestore.instance;
  final emp = Get.put(EmployeeController());
  final uui = FirebaseAuth.instance.currentUser!.uid;
  Map<String,String> selected = {};
  List<FakeModel> locations = [];
  List<FakeModel> results = [];
  List<String> unSelect = [];
  List<String> allSelected = [];
  Map<String,String> lcs = {};
  bool changed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(8.0, 8.0, 16, 8.0),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// image
          Container(
            height: 45,
            width: 45,
            decoration: BoxDecoration(
              //borderRadius: BorderRadius.circular(5.0),
              shape: BoxShape.circle,
              border: Border.all(color: Colors.blue,width: 2),
              /*image: const DecorationImage(
                image: AssetImage(AppImages.userImage),
                fit: BoxFit.fill,
              ),*/
            ),
            child: widget.employee.photoUrl.isNotEmpty?Image.network(widget.employee.photoUrl,height: 41,
              width: 41,
              fit: BoxFit.fill,
            ):const Icon(Icons.person_2_outlined,size: 35,),
          ),
          const SizedBox(width: 10.0),

          /// name
          Expanded(
            child: Text(
              '${widget.nameText}',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                color: AppColors.blackColor,
                fontSize: height(context) * 0.02,
              ),
            ),
          ),

          /// assign
          const Expanded(
            child: SizedBox(),
          ),

          /// location
          Expanded(
            child: Text(
              'Location: Table ${widget.tableText}',
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor,
                fontSize: height(context) * 0.02,
              ),
            ),
          ),

          /// edit delete icon
          IconButtonWidget(onTap: () => emp.deleteEmployee(id: widget.employee.id,name: widget.employee.name), iconPath: AppIcons.deleteIcon),
          SizedBox(width: height(context) * 0.016),
          IconButtonWidget(onTap: handleEdit, iconPath: AppIcons.editIcon),
        ],
      ),
    );
  }
  void handleEdit(){
    Widget locationBuilder(){
      return StreamBuilder<QuerySnapshot>(
          stream: db.collection(collectionQrCode).where("userId",isEqualTo: uui).snapshots(),
          //stream: db.collection(collectionQrCode).where("hola", isEqualTo: "").where("userId",isEqualTo: uui).snapshots(),
          builder: (context,snapshot) {
            if(snapshot.hasError){
              return const Center(child: Text("Some is Wrong"));
            }
            else if(snapshot.hasData){
              locations = [];
              for(var doc in snapshot.data!.docs){
                Map<String,dynamic> json = doc.data() as Map<String,dynamic>;
                QrCodeModel qrCodeModel = QrCodeModel.fromJson(json: json, id: doc.id);
                FakeModel fake = FakeModel(id: doc.id,name: qrCodeModel.location,title: qrCodeModel.title);
                locations.add(fake);
                lcs[doc.id] = qrCodeModel.location;
              }
              locations.sort((a, b) => a.name.compareTo(b.name));
              locations = List.from(locations);
              return SizedBox(
                width: Get.width * 0.66,
                child: Column(
                  children: [
                    Text(
                      "Assigned Location",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                        fontSize: height(context) * 0.021,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.all(10),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.greyColor,
                      ),
                      child: SingleChildScrollView(
                        child: MultiSelectContainer(
                            suffix: MultiSelectSuffix(
                                selectedSuffix: const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                                disabledSuffix: const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.do_disturb_alt_sharp,
                                    size: 14,
                                  ),
                                )),
                            items: widget.employee.locations.map((e) => MultiSelectCard(
                              value: e,
                              label: e,
                              selected: true,
                            )).toList(),
                            onChange: (allSelectedItems, selectedItem) {
                              unSelect = [];
                              allSelected = [];
                              changed = true;
                              for(var s in widget.employee.locations){
                                if(!allSelectedItems.contains(s)){
                                  unSelect.add(s);
                                } else {
                                  allSelected.add(s);
                                }
                              }
                              setState(() {});
                            }),
                      ),
                    ),
                    Text(
                      "Not Assigned Location",
                      style: GoogleFonts.openSans(
                        fontWeight: FontWeight.w400,
                        color: AppColors.blackColor,
                        fontSize: height(context) * 0.021,
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(10),
                      padding: const EdgeInsets.all(10),
                      height: 120,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        color: AppColors.greyColor,
                      ),
                      child: SingleChildScrollView(
                        child: MultiSelectContainer(
                            suffix: MultiSelectSuffix(
                                selectedSuffix: const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.check,
                                    color: Colors.white,
                                    size: 14,
                                  ),
                                ),
                                disabledSuffix: const Padding(
                                  padding: EdgeInsets.only(left: 5),
                                  child: Icon(
                                    Icons.do_disturb_alt_sharp,
                                    size: 14,
                                  ),
                                )),
                            items: locations.map((e) => MultiSelectCard(
                              value: e.id,
                              label: "${e.title}: ${e.name}",
                            )).toList(),
                            onChange: (allSelectedItems, selectedItem) {
                              results = [];
                              for(var key in allSelectedItems){
                                FakeModel fake = FakeModel(id: key.toString(), name: lcs[key]??"",title: "");
                                results.add(fake);
                                setState(() {});
                              }
                            }),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
      );
    }
    Get.dialog(
      barrierDismissible: false,
        Dialog(
          child: Container(
            width: Get.width * 0.66,
            height: Get.height * 0.66,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: height(context) * 0.03),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  'Update ${widget.employee.name}',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor,
                    fontSize: height(context) * 0.021,
                  ),
                ),
                locationBuilder(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Bounceable(
                      onTap: () async {
                        Get.back();
                      },
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
                      onTap: () async {
                        Get.back();
                        getLoading();
                        if(changed){
                          for(var un in unSelect){
                            final query = db.collection(collectionQrCode).where('empId', isEqualTo:  widget.employee.id).where('location', isEqualTo: un);
                            query.get().then((snapshot) {
                              if (snapshot.docs.length == 1) {
                                final docId = snapshot.docs[0].id;
                                final docRef =  db.collection(collectionQrCode).doc(docId);
                                // Update the document fields here
                                docRef.update({
                                  'hola': FieldValue.arrayRemove([widget.employee.name]),
                                  'empId': FieldValue.arrayRemove([widget.employee.id]),
                                });
                              }
                            });
                          }
                        }
                        for(var lc in results){
                          await db.collection(collectionQrCode).doc(lc.id).update({
                            "hola": FieldValue.arrayUnion([widget.employee.name]),
                            "empId": FieldValue.arrayUnion([widget.employee.id]),
                          });
                        }

                        List all = changed? allSelected :widget.employee.locations;
                        for(var lc in results){
                          all.add(lc.name);
                        }
                        await db.collection(collectionEmployees).doc(widget.employee.id).update({
                          "locations": all,
                        });
                        Get.back();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: height(context) * 0.03, vertical: 8.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40.0),
                          color: AppColors.whiteColor,
                          boxShadow: shadowsOne,
                        ),
                        child: Text(
                          'Update',
                          style: montserratBold.copyWith(
                            fontSize: height(context) * 0.018,
                            color: AppColors.secondaryColor,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
    );
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

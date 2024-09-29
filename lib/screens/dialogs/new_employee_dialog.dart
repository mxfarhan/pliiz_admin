import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/controllers/employee_controller.dart';
import 'package:pliiz_web/model/qrcode_model.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import '../../constants/exports.dart';
import '../../widgets/custom_text_field.dart';

class NewEmployeeDialog extends StatefulWidget {
  const NewEmployeeDialog({Key? key}) : super(key: key);
  @override
  State<NewEmployeeDialog> createState() => _NewEmployeeDialogState();
}

class _NewEmployeeDialogState extends State<NewEmployeeDialog> {
  final employee = Get.put(EmployeeController());
  final db = FirebaseFirestore.instance;

  Map<String,String> selected = {};
  List<FakeModel> locations = [];
  List<FakeModel> results = [];

  Map<String,String> lcs = {};

  final title = TextEditingController();
  final email = TextEditingController();
  final uui = FirebaseAuth.instance.currentUser!.uid;

  @override
  Widget build(BuildContext context) {
    Widget locationBuilder(){
      return StreamBuilder<QuerySnapshot>(
         // stream: db.collection(collectionQrCode).where("hola", isEqualTo: "").where("userId",isEqualTo: uui).snapshots(),
          stream: db.collection(collectionQrCode).where("userId",isEqualTo: uui).snapshots(),
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
              locations.sort((a, b) => "${a.title}: ${b.name}".compareTo("${a.title}: ${b.name}"));
              locations = List.from(locations);
              return SizedBox(
                width: Get.width * 0.66,
                child: Container(
                  padding: const EdgeInsets.all(10),
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
                  ), // This trailing comma makes auto-formatting nicer for build methods.
                ),
              );
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }
      );
    }

    return  Container(
      padding:const EdgeInsets.all(16),
      width: Get.width * 0.66,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// title text
          Text(
            'Create New',
            style: GoogleFonts.openSans(
              fontWeight: FontWeight.w400,
              color: AppColors.blackColor,
              fontSize: height(context) * 0.025,
            ),
          ),
          SizedBox(height: height(context) * 0.02),
          /// field
          SizedBox(

            child: CustomTextField(
              margin: 0.0,
              controller: title,
              fieldColor: AppColors.whiteColor,
              fieldShadow: shadowsTwo,
              obscureText: false,
              suffixIcon: null,
              labelText: 'Title',
              hintText: 'Enter Title',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          SizedBox(height: height(context) * 0.024),
          SizedBox(
            child: CustomTextField(
              margin: 0.0,
              controller: email,
              fieldColor: AppColors.whiteColor,
              fieldShadow: shadowsTwo,
              obscureText: false,
              suffixIcon: null,
              labelText: 'Employee Email',
              hintText: 'Enter Email',
              labelTextColor: AppColors.blackColor.withOpacity(0.5),
              hintTextColor: AppColors.blackColor.withOpacity(0.5),
            ),
          ),
          /// field
          SizedBox(height: height(context) * 0.024),
          SizedBox(height: height(context) * 0.02),
          SizedBox(
            height: 140,
            child: locationBuilder(),
          ),
          /// generate btn
          SizedBox(height: height(context) * 0.06),
          Center(
            child: Bounceable(
              onTap: () => employee.createEmployee(title: title.text, email: email.text, location: results),
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
          ),
          SizedBox(height: height(context) * 0.02),
        ],
      ),
    );
  }
}

class FakeModel{
  final String id;
  final String name;
  final String title;
  FakeModel({required this.id,required this.name,required this.title});
  @override
  String toString() {
    return "$title:$name";
  }
}
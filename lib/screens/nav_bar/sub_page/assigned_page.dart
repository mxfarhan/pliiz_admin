import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/model/assign_model.dart';
import 'package:pliiz_web/widgets/assigned_box.dart';
import 'package:pliiz_web/widgets/web_app_bar_widget.dart';
import '../../../constants/exports.dart';

class AssignedPage extends StatefulWidget {
  const AssignedPage({Key? key}) : super(key: key);
  @override
  State<AssignedPage> createState() => _AssignedPageState();
}

class _AssignedPageState extends State<AssignedPage> {
  final db = FirebaseFirestore.instance;
  var datetime = DateTime.now();
  final firstDate = DateTime.utc(1999);
  final lastDate = DateTime.now();
  String uui = FirebaseAuth.instance.currentUser!.uid;
  List<AssignModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          const WebAppBar(titleText: 'Assign List'),
          const SizedBox(height: 16),
          StreamBuilder<QuerySnapshot>(
              stream: db.collection(collectionAssign).where("companyId", isEqualTo: uui).where("createdAt",isEqualTo: "${datetime.year}:${datetime.month}:${datetime.day}").orderBy("stamp", descending: true).snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  list = [];
                  for(var doc in snapshot.data!.docs){
                    Map<String,dynamic> json =  doc.data() as Map<String,dynamic>;
                    AssignModel wait = AssignModel.fromMap(json);
                    list.add(wait);
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: height(context) * 0.03),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              'You have: ',
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w400,
                                color: AppColors.blackColor,
                                fontSize: height(context) * 0.025,
                              ),
                            ),
                            Text(
                              '${list.length} Assigned',
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackColor,
                                fontSize: height(context) * 0.025,
                              ),
                            ),
                            Container(
                              width: 1.5,
                              height: height(context) * 0.045,
                              margin:
                              EdgeInsets.symmetric(horizontal: height(context) * 0.024),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    AppColors.blackColor.withOpacity(0.0),
                                    AppColors.blackColor.withOpacity(0.3),
                                    AppColors.blackColor.withOpacity(0.0),
                                  ],
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                ),
                              ),
                            ),
                            TextButton(onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                  context: context,
                                  initialDate: datetime,
                                  firstDate: DateTime(2015, 8),
                                  lastDate: lastDate);
                              if (picked != null && picked != datetime) {
                                setState(() {
                                  datetime = picked;
                                });
                              }
                            }, child: Text("${datetime.day}/${datetime.month}/${datetime.year}", style: GoogleFonts.openSans(
                              fontWeight: FontWeight.w700,
                              color: AppColors.blackColor,
                              fontSize: height(context) * 0.025,
                            ),))
                          ],
                        ),
                      ),

                      /// items
                      SizedBox(height: height(context) * 0.02),
                      SizedBox(
                        height: Get.height-136,
                        child: SingleChildScrollView(
                          child: Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: list.map((e) => AssignedBox(model: e)).toList(),
                          ),
                        ),
                      ),
                    ],
                  );
                } else if(snapshot.hasError){
                  print(snapshot.error);
                  return const Text("Error");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
          ),
        ],
      ),
    );
  }
}

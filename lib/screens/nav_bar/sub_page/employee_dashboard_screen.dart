import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/controllers/choices.controller.dart';
import 'package:pliiz_web/model/employees_model.dart';
import 'package:pliiz_web/model/user_model.dart';
import 'package:pliiz_web/screens/dialogs/new_employee_dialog.dart';
import 'package:pliiz_web/widgets/employee_box_widget.dart';

import '../../../constants/exports.dart';
import '../../../widgets/web_app_bar_widget.dart';

class EmployeeDashboardScreen extends StatefulWidget {
  const EmployeeDashboardScreen({Key? key}) : super(key: key);
  @override
  State<EmployeeDashboardScreen> createState() =>
      _EmployeeDashboardScreenState();
}

class _EmployeeDashboardScreenState extends State<EmployeeDashboardScreen> {
  final db = FirebaseFirestore.instance;
  final uui = FirebaseAuth.instance.currentUser!.uid;
  bool canCreateEmployee = false;
  List<EmployeesModel> employees = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// top bar
          const WebAppBar(titleText: 'Employees'),

          SizedBox(height: height(context) * 0.03),
          StreamBuilder<QuerySnapshot>(
              stream: db
                  .collection(collectionEmployees)
                  .where("companyId", isEqualTo: uui)
                  .snapshots(),
              builder: (context, snapshot) {
                employees = [];
                if (snapshot.hasError) {
                  return const Center(child: Text("Some went wrong"));
                } else if (snapshot.hasData) {
                  for (var doc in snapshot.data!.docs) {
                    Map<String, dynamic> json =
                        doc.data() as Map<String, dynamic>;
                    EmployeesModel employee =
                        EmployeesModel.fromMap(json, doc.id);
                    employees.add(employee);
                  }
                  return Column(
                    children: [
                      Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: height(context) * 0.03),
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
                              '${employees.length} Employees',
                              style: GoogleFonts.openSans(
                                fontWeight: FontWeight.w700,
                                color: AppColors.blackColor,
                                fontSize: height(context) * 0.025,
                              ),
                            ),
                            Container(
                              width: 1.5,
                              height: height(context) * 0.045,
                              margin: EdgeInsets.symmetric(
                                  horizontal: height(context) * 0.024),
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

                            /// btn
                            Bounceable(
                              onTap: () async {
                                print('this is create new employee');
                                await FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(uui)
                                    .get()
                                    .then((value) {
                                  Map<String, dynamic> json =
                                      value.data() as Map<String, dynamic>;
                                  // print('this is value $json');
                                  UserModel user = UserModel.fromSnapshot(json);
                                  // canCreateEmployee
                                  employees.length >=
                                          user.noOfEmployees!.toInt()
                                      ? canCreateEmployee = false
                                      : canCreateEmployee = true;
                                  print(
                                      'this is employee in database ${employees.length}  ${user.noOfEmployees}');
                                });
                                canCreateEmployee
                                    ? Get.defaultDialog(
                                        title: '',
                                        content: const NewEmployeeDialog(),
                                      )
                                    : toast('You have reached your limit');
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: height(context) * 0.03,
                                    vertical: 12.0),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40.0),
                                  color: AppColors.whiteColor,
                                  boxShadow: shadowsOne,
                                ),
                                child: Text(
                                  'Create New',
                                  style: montserratBold.copyWith(
                                    fontSize: 16.0,
                                    color: AppColors.secondaryColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      /// items
                      SizedBox(height: height(context) * 0.02),
                      SizedBox(
                        height: Get.height - 250,
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: employees.length,
                          padding: EdgeInsets.symmetric(
                              horizontal: height(context) * 0.03),
                          itemBuilder: (context, index) {
                            employees[index].locations.sort();
                            return EmployeeBoxWidget(
                              nameText: employees[index].name,
                              tableText: List.from(employees[index].locations)
                                  .toString(),
                              employee: employees[index],
                            );
                          },
                        ),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ],
      ),
    );
  }
}

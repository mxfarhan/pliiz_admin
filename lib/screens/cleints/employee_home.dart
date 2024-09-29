import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/choices.controller.dart';
import 'package:pliiz_web/helpers/routes.dart';
import 'package:pliiz_web/main.dart';
import 'package:pliiz_web/model/assign_model.dart';
import 'package:pliiz_web/model/employees_model.dart';
import 'package:pliiz_web/widgets/time_ago_widget.dart';

import '../../constants/db_contansts.dart';
import '../../constants/exports.dart';
import '../../helpers/functions.dart';
import '../../model/waiting_model.dart';

class EmployeeHomePage extends StatefulWidget {
  const EmployeeHomePage({Key? key}) : super(key: key);
  @override
  State<EmployeeHomePage> createState() => _EmployeeHomePageState();
}

class _EmployeeHomePageState extends State<EmployeeHomePage> {
  final uui = FirebaseAuth.instance.currentUser!.uid;
  final auth = FirebaseAuth.instance.currentUser;
  final db = FirebaseFirestore.instance;
  List<WaitingModel> waiting = [];
  List<AssignModel> assigns = [];
  EmployeesModel? employees;
  @override
  void initState() {
    super.initState();
    Map<String, dynamic> json =  jsonDecode(box.read("loyee")??"");
    if(json.isNotEmpty){
      setState(() {
        employees = EmployeesModel.fromMap(json, uui);
      });
    } else {
      Get.toNamed(keys.loginPage);
    }
  }
  @override
  Widget build(BuildContext context) {
    Widget userInfo(){
      return SizedBox(
        height: 60,
        child: Row(
          children: [
            const CircleAvatar(
              radius: 30,
              backgroundImage: AssetImage(AppImages.userImage),
            ),
            const SizedBox(width: 16),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(auth!.displayName??"",style: montserratBold.copyWith(
                  fontSize: 16.0,
                  color: AppColors.blackColor,
                ),),
                Text("Role: Waiter",style: montserratBold.copyWith(
                    fontSize: 14.0,
                    color: Colors.grey
                ),),
              ],
            )
          ],
        ),
      );
    }
    Widget boxBuilder(WaitingModel box){
      return Container(
        height: 150,
        width: Get.width,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: Get.width/2 - 28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(box.cTitle,style: montserratBold.copyWith(
                          fontSize: 16.0,
                          color: AppColors.blackColor,
                        ),),
                        TimeAgoWidget(seconds: box.stamp.seconds),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width/2 - 28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(box.qrLocation,style: montserratBold.copyWith(
                          fontSize: 16.0,
                          color: AppColors.blackColor,
                        ),),
                        Bounceable(
                          onTap: () => handleConfirm(box),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.greyColor,
                              boxShadow: shadowsOne,
                            ),
                            child: Text('Confirm',
                              style: montserratBold.copyWith(
                                fontSize: 16.0,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                        Bounceable(
                          onTap: () => handleTransfer(box),
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.greyColor,
                              boxShadow: shadowsOne,
                            ),
                            child: Text('Transfer',
                              style: montserratBold.copyWith(
                                fontSize: 16.0,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    Widget assignBuilder(AssignModel box){
      return Container(
        height: 150,
        width: Get.width,
        margin: const EdgeInsets.only(top: 10),
        decoration: BoxDecoration(
          color: AppColors.primaryColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Container(
          margin: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.whiteColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Stack(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: Get.width/2 - 28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(box.cTitle,style: montserratBold.copyWith(
                          fontSize: 16.0,
                          color: AppColors.blackColor,
                        ),),
                        TimeAgoWidget(seconds: box.stamp.seconds),
                      ],
                    ),
                  ),
                  SizedBox(
                    width: Get.width/2 - 28,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(box.qrLocation,style: montserratBold.copyWith(
                          fontSize: 16.0,
                          color: AppColors.blackColor,
                        ),),
                        Bounceable(
                          onTap: () async {
                            try{
                              await db.collection(collectionAssign).doc(box.id).update({
                                "finalCall": false,
                              });
                            }catch(e){}
                            try{
                              await sendPushMessageToToken(title: "Thanks for Waiting", body: "Your order is ready", topic: box.token);
                            }catch(e){}
                            sToast("Notification Send");
                          },
                          child: Container(
                            padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16.0),
                              color: AppColors.greyColor,
                              boxShadow: shadowsOne,
                            ),
                            child: Text('Confirm',
                              style: montserratBold.copyWith(
                                fontSize: 16.0,
                                color: AppColors.primaryColor,
                              ),
                            ),
                          ),
                        ),

                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      );
    }
    Widget messagesBuilder(){
      return StreamBuilder<QuerySnapshot>(
          stream: db.collection(collectionWaiting).where("empId", arrayContains: uui).orderBy("stamp", descending: true).snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            } else{
              waiting = [];
              for(var doc in snapshot.data!.docs){
                Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
                WaitingModel w = WaitingModel.fromMap(map: data, id: doc.id);
                waiting.add(w);
              }
              return ListView(
                children: [
                  SizedBox(height: height(context) * 0.03),
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
                              '${waiting.length} in waiting list',
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
                            ),])),
                  Wrap(
                    children: waiting.map((e) => boxBuilder(e)).toList(),
                  ),
                ],
              );
            }
          }
      );
    }
    Widget finalNotification(){
      return StreamBuilder<QuerySnapshot>(
          stream: db.collection(collectionAssign).where("employeeId", isEqualTo: uui).where("finalCall",isEqualTo: true).orderBy("stamp", descending: true).snapshots(),
          builder: (context,snapshot){
            if(!snapshot.hasData){
              return const Center(child: CircularProgressIndicator());
            } else{
              assigns = [];
              for(var doc in snapshot.data!.docs){
                Map<String,dynamic> data = doc.data() as Map<String,dynamic>;
                AssignModel w = AssignModel.fromMap(data,id: doc.id);
                assigns.add(w);
              }
              return ListView(
                children: [
                  SizedBox(height: height(context) * 0.03),
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
                              '${assigns.length} in waiting list',
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
                            ),])),
                  Wrap(
                    children: assigns.map((e) => assignBuilder(e)).toList(),
                  ),
                ],
              );
            }
          }
      );
    }
    return DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.white,
            title: userInfo(),
            bottom: const TabBar(
              tabs: [
                Text("New",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
                Text("Waiting",style: TextStyle(color: Colors.black,fontWeight: FontWeight.w600),),
              ],
            ),
          ),
          drawer: Drawer(
            child: SafeArea(
              child: ListView(
                children: [
                  const SizedBox(height: 30,),
                  ListTile(
                    onTap: () {},
                    leading: const Icon(Icons.logout),
                    title: const Text("Logout",style: TextStyle(
                      fontSize: 22,
                    ),),
                  )
                ],
              ),
            ),
          ),
          body: TabBarView(
            children: [
              Container(
                margin: const EdgeInsets.only(left: 16,right: 16),
                child: messagesBuilder(),
              ),
              Container(
                margin: const EdgeInsets.only(left: 16,right: 16),
                child: finalNotification(),
              ),
            ],
          ),
        )
    );
  }
  void handleConfirm(WaitingModel x) async {
    var datetime = DateTime.now();
    getLoading();
    try{
      AssignModel assign = AssignModel(
        id: "",
        wId: x.wId,
        qrTitle: x.qrTitle,
        qrId: x.qrId,
        qrLocation: x.qrLocation,
        qrType: x.qrType,
        qrHola: "",
        cId: x.cId,
        cTitle: x.cTitle,
        stamp: FieldValue.serverTimestamp(),
        employeeName: employees!.name,
        employeeId: employees!.id,
        employeeImage: "",
        companyId: employees!.companyId,
        createdAt: "${datetime.year}:${datetime.month}:${datetime.day}",
        token: x.token,
        finalCall: true,
      );
      await db.collection(collectionAssign).add(assign.toMap());
      await db.collection(collectionWaiting).doc(x.wId).delete();
      if(x.token.isNotEmpty){
        await sendPushMessageToToken(title: "thank you",body: "${auth!.displayName??""} is on the way",topic: x.token);
      }
      Get.back();
      messageDialog(message: "Assigned");
    }catch(e){
      Get.back();
    }
  }
  void finalTransfer(WaitingModel model,EmployeesModel employee) async {
    Get.back();
    getLoading();
    await db.collection(collectionWaiting).doc(model.wId).update({
      "empId": employee.id,
    });
    try{
      await sendPushMessage(title: "Transfer Call",body: model.cTitle,topic: employee.id);
    }catch(e){
    }
    Get.back();
  }
  void handleTransfer(WaitingModel box){
    List<EmployeesModel> users = [];
    Get.dialog(
        Dialog(
            child: Container(
              height: Get.height * 0.8,
              padding: const EdgeInsets.all(16),
              child: employees != null? Column(
                children: [
                  Expanded(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: db.collection(collectionEmployees).where("companyId",isEqualTo: employees!.companyId).where("id",isNotEqualTo: uui).snapshots(),
                        builder: (context,snapshot){
                          users = [];
                          if(snapshot.data != null){
                            for(var doc in snapshot.data!.docs){
                              Map<String, dynamic> data = doc.data() as Map<String,dynamic>;
                              EmployeesModel model = EmployeesModel.fromMap(data,doc.id);
                              users.add(model);
                            }
                          }
                          if(snapshot.hasData){
                            return ListView(
                              children: users.map((e) => Container(
                                height: 150,
                                width: Get.width,
                                margin: const EdgeInsets.only(top: 10),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Container(
                                  margin: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: AppColors.whiteColor,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(e.name, style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                        fontSize: height(context) * 0.025,
                                      ),),
                                      Text(e.locations.toString(), style: GoogleFonts.openSans(
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.blackColor,
                                        fontSize: height(context) * 0.025,
                                      )),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Bounceable(
                                            onTap: () => finalTransfer(box,e),
                                            child: Container(
                                              padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(16.0),
                                                color: AppColors.greyColor,
                                                boxShadow: shadowsOne,
                                              ),
                                              child: Text('Transfer',
                                                style: montserratBold.copyWith(
                                                  fontSize: 16.0,
                                                  color: AppColors.primaryColor,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              )).toList(),
                            );
                          } else if(snapshot.connectionState == ConnectionState.waiting){
                            return const Center(child: CircularProgressIndicator());
                          } else {
                            return const Center(child: Text("Some is wrong"));
                          }
                        },
                      )
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Bounceable(
                        onTap: () => Get.back(),
                        child: Container(
                          padding: const EdgeInsets.fromLTRB(24, 10, 24, 10),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16.0),
                            color: AppColors.greyColor,
                            boxShadow: shadowsOne,
                          ),
                          child: Text('Cancel',
                            style: montserratBold.copyWith(
                              fontSize: 16.0,
                              color: AppColors.primaryColor,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ):
              const Center(child: CircularProgressIndicator(),),
            )
        )
    );
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

import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/model/choices_model.dart';
import 'package:pliiz_web/widgets/choice_box.dart';
import 'package:pliiz_web/widgets/drage_widget.dart';
import 'package:pliiz_web/widgets/icon_button.dart';

import '../../../constants/exports.dart';
import '../../../widgets/web_app_bar_widget.dart';
import '../../dialogs/create_choice_dialog.dart';


class MenuCreatePage extends StatefulWidget {
  const MenuCreatePage({Key? key}) : super(key: key);
  @override
  State<MenuCreatePage> createState() => _MenuCreatePageState();
}

class _MenuCreatePageState extends State<MenuCreatePage> {
  final db = FirebaseFirestore.instance;
  final uui = FirebaseAuth.instance.currentUser!.uid;
  List<ChoicesModel> qrCodes = [];
  ChoicesModel? selected;
  List<Widget> _widgets = [];
  @override
  void initState() {

    super.initState();
  }
  void _reorderWidgets(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex -= 1;
    setState(() {
      final widget = _widgets.removeAt(oldIndex);
      _widgets.insert(newIndex, widget);
    });
    log("old index $oldIndex new index $newIndex");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,

      /// body
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const WebAppBar(titleText: 'Create Choice'),
          SizedBox(height: height(context) * 0.03),
          /// items
          StreamBuilder<QuerySnapshot>(
              stream: db.collection(collectionChoices).where("userId",isEqualTo: uui).snapshots(),
              builder: (context,snapshot){
                if(snapshot.connectionState == ConnectionState.waiting){
                  return const Center(child: CircularProgressIndicator());
                } else if(snapshot.hasData){
                  qrCodes = [];
                  _widgets = [];
                  for(var doc in snapshot.data!.docs){
                    Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
                    ChoicesModel qr = ChoicesModel.fromMap(map: json, id: doc.id);
                    qrCodes.add(qr);
                    _widgets.add(ChoiceBox(
                      choices: qr,
                      onTap: () {
                        setState(() {
                          selected = qr;
                        });
                      },
                    ));
                  }
                  return ListView(
                    shrinkWrap: true,
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
                              '${qrCodes.length} Options',
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

                            /// btn
                            Bounceable(
                              onTap: () {
                                Get.defaultDialog(
                                  title: '',
                                  barrierDismissible: false,
                                  content: const CreateChoiceDialog(),
                                  /// barrierDismissible: false,
                                );
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: height(context) * 0.03, vertical: 12.0),
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
                      SizedBox(height: height(context) * 0.03),
                      Wrap(
                        runSpacing: 10,
                        spacing: 10,
                        children:List.generate(_widgets.length, (index) {
                          return DragTarget<int>(
                            onAccept: (data) {
                              _reorderWidgets(data, index);
                            },
                            onLeave: (ind){
                              log("message $index");
                            },
                            onMove: (detail){
                              log("detail ${detail.data}");
                            },

                            builder: (context, candidateData, rejectedData) {
                              return DraggableWidget(
                                index: index,
                                onReorder: _reorderWidgets,
                                child: _widgets[index],
                              );
                            },
                          );
                        }),
                      ),
                    ],
                  );
                } else {
                  return const Center(child: Text("Some went wrong"));
                }
              }
          ),
        ],
      ),
    );
  }
  Widget preView(){
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: height(context) * 0.03),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(height: height(context) * 0.03),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text('Choices:',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    fontSize: height(context) * 0.025,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              IconButtonWidget(onTap: () {
                setState(() {
                  selected = null;
                });
              }, iconPath: AppIcons.arrowIcon),
              SizedBox(width: height(context) * 0.016),
              IconButtonWidget(onTap: () {}, iconPath: AppIcons.deleteIcon),
              SizedBox(width: height(context) * 0.016),
              IconButtonWidget(onTap: () {}, iconPath: AppIcons.editIcon),
            ],
          ),
          const SizedBox(height: 8.0),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(height(context) * 0.024),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.0),
                  color: AppColors.greyColor,
                ),
                child: SvgPicture.asset(AppIcons.scanIcon),
              ),
              SizedBox(width: height(context) * 0.024),
              Bounceable(
                onTap: () {
                  ///Get.to(IndustryScreen());
                },
                child: Container(
                  padding: EdgeInsets.symmetric(
                      horizontal: height(context) * 0.03, vertical: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40.0),
                    color: AppColors.whiteColor,
                    boxShadow: shadowsOne,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Download',
                        style: montserratBold.copyWith(
                          fontSize: 16.0,
                          color: AppColors.secondaryColor,
                        ),
                      ),
                      const SizedBox(width: 5.0),
                      SvgPicture.asset(AppIcons.downloadIcon, color: AppColors.secondaryColor,),
                    ],
                  ),
                ),
              ),
            ],
          ),

          /// texts
          SizedBox(height: height(context) * 0.03),
          headingText('Title:'),
          SizedBox(height: height(context) * 0.005),
          dateText(selected!.title),

          SizedBox(height: height(context) * 0.02),
          headingText('file'),
          SizedBox(height: height(context) * 0.005),
          dateText(selected!.dialogMessage),

          SizedBox(height: height(context) * 0.02),
          headingText('Company:'),
          SizedBox(height: height(context) * 0.005),
          dateText(selected!.companyName),
        ],
      ),
    );
  }
  Widget headingText(text) {
    return Text('$text',
      style: GoogleFonts.openSans(
        fontSize: height(context) * 0.025,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget dateText(text) {
    return Text('$text',
      style: GoogleFonts.openSans(
        fontSize: height(context) * 0.025,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/controllers/logo_controller.dart';
import 'package:pliiz_web/model/waiting_model.dart';
import 'package:pliiz_web/widgets/waiting_list_box.dart';
import 'package:pliiz_web/widgets/web_app_bar_widget.dart';
import '../../../constants/exports.dart';
import '../../dialogs/action_text_dialog.dart';

class WaitingList extends StatefulWidget {
  const WaitingList({Key? key}) : super(key: key);
  @override
  State<WaitingList> createState() => _WaitingListState();
}

class _WaitingListState extends State<WaitingList> {
  final logo = Get.put(LogoController());
  final db = FirebaseFirestore.instance;
  final datetime = DateTime.now();
  String uui = FirebaseAuth.instance.currentUser!.uid;
  List<WaitingModel> list = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 16,left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const WebAppBar(titleText: 'Waiting List'),
          const SizedBox(height: 16),
          Expanded(child: StreamBuilder<QuerySnapshot>(
              stream: db.collection(collectionWaiting).where("companyId", isEqualTo: uui).orderBy("stamp", descending: true).snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  list = [];
                  for(var doc in snapshot.data!.docs){
                    Map<String,dynamic> json =  doc.data() as Map<String,dynamic>;
                    WaitingModel wait = WaitingModel.fromMap(map: json, id: doc.id);
                    list.add(wait);
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
                              '${list.length} Waiting',
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

                          ],
                        ),
                      ),
                      SizedBox(height: height(context) * 0.02),
                      Wrap(
                        runAlignment: WrapAlignment.center,
                        spacing: 16,
                        runSpacing: 16,
                        children: list.map((e) => WaitingListBox(model: e)).toList(),
                      ),
                      SizedBox(height: height(context) * 0.02),
                    ],
                  );
                } else if(snapshot.hasError){
                  return const Text("Error");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }
          ),),
          Row(

            children: [
              Text(
                'Add Logo :',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                  fontSize: height(context) * 0.025,
                ),
              ),
              const SizedBox(width: 150),
              Text(
                'Action Text :',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w700,
                  color: AppColors.blackColor,
                  fontSize: height(context) * 0.025,
                ),
              ),
            ],
          ),
          SizedBox(height: height(context) * 0.02-5),
          StreamBuilder<DocumentSnapshot>(
              stream: db.collection(collectionLogos).doc(uui).snapshots(),
              builder: (context,snapshot){
                if(snapshot.hasData){
                  String url = "";
                  String text = "";
                  if(snapshot.data != null){
                    if(snapshot.data!.exists){
                      Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
                      url = data["url"]??"";
                      text = data["text"]??"";
                    }
                  }
                  return Row(
                    children: [
                      url.isNotEmpty?  Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Image.network(url,height: 80,width: 80,),
                          ),
                          Positioned(
                              top: 0,
                              right: 0,
                              child: IconButton(
                                icon: const Icon(Icons.delete_outline),
                                onPressed: () async {
                                  await db.collection(collectionLogos).doc(snapshot.data!.id).update({
                                    "url": "",
                                  });
                                },
                              )
                          ),
                        ],
                      ):Container(
                        height: 100,
                        width: 100,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text("No"),
                      ),
                      const SizedBox(width: 16),
                      MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: GestureDetector(
                          onTap: logo.pickFile,
                          child: Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.image_outlined,size: 35),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Stack(
                        children: [
                          Container(
                            height: 100,
                            width: 150,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child:text.isEmpty? const Icon(Icons.text_fields_outlined,size: 35):Text(text),
                          ),
                          Positioned(
                              right: 10,
                              child: IconButton(icon: const Icon(Icons.edit),onPressed: (){
                                logo.updateSetTex(text,url);
                                Get.dialog(const Dialog(child: ActionTextDialog()));
                              },))
                        ],
                      ),
                    ],
                  );
                } else if(snapshot.connectionState == ConnectionState.waiting){
                  return Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const CircularProgressIndicator(),
                  );
                } else {
                  return Container(
                    height: 100,
                    width: 100,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Text("No"),
                  );
                }
              }
          ),
        ],
      ),
    );
  }
}

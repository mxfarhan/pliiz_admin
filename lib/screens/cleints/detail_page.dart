import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/helpers/functions.dart';
import 'package:pliiz_web/helpers/routes.dart';
import 'package:pliiz_web/model/choices_model.dart';
import 'package:pliiz_web/model/qrcode_model.dart';
import 'package:pliiz_web/model/waiting_model.dart';
import 'package:short_uuids/short_uuids.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../constants/exports.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);
  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final db = FirebaseFirestore.instance;
  List<ChoicesModel> options = [];
  
  String id = "";
  @override
  void initState() {
    setState(() {
      id = Get.parameters["id"]??"";
    });

    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    return SafeArea(
      child: Scaffold(
        //appBar: AppBar(title: Text(id),),
        body: id.isNotEmpty?Container(
          padding: EdgeInsets.only(left: Get.width * 0.15,right: Get.width * 0.15),
          height: Get.height,
          width: Get.width,
          child: StreamBuilder<DocumentSnapshot>(
            stream: db.collection(collectionQrCode).doc(id).snapshots(),
            builder: (context,snapshot){
              if(snapshot.hasError){
                return const Center(child: Text("Some think is wrong"));
              } else if(snapshot.hasData){

                DocumentSnapshot document = snapshot.data!;
                if(document.exists){
                  Map<String, dynamic> data = document.data() as Map<String, dynamic>;
                  QrCodeModel code = QrCodeModel.fromJson(json: data, id: document.id);

                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        width: Get.width,
                        alignment: Alignment.center,
                        child: Text(code.title,style: GoogleFonts.poppins(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        )),
                      ),
                      StreamBuilder<DocumentSnapshot>(
                          stream: db.collection(collectionLogos).doc(code.userId).snapshots(),
                          builder: (context, snapshot) {
                            if(snapshot.hasData){
                              String url = "";
                              String text = "";
                              if(snapshot.data != null){
                                if(snapshot.data!.exists){
                                  Map<String,dynamic> data = snapshot.data!.data() as Map<String,dynamic>;
                                  url =data["url"]??"";
                                  text =data["text"]??"";
                                }
                              }
                              return Column(
                                children: [
                                  url.isNotEmpty? SizedBox(
                                    width: Get.width,
                                    child: Image.network(url,width: 80,height: 80),
                                  ):Container(),
                                  Container(
                                    width: Get.width,
                                    alignment: Alignment.center,
                                    child: Text(text.isEmpty? "Choose Action":text,style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.grey,
                                    )),
                                  ),
                                ],
                              );
                            } else {
                              return Container();
                            }
                          }),
                      SizedBox(height: height(context) * 0.01),
                      Divider(
                        height: 0.6,
                        thickness: 0.6,
                        color: AppColors.blackColor.withOpacity(0.5),
                      ),
                      SizedBox(height: height(context) * 0.05),
                      menuBuilder(id: code),
                    ],
                  );
                }else {
                  return SizedBox(
                    width: Get.width,
                    child: const Text("No Data"),
                  );
                }
              }else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ):const Text("Fuck"),
      ),
    );
  }
  Widget menuBuilder({required QrCodeModel id}){
    return StreamBuilder<QuerySnapshot>(
        stream: db.collection(collectionChoices).where("userId",isEqualTo: id.userId).snapshots(),
        builder: (context,snapshot){
          if(snapshot.hasError){
            return const Text("Some is wrong");
          } else if(snapshot.hasData){
            options = [];
            for(var doc in snapshot.data!.docs){
              Map<String,dynamic> data = doc.data() as Map<String, dynamic>;
              ChoicesModel choices = ChoicesModel.fromMap(map: data, id: doc.id);
              options.add(choices);
            }
            return options.isNotEmpty?Wrap(
              alignment: WrapAlignment.center,
              spacing: 16,
              runSpacing: 16,
              children: options.map((e) => MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => handleAction(choice: e,code: id),
                  child: Container(
                    width: Get.width>250?250:Get.width,
                    height: 130,
                    decoration: BoxDecoration(
                        color: AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(12)
                    ),
                    child: Column(
                      children: [
                        Container(
                          height: 80,
                          margin: const EdgeInsets.only(left: 16,right: 16,top: 4),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8)
                          ),
                          width: context.width,
                          child: Center(child: Icon(iconData(name: e.title,),color: AppColors.primaryColor,size: 38,),),
                        ),
                        Expanded(child: Center(child: Text(e.title,style: GoogleFonts.poppins(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),),)),
                      ],
                    ),
                  ),
                ),
              )).toList(),
            ):const Center(child: Text("Menu Not avaible"),);
          } else {
            return const Center(child: CircularProgressIndicator(),);
          }
        });
  }
  void handleAction({required ChoicesModel choice,required QrCodeModel code}) async {

    if(choice.dialogMessage.isNotEmpty){
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
                  Text("Thank you for waiting",style: GoogleFonts.poppins(
                    fontSize: 22,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),),
                  Text(choice.dialogMessage,style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500,
                  ),),
                  const SizedBox(height: 30),
                  Bounceable(
                    onTap: () => handleConfirm(choice: choice,code: code),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: height(context) * 0.07,
                          vertical: 12.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(40.0),
                        color: AppColors.whiteColor,
                        boxShadow: shadowsOne,
                      ),
                      child: Text('Confirm',
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
    } else if(choice.isUrl){
      final Uri url = Uri.parse(choice.fileName);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    }
    else if(choice.fileName.isNotEmpty){
      Get.toNamed("${RoutKeys().viewMenuPage}?name=${choice.fileName}");
    }
  }
  void handleConfirm({required ChoicesModel choice,required QrCodeModel code}) async {
    const short = ShortUuid();
    final id = short.generate();

    Get.back();
    Get.dialog(
        Dialog(
          child: Container(
            height:  Get.height>350?350:Get.width - 100,
            padding: const EdgeInsets.all(16),
            width: Get.width>350?350:Get.width,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                CircularProgressIndicator()
              ],
            ),
          ),
        )
    );
    WaitingModel waiting = WaitingModel(
      wId: id,
      qrTitle: code.title,
      qrId: code.qrCodeId,
      qrLocation: code.location,
      qrType: code.type,
      qrHola: code.hola,
      cId: choice.id,
      cTitle: choice.title,
      stamp: FieldValue.serverTimestamp(),
      companyId: code.userId,
      empId: code.empId,
      token: "",
    );
    try{
      for(var i in code.hola) {
        await sendPushMessage(title: code.location,body: choice.title,topic: i);
      }
    }catch(e){
      print(e);
    }
    try{
      await db.collection(collectionWaiting).doc(id).set(waiting.toMap());
    }catch(e){
      print(e);
    }
    Get.back();
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
                Text("Thank you for waiting",style: GoogleFonts.poppins(
                  fontSize: 22,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),),
                Text(choice.messageAfterConform,style: GoogleFonts.poppins(
                  fontSize: 18,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
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


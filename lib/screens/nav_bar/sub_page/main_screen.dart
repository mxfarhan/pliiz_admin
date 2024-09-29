import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:pliiz_web/controllers/choices.controller.dart';
import 'package:pliiz_web/model/user_model.dart';
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/main.dart';
import 'package:pliiz_web/model/qrcode_model.dart';
import 'package:pliiz_web/widgets/icon_button.dart';
import 'package:pliiz_web/widgets/qr_box_widget.dart';
import 'package:pliiz_web/widgets/web_app_bar_widget.dart';

import '../../../constants/exports.dart';
import '../../dialogs/new_qr_dialog.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final db = FirebaseFirestore.instance;
  String uui = FirebaseAuth.instance.currentUser!.uid;
  List<QrCodeModel> qrCodes = [];
  QrCodeModel? selected;
  bool isQrCreate = false;
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
          const WebAppBar(titleText: 'Owned QRs'),

          ///
          if (selected != null)
            preView()
          else
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                StreamBuilder<QuerySnapshot>(
                    stream: db
                        .collection(collectionQrCode)
                        .where("userId", isEqualTo: uui)
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }else if (snapshot.hasData) {
                        qrCodes = [];
                        for (var doc in snapshot.data!.docs) {
                          Map<String, dynamic> json = doc.data() as Map<String, dynamic>;
                          try {
                            QrCodeModel qr = QrCodeModel.fromJson(json: json, id: doc.id);
                            qrCodes.add(qr);
                          } catch (e) {
                            print("Error parsing QR code data: $e");
                          }
                        }
                        return Column(
                          children: [
                            SizedBox(height: height(context) * 0.03),
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
                                    '${qrCodes.length} QRs',
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
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(uui)
                                          .get()
                                          .then((value) {
                                        Map<String, dynamic> json = value.data()
                                            as Map<String, dynamic>;
                                        // print('this is value $json');
                                        UserModel user =
                                            UserModel.fromSnapshot(json);
                                        if (kDebugMode) {
                                          print(
                                            'this is uid ${qrCodes.length}  ${user.noOfQRCodes!.toInt()}');
                                        }
                                        qrCodes.length >=
                                                user.noOfQRCodes!.toInt()
                                            ? isQrCreate = false
                                            : isQrCreate = true;
                                      });
                                      if (!isQrCreate) {
                                        toast('You have reached your limit');
                                        return;
                                      } else {
                                        Get.defaultDialog(
                                          title: '',
                                          content: const NewQRDialog(),

                                          /// barrierDismissible: false,
                                        );
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: height(context) * 0.03,
                                          vertical: 12.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
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
                                  const Spacer(),
                                  Bounceable(
                                    onTap: downloadAllFunction,
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: height(context) * 0.03,
                                          vertical: 12.0),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(40.0),
                                        color: AppColors.whiteColor,
                                        boxShadow: shadowsOne,
                                      ),
                                      child: Text(
                                        'Download All',
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
                            SizedBox(height: height(context) * 0.03),
                            Container(
                              height: Get.height - 200,
                              child: qrCodes.isEmpty
                                  ? Center(child: Text("No QR Codes Available"))
                                  : SingleChildScrollView(
                                child: Wrap(
                                  spacing: 10,
                                  runSpacing: 10,
                                  children: qrCodes
                                      .map(
                                        (e) => QRBoxWidget(
                                      askText: e.title,
                                      qrCode: e,
                                      onTap: () {
                                        setState(() {
                                          selected = e;
                                        });
                                      },
                                    ),
                                  )
                                      .toList(),
                                ),
                              ),
                            )

                            // Container(
                            //   height: Get.height - 200,
                            //   child: SingleChildScrollView(
                            //     child: Wrap(
                            //       spacing: 10,
                            //       runSpacing: 10,
                            //       children: qrCodes
                            //           .map(
                            //             (e) => QRBoxWidget(
                            //               askText: e.title,
                            //               qrCode: e,
                            //               onTap: () {
                            //                 setState(() {
                            //                   selected = e;
                            //                 });
                            //               },
                            //             ),
                            //           )
                            //           .toList(),
                            //     ),
                            //   ),
                            // ),
                          ],
                        );
                      } else {
                        print(snapshot.error);
                        return const Center(child: Text("Some went wrong"));
                      }
                    }),
              ],
            ),
        ],
      ),
    );
  }

  Widget preView() {
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
                child: Text(
                  'Your QR:',
                  style: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    fontSize: height(context) * 0.025,
                    color: AppColors.blackColor,
                  ),
                ),
              ),
              IconButtonWidget(
                  onTap: () {
                    setState(() {
                      selected = null;
                    });
                  },
                  iconPath: AppIcons.arrowIcon),
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
                      SvgPicture.asset(
                        AppIcons.downloadIcon,
                        color: AppColors.secondaryColor,
                      ),
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
          headingText('Assigned to:'),
          SizedBox(height: height(context) * 0.005),
          dateText(selected!.location),

          SizedBox(height: height(context) * 0.02),
          headingText('Location:'),
          SizedBox(height: height(context) * 0.005),
          dateText(selected!.hola),
        ],
      ),
    );
  }

  Widget headingText(text) {
    return Text(
      '$text',
      style: GoogleFonts.openSans(
        fontSize: height(context) * 0.025,
        color: Colors.black,
        fontWeight: FontWeight.w400,
      ),
    );
  }

  Widget dateText(text) {
    return Text(
      '$text',
      style: GoogleFonts.openSans(
        fontSize: height(context) * 0.025,
        color: Colors.black,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void downloadAllFunction() async {
    for (var qr in qrCodes) {
      String data = "${box.read("domain")}/d?id=${qr.qrCodeId}";
      final url =
          'https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=$data';
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final imageData = response.bodyBytes;
        final base64Image = base64Encode(imageData);
        final dataUri = 'data:image/png;base64,$base64Image';
        html.AnchorElement(href: dataUri)
          ..setAttribute('download', '${qr.title}_${qr.location}.png')
          ..click();
      } else {
        throw Exception('Failed to generate QR code.');
      }
    }
  }
}

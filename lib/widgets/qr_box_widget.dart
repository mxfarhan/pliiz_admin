import 'dart:convert';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:universal_html/html.dart' as html;
import 'package:pliiz_web/controllers/home.controller.dart';
import 'package:pliiz_web/main.dart';
import 'package:pliiz_web/model/qrcode_model.dart';
import 'package:widgets_to_image/widgets_to_image.dart';
import 'package:http/http.dart' as http;
import '../constants/exports.dart';
import 'icon_button.dart';

class QRBoxWidget extends StatefulWidget {
  final String? askText;
  final VoidCallback? onTap;
  final QrCodeModel qrCode;
  const QRBoxWidget({
    Key? key,
    required this.askText,
    required this.qrCode,
    required this.onTap,
  }) : super(key: key);

  @override
  State<QRBoxWidget> createState() => _QRBoxWidgetState();
}

class _QRBoxWidgetState extends State<QRBoxWidget> {
  WidgetsToImageController controller = WidgetsToImageController();
  final storage = FirebaseStorage.instance;
  final home = Get.put(HomeController());
  String qrImageUrl = '';
  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: widget.onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        margin: const EdgeInsets.only(left: 30),
        width: Get.width,
        decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            /*Container(
              height: height(context) * 0.15,
              width: height(context) * 0.26,
              decoration: BoxDecoration(
                color: AppColors.greyColor,
                borderRadius: BorderRadius.circular(24.0),
              ),
              child: Container(
                height: height(context) * 0.15,
                width: height(context) * 0.24,
                decoration: BoxDecoration(
                  color: AppColors.greyColor,
                  borderRadius: BorderRadius.circular(24.0),
                ),
                child: Center(
                  child: SvgPicture.asset(
                    AppIcons.scanIcon,
                    height: height(context) * 0.1,
                    width: height(context) * 0.1,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),*/
           // const SizedBox(height: 16),
            Text(
              widget.qrCode.title,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor,
                fontSize: height(context) * 0.021,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              widget.qrCode.location,
              style: GoogleFonts.openSans(
                fontWeight: FontWeight.w400,
                color: AppColors.blackColor,
                fontSize: height(context) * 0.021,
              ),
            ),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'Assigned to: ',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w400,
                      color: AppColors.blackColor,
                      fontSize: height(context) * 0.015,
                    ),
                  ),
                  TextSpan(
                    text: widget.qrCode.hola.toString(),
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                      fontSize: height(context) * 0.015,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: height(context) * 0.03),
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButtonWidget(onTap: () => download(), iconPath: AppIcons.downloadIcon),
                SizedBox(width: height(context) * 0.01),
                IconButtonWidget(onTap: () => viewQrCode(), iconPath: AppIcons.zipIcon),
                SizedBox(width: height(context) * 0.01),
                IconButtonWidget(onTap: () => home.deleteQrCode(id: widget.qrCode.qrCodeId), iconPath: AppIcons.deleteIcon),
                SizedBox(width: height(context) * 0.01),
                IconButtonWidget(onTap: () => home.updateQrCode(widget.qrCode), iconPath: AppIcons.editIcon),
              ],
            ),
          ],
        ),
      ),
    );
  }
  void viewQrCode() async {
    String data = "${box.read("domain")}/d?id=${widget.qrCode.qrCodeId}";
    Clipboard.setData(ClipboardData(text: data)).then((_) {
      Fluttertoast.showToast(
          msg: "Copied to your clipboard !",
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,
          timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16.0
      );
    });
    /*final url = 'https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=$data';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final imageData = response.bodyBytes;
      final imageBase64 = base64Encode(imageData);
      qrImageUrl = "data:image/png;base64,$imageBase64";
      html.AnchorElement(href: url)
        ..download = "filename.png"
        ..click();
      html.Url.revokeObjectUrl(url);
    } else {
      throw Exception('Failed to generate QR code.');
    }*/
  }
  void download() async {
    String data = "${box.read("domain")}/d?id=${widget.qrCode.qrCodeId}";
    final url = 'https://chart.googleapis.com/chart?cht=qr&chs=200x200&chl=$data';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final imageData = response.bodyBytes;
      final base64Image = base64Encode(imageData);
      final dataUri = 'data:image/png;base64,$base64Image';
      html.AnchorElement(href: dataUri)
        ..setAttribute('download', '${widget.qrCode.location}.png')
        ..click();
    } else {
      throw Exception('Failed to generate QR code.');
    }
  }
}


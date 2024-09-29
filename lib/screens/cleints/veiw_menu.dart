import 'dart:typed_data';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdfx/pdfx.dart';

class ViewMenuPage extends StatefulWidget {
  const ViewMenuPage({Key? key}) : super(key: key);
  @override
  State<ViewMenuPage> createState() => _ViewMenuPageState();
}

class _ViewMenuPageState extends State<ViewMenuPage> {
  late PdfController pdfPinchController;
  final storage = FirebaseStorage.instance;
  String fileName = "";
  Uint8List? documentBytes;

  void init() async {
    final bytes = await storage.ref("menus/$fileName").getData();
    setState(() {
      documentBytes = bytes;
      pdfPinchController = PdfController(document: PdfDocument.openData(Future.value(bytes)));
    });
  }
  @override
  void initState() {
    setState(() {
      fileName = Get.parameters["name"]??"";
    });
    init();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: documentBytes != null?PdfView(
        controller: pdfPinchController,
      ):const Center(child: CircularProgressIndicator(),),
    );
  }
}


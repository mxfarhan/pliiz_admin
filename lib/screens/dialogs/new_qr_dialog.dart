import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/exports.dart';
import 'package:pliiz_web/controllers/home.controller.dart';
import 'package:pliiz_web/widgets/custom_text_field.dart';
import '../../constants/db_contansts.dart';

class NewQRDialog extends StatefulWidget {
  const NewQRDialog({Key? key}) : super(key: key);
  @override
  State<NewQRDialog> createState() => _NewQRDialogState();
}

class _NewQRDialogState extends State<NewQRDialog> {
  final home= Get.put(HomeController());
  final db = FirebaseFirestore.instance;
  String selectedValue = "1";

  final titleController = TextEditingController();
  final locationController = TextEditingController();

  bool isTitleClick = true;
  bool isLocationClick = false;


  @override
  Widget build(BuildContext context) {
    Widget locationBuilder(List locations){
      return GetBuilder(
        init: home,
          builder: (_) => SizedBox(
            width: height(context) * 0.5,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                color: AppColors.greyColor,
              ),
              child: Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) async {
                  if (textEditingValue.text == '') {
                    return const [];
                  }
                  var data = locations.where((option){
                    return  option.contains(textEditingValue.text.toLowerCase().toString());
                  });
                  return Future.value(data.map((e) => e.toString()));
                },
                onSelected: (String selection) {
                  debugPrint('You just selected $selection');
                },
                fieldViewBuilder: (BuildContext context, TextEditingController textEditingController, FocusNode focusNode, VoidCallback onFieldSubmitted) {
                  return TextFormField(
                    maxLines: 1,
                    cursorColor: Colors.black38,
                    decoration: const InputDecoration(
                      hintText: "Select Location N:",
                      fillColor: Colors.white,
                      label: Text("Select Location N:"),
                      border: InputBorder.none,
                      hintStyle: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    onFieldSubmitted: (String value) {

                    },
                    controller: textEditingController,
                    focusNode: focusNode,
                    onChanged: (text) => home.selectLocation(text),

                  );
                },
                optionsViewBuilder: (BuildContext context, AutocompleteOnSelected<String> onSelected, Iterable<String> options) {
                  return Align(
                    alignment: Alignment.topLeft,
                    child: Material(
                      child: Container(
                        height: 40*6,
                        width: Get.width * 0.25,
                        color: Colors.white,
                        child: ListView.builder(
                          padding:const EdgeInsets.all(10.0),
                          itemCount: options.length>6?5:options.length,
                          itemBuilder: (BuildContext context, int index) {
                            final String option = options.elementAt(index);
                            return GestureDetector(onTap: () {
                              onSelected(option);
                              home.selectLocation(option);
                            },
                              child: Container(
                                height: 40,
                                padding: const EdgeInsets.only(top: 11,bottom: 3,left: 10),
                                margin: const EdgeInsets.only(bottom: 4),
                                child: Text(option,style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w500,
                                ),),),
                            );
                          },
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          )
      );
    }
    return Container(
      width: Get.width * 0.5,
      height: Get.height * 0.5,
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: height(context) * 0.03),
      child: StreamBuilder<DocumentSnapshot>(
        stream: db.collection(appDataCollection).doc(industeriesKey).snapshots(),
        builder: (context,snapshot){
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: CircularProgressIndicator());
          } else if(snapshot.hasData){
            Map<String , dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
            List locations = data["locations"];
            return Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                  width: height(context) * 0.5,
                  child: CustomTextField(
                    margin: 0.0,
                    controller: home.title,
                    fieldColor:  AppColors.whiteColor,
                    fieldShadow: shadowsTwo,
                    obscureText: false,
                    suffixIcon: null,
                    labelText: 'Area title',
                    hintText: 'Enter Area Title',
                    labelTextColor: AppColors.blackColor.withOpacity(0.5),
                    hintTextColor: AppColors.blackColor.withOpacity(0.5),
                  ),
                ),
                SizedBox(height: height(context) * 0.024),
                /*holaBuilder(hola),
                SizedBox(height: height(context) * 0.024),*/
                locationBuilder(locations),
                /// generate btn
                SizedBox(height: height(context) * 0.07),
                Center(
                  child: Bounceable(
                    onTap: () => home.addQrCode(),
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
            );
          } else {
            return const Center(child: Text("Check Internet Connection"));
          }
        },
      ),
    );
  }
}

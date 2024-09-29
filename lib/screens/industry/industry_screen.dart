import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/constants/db_contansts.dart';
import 'package:pliiz_web/controllers/home.controller.dart';
import 'package:pliiz_web/helpers/routes.dart';
import 'package:pliiz_web/main.dart';
import '../../constants/exports.dart';

class IndustryScreen extends StatefulWidget {
  const IndustryScreen({Key? key}) : super(key: key);

  @override
  State<IndustryScreen> createState() => _IndustryScreenState();
}

class _IndustryScreenState extends State<IndustryScreen> {

  final db = FirebaseFirestore.instance;
  final home = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: home,
      builder: (_) {
        return Scaffold(

          /// body
          body: Padding(
            padding: EdgeInsets.symmetric(horizontal: height(context) * 0.12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(AppIcons.appIcon),
                      SizedBox(height: height(context) * 0.035),
                      Text('Let’s Know More\nabout us!',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(
                          fontSize: height(context) * 0.063,
                          fontWeight: FontWeight.w700,
                          color: AppColors.secondaryColor.withOpacity(0.9),
                        ),
                      ),
                      SizedBox(height: height(context) * 0.003),
                      Text('Quia veritatis qui aut magnam rerum animi omnis exercitationem. Minus sapiente suscipit quaerat sint. '
                          'Possimus omnis vel ullam officiis. Itaque maxime asperiores omnis qui odio sunt hic. '
                          'Et ea tenetur pariatur dolorum est corrupti nostrum.',
                        textAlign: TextAlign.end,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          color: AppColors.blackColor.withOpacity(0.5),
                          fontSize: height(context) * 0.024,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: height(context) * 0.12),
                Expanded(
                  child: Container(
                    height: height(context),
                    width: width(context),
                    margin: EdgeInsets.symmetric(vertical: height(context) * 0.09),
                    decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(28.0),
                      boxShadow: shadowsOne,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [

                        Text('Please select your industry!',
                          style: GoogleFonts.montserrat(
                            fontWeight: FontWeight.w700,
                            color: AppColors.whiteColor,
                            fontSize: height(context) * 0.037,
                          ),
                        ),
                        SizedBox(height: height(context) * 0.1),
                        StreamBuilder<DocumentSnapshot>(
                            stream: db.collection(appDataCollection).doc(industeriesKey).snapshots(),
                            builder: (context,snapshot){
                              if(snapshot.connectionState == ConnectionState.waiting){
                                return const Center(child: CircularProgressIndicator());
                              } else if(snapshot.hasData) {
                                Map<String , dynamic> data = snapshot.data!.data() as Map<String, dynamic>;
                                List dust = data["industeries"];
                                String url = data["domain"];

                                return Column(
                                  children: dust.map((e){
                                    return Padding(
                                      padding: EdgeInsets.symmetric(horizontal: height(context) * 0.15),
                                      child: Bounceable(
                                        onTap: () => home.selectIndustry(e),
                                        child: Container(
                                          margin: const EdgeInsets.only(bottom: 16),
                                          padding: EdgeInsets.all(height(context) * 0.016),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30.0),
                                            color: home.selectedIndustry == e ?  AppColors.whiteColor : AppColors.whiteColor.withOpacity(0.1),
                                            boxShadow: home.selectedIndustry  == e ? shadowsTwo : null,
                                          ),
                                          child: Row(
                                            crossAxisAlignment: CrossAxisAlignment.center,
                                            children: [
                                              Container(
                                                height: 18.0,
                                                width: 18.0,
                                                padding: const EdgeInsets.all(3),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: home.selectedIndustry  == e ? AppColors.secondaryColor : AppColors.whiteColor.withOpacity(0.3),
                                                    width: 2.5,
                                                  ),
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: home.selectedIndustry  == e ? AppColors.secondaryColor : Colors.transparent,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(width: 8.0),
                                              Text(e,
                                                style: montserratRegular.copyWith(
                                                  fontSize: 15.0,
                                                  color: home.selectedIndustry  == e ? AppColors.secondaryColor : AppColors.whiteColor.withOpacity(0.6),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                );
                              } else {
                                return const Center(child: Text("Some Went Wrone"));
                              }
                            }
                        ),
                        /// confirm btn
                        SizedBox(height: height(context) * 0.1),
                        Bounceable(
                          onTap: () => Get.toNamed(RoutKeys().homePage),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: height(context) * 0.07, vertical: 12.0),
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
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      }
    );
  }
}

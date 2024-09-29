import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pliiz_web/controllers/auth_controller.dart';
import '../constants/exports.dart';

class WebAppBar extends StatefulWidget {
  final String? titleText;
  const WebAppBar({
    Key? key,
    required this.titleText,
  }) : super(key: key);

  @override
  State<WebAppBar> createState() => _WebAppBarState();
}

class _WebAppBarState extends State<WebAppBar> {
  final me = FirebaseAuth.instance.currentUser;
  final login = Get.put(AuthController());
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
            horizontal: height(context) * 0.03,
            vertical: height(context) * 0.016,
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// title
              Text(
                '${widget.titleText}',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.w800,
                  color: AppColors.blackColor,
                  fontSize: height(context) * 0.038,
                ),
              ),

              /// divider
              Container(
                width: 1.5,
                height: height(context) * 0.045,
                margin:
                    EdgeInsets.symmetric(horizontal: height(context) * 0.03),
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

              /// search bar
              TextFormField(
                decoration: InputDecoration(
                  prefixIcon: SvgPicture.asset(AppIcons.searchIcon,
                      fit: BoxFit.scaleDown),
                  constraints: BoxConstraints(
                    maxHeight: height(context) * 0.05,
                    maxWidth: height(context) * 0.5,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      color: AppColors.fieldColor,
                      width: 0.2,
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      color: AppColors.fieldColor,
                      width: 0.2,
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: const BorderSide(
                      color: AppColors.fieldColor,
                      width: 0.2,
                    ),
                  ),
                  filled: true,
                  fillColor: AppColors.fieldColor,
                  contentPadding: const EdgeInsets.only(bottom: 16),
                  hintText: 'Search anything',
                  hintStyle: GoogleFonts.openSans(
                    fontWeight: FontWeight.w400,
                    color: AppColors.blackColor.withOpacity(0.5),
                    fontSize: height(context) * 0.016,
                  ),
                ),
              ),

              const Expanded(child: SizedBox()),
              me != null?Row(
                children: [
                  Text(
                    me!.displayName?? '',
                    style: GoogleFonts.openSans(
                      fontWeight: FontWeight.w700,
                      color: AppColors.blackColor,
                      fontSize: height(context) * 0.016 + 4,
                    ),
                  ),
                  SizedBox(width: height(context) * 0.01),
                  me!.photoURL!=null?CircleAvatar(
                    radius: 22,
                    backgroundImage: NetworkImage(me!.photoURL!),
                  ): const CircleAvatar(
                    radius: 22,
                    backgroundImage: AssetImage(AppImages.userImage),
                  ),
                ],
              ):Container(),
            ],
          ),
        ),
        SizedBox(height: height(context) * 0.01),
        Divider(
          height: 0.6,
          thickness: 0.6,
          color: AppColors.blackColor.withOpacity(0.5),
        ),
      ],
    );
  }
}

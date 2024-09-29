import 'package:flutter/material.dart';

import '../constants/exports.dart';

class NavBarItem extends StatelessWidget {
  final bool? isActive;
  final String? activeIconPath;
  final String? iconPath;
  final String? text;
  final VoidCallback? onTap;
  final Color? inActiveIconColor;
  final Color? activeIconColor;

  const NavBarItem({
    Key? key,
    required this.isActive,
    required this.activeIconPath,
    required this.iconPath,
    required this.text,
    required this.onTap,
    this.inActiveIconColor,
    this.activeIconColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              isActive == true
                  ? const SizedBox()
                  : SizedBox(width: height(context) * 0.05),
              isActive == true
                  ? Container(
                      height: height(context) * 0.04,
                      width: height(context) * 0.08,
                      decoration: const BoxDecoration(
                        color: AppColors.secondaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20.0),
                          bottomRight: Radius.circular(20.0),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            activeIconPath!,
                            color: activeIconColor ?? AppColors.whiteColor,
                          ),
                          SizedBox(width: height(context) * 0.016),
                        ],
                      ),
                    )
                  : SvgPicture.asset(
                      iconPath!,
                      color: inActiveIconColor ?? AppColors.blackColor.withOpacity(0.5),
                    ),
              SizedBox(width: height(context) * 0.016),
              Text(
                text!,
                style: GoogleFonts.openSans(
                  fontWeight: isActive == true
                      ? FontWeight.w700
                      : FontWeight.w400,
                  color: isActive == true
                      ? AppColors.blackColor
                      : AppColors.blackColor.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

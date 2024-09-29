import 'package:flutter/material.dart';

import '../constants/exports.dart';

class IconButtonWidget extends StatelessWidget {
  final VoidCallback? onTap;
  final String? iconPath;

  const IconButtonWidget({
    Key? key,
    required this.onTap,
    required this.iconPath,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Bounceable(
      onTap: onTap,
      child: Container(
        height: height(context) * 0.045,
        width: height(context) * 0.045,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.greyColor,
        ),
        child: Center(
          child: SvgPicture.asset(iconPath!,
              height: height(context) * 0.018),
        ),
      ),
    );
  }
}

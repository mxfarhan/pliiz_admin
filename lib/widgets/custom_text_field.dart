import 'package:flutter/material.dart';

import '../constants/exports.dart';

class CustomTextField extends StatelessWidget {
  final Color? fieldColor;
  final List<BoxShadow> fieldShadow;
  final bool? obscureText;
  final Widget? suffixIcon;
  final String? labelText;
  final String? hintText;
  final Color? labelTextColor;
  final Color? hintTextColor;
  final TextEditingController? controller;
  final double? margin;
  final String? Function(String?)? validator;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.fieldColor,
    required this.fieldShadow,
    required this.obscureText,
    required this.suffixIcon,
    required this.labelText,
    required this.hintText,
    required this.labelTextColor,
    required this.hintTextColor,
    this.margin,
    this.validator

  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height(context) * 0.08,
      width: width(context),
      margin: EdgeInsets.symmetric(horizontal: margin ?? height(context) * 0.03),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10.0),
        color: fieldColor,
        boxShadow: fieldShadow,
      ),
      child: TextFormField(
        style: montserratMedium.copyWith(
          fontSize: height(context) * 0.02,
          color: AppColors.blackColor,
        ),
        validator: validator,
        controller: controller,
        decoration: InputDecoration(
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(
              horizontal: height(context) * 0.02,
              vertical: height(context) * 0.008),
          labelText: labelText!,
          labelStyle: montserratRegular.copyWith(
            fontSize: height(context) * 0.02,
            color: labelTextColor,
          ),
          suffixIcon: suffixIcon,
          hintText: hintText!,
          hintStyle: montserratMedium.copyWith(
            fontSize: height(context) * 0.02,
            color: hintTextColor,
          ),
        ),
      ),
    );
  }
}

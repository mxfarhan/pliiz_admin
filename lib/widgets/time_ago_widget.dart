import 'dart:async';

import 'package:flutter/material.dart';

import '../constants/app_text_styles.dart';
import '../helpers/functions.dart';

class TimeAgoWidget extends StatefulWidget {
  final int seconds;
  const TimeAgoWidget({Key? key,required this.seconds}) : super(key: key);
  @override
  State<TimeAgoWidget> createState() => _TimeAgoWidgetState();
}

class _TimeAgoWidgetState extends State<TimeAgoWidget> {
  String time = "";
  @override
  void initState() {
    setState(() {
      time = fun(widget.seconds);
    });
    Timer.periodic(const Duration(seconds: 60), (timer) {
      setState(() {
        time = fun(widget.seconds);
      });
    });
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return  Text(time,style: montserratBold.copyWith(
      fontSize: 16.0,
      color: Colors.grey.shade600,
    ),);
  }
}
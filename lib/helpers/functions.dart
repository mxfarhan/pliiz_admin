
import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';

FirebaseDatabase database = FirebaseDatabase.instance;

String fun(seconds){
  final d = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);
  Duration diff = DateTime.now().difference(d);
  if (diff.inDays > 365) {
    return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago";
  }
  if (diff.inDays > 30) {
    return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago";
  }
  if (diff.inDays > 7) {
    return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago";
  }
  if (diff.inDays > 0) {
    return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago";
  }
  if (diff.inHours > 0) {
    return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago";
  }
  if (diff.inMinutes > 0) {
    return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago";
  }
  return "just now";
}


Future sendPushMessage({required String title,required String body,required String topic}) async {
   DataSnapshot snapshot = await database.ref("tokens/$topic").get();
   String token = snapshot.value as String;
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAGSm577M:APA91bEbsM3yVWs_6P0xdHYJG4CNr1RQIyjYyI_XY7euo6VDZ5cQ_3KS1mmyZhoZI0nBIhuZ1dk5c-kYyCyuXjckfw6BLTciEbM8VQ8qO0iVC-ZeGjLUvymd9GdRTBt4cKHWRp1iuzH1',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": token,
        },
      ),
    );
    log(token);
    log("push notification");
  } catch (e) {
    log("error push notification");
  }
}
IconData iconData({required String name}){
  String n = name.toLowerCase();
  if(n.contains("call")){
    return Icons.phone;
  }
  else if(n.contains("bill")){
    return Icons.list_alt_outlined;
  } else if(n.contains("menu")){
    return Icons.menu_book_outlined;
  } else {
    return Icons.chair_alt_outlined;
  }
}

Future sendPushMessageToToken({required String title,required String body,required String topic}) async {
  try {
    await http.post(
      Uri.parse('https://fcm.googleapis.com/fcm/send'),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'key=AAAAGSm577M:APA91bEbsM3yVWs_6P0xdHYJG4CNr1RQIyjYyI_XY7euo6VDZ5cQ_3KS1mmyZhoZI0nBIhuZ1dk5c-kYyCyuXjckfw6BLTciEbM8VQ8qO0iVC-ZeGjLUvymd9GdRTBt4cKHWRp1iuzH1',
      },
      body: jsonEncode(
        <String, dynamic>{
          'notification': <String, dynamic>{
            'body': body,
            'title': title
          },
          'priority': 'high',
          'data': <String, dynamic>{
            'click_action': 'FLUTTER_NOTIFICATION_CLICK',
            'id': '1',
            'status': 'done'
          },
          "to": topic,
        },
      ),
    );
  } catch (_) {}
}


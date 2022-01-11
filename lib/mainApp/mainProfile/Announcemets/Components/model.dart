import 'package:cloud_firestore/cloud_firestore.dart';

class MyAnnouncement {
  MyAnnouncement({this.text1, this.text2, this.date});
  String? text1;
  String? text2;
  Timestamp? date;
}

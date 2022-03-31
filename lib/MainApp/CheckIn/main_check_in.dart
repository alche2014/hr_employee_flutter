// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/CheckIn/checkin_history.dart';
import 'package:hr_app/main.dart';

//-----------checkin History/Screen3---------------//

class MainCheckIn extends StatefulWidget {
  const MainCheckIn({Key? key}) : super(key: key);

  @override
  _MainCheckInState createState() => _MainCheckInState();
}

class _MainCheckInState extends State<MainCheckIn> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: Text("Attendence",
              style: const TextStyle(
                fontFamily: 'Sodia',
                color: Colors.white,
              )),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: <Color>[purpleLight, purpleDark]),
            ),
          ),
        ),
        body: CheckinHistory(memId: uid));
  }
}

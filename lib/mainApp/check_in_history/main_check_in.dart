// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/check_in_history/utility/check_in_card.dart';
import 'package:hr_app/mainApp/check_in_history/utility/drop_down.dart';
import 'package:hr_app/mainApp/check_in_history/utility/linear_bar_indicator.dart';

//-----------checkin History/Screen3---------------//


//-------------Final String defined---------------//

String name = 'Member Name';
String date = '02-05-2021 Thu';
String timeIN = 'Checkin: 09:25am';
String timeOUT = 'Checkout: 06:00pm';
String content = 'Total Working Hours: 8hr 20min';
String late = 'Late';
String onT = 'On Time';

class MainCheckIn extends StatelessWidget {
  const MainCheckIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: buildMyAppBar(context, 'Checkin History', true), //custom appbar
      body: Stack(
        children: [
          const BackgroundCircle(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'Checkin History', true),
            ],
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropDownOpt(),        //dropdown menu define below
                    ],
                  ),
                  SizedBox(height: 10),
                  LeaveCard(),
                  CheckInCard('Late'),
                  CheckInCard('on Time'),
                  CheckInCard('Late'),
                  CheckInCard('on Time'),
                ],
              ),
            ),
          ),
          ),
        ],
      ),
    );
  }
}
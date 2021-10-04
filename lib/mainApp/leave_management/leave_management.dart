import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/about/about.dart';
import 'package:hr_app/mainApp/experiences/main_experiences.dart';
import 'package:hr_app/mainApp/leave_management/leave_history/leave_history.dart';
import 'package:hr_app/mainApp/work_info/work_info.dart';

import 'Utility/leave_card.dart';

String text1 = 'Anual Leaves';
String text2 = 'Casual Leaves';
String text3 = 'Sick Leaves';

class LeaveManagement extends StatelessWidget {
  const LeaveManagement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Leave Management', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Container(
            padding: const EdgeInsets.only(top: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: null,
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => const LeaveHistory()));
                      },
                      child: const Text(
                        'Leaves History',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                LeaveCard(
                  text: text1,
                  press: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => const MainAbout()));
                  },
                ),
                LeaveCard(
                    text: text2,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MyWorkInfo()));
                    }),
                LeaveCard(
                    text: text3,
                    press: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => const MainExperiences()));
                    }),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

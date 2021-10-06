// ignore_for_file: file_names, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class LeaveCard extends StatelessWidget {
  String head;
  String body;
  LeaveCard(this.head, this.body, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(20),
        ),
        color: MediaQuery.of(context).platformBrightness ==
                Brightness.light
                ? Colors.white
                : Color(0xff34354A),
      ),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.white,
              backgroundImage: AssetImage('assets/custom/round.png'),
              radius: 30,
            ),
            SizedBox(width: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$head',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text(
                  '$body',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

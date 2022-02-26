// ignore_for_file: file_names, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';

// ignore: must_be_immutable
class LeaveCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  // String body;
  const LeaveCard({
    this.data,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5.0),
      margin: EdgeInsets.only(top: 10),
      child: Row(
        children: [
          CircleAvatar(
              radius: 25,
              backgroundColor: lightPink,
              child: Icon(
                Icons.layers,
                color: purpleDark,
                size: 32,
              )),
          SizedBox(width: 20),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(data['name'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 8),
              Text(
                (data['leaveQuota'] - data['taken']).toString() +
                    " Leaves Pending",
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

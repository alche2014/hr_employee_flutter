import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

class CheckInCard extends StatelessWidget {
  final timeStatus;
  CheckInCard(this.timeStatus, {Key? key}) : super(key: key);
  late Timestamp timestamp = timeStatus['checkin'] as Timestamp;
  late DateTime dateTime = timestamp.toDate();

  late Timestamp timestamp2 = timeStatus['checkout'] as Timestamp;
  late DateTime dateTime2 = timestamp2.toDate();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: Center(
                child: Container(
                  width: 43,
                  padding: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(border: Border.all()),
                  child: Column(children: [
                    Text(DateFormat('dd').format(dateTime),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 17)),
                    const SizedBox(height: 2),
                    Text(DateFormat('EEE').format(dateTime).toUpperCase(),
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                            color: Colors.grey.shade800)),
                  ]),
                ),
              ),
            ),
            Expanded(
                flex: 3,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: Image.asset("assets/Arrowdown.png"),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      DateFormat('K:mma').format(dateTime).toLowerCase(),
                      style: TextStyle(
                          color: timeStatus["late"] == "0 hrs & 0 mins"
                              ? Colors.green
                              : Colors.red),
                    ),
                  ],
                )),
            Expanded(
              flex: 3,
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    timeStatus['checkout'] != null
                        ? SizedBox(
                            height: 12,
                            width: 12,
                            child: Image.asset("assets/Arrowup.png"),
                          )
                        : Container(),
                    const SizedBox(width: 4),
                    Text(timeStatus['checkout'] == null
                        ? "- - - - "
                        : DateFormat('K:mma').format(dateTime2).toLowerCase()),
                  ]),
            ),
            Expanded(
              flex: 3,
              child: Center(
                  child: timeStatus["checkout"] == null
                      ? Text(
                          "${((DateTime.now().difference(dateTime).inSeconds) / 3600).toInt()} : ${(((DateTime.now().difference(dateTime).inSeconds) % 3600) / 60).toInt()}")
                      : Text(' ${timeStatus["workHours"]}')),
            ),
          ],
        ),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 75, right: 10),
          height: 1,
          color: Colors.grey.shade400,
        )
      ],
    );
  }
}

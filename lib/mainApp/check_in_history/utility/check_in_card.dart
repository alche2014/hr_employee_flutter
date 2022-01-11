import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

import '../../../colors.dart';

class CheckInCard extends StatelessWidget {
  final timeStatus;
  CheckInCard(this.timeStatus, {Key? key}) : super(key: key);
  late Timestamp timestamp = timeStatus['checkin'] as Timestamp;
  late DateTime dateTime = timestamp.toDate();

  late Timestamp timestamp2 = timeStatus['checkout'] as Timestamp;
  late DateTime dateTime2 = timestamp2.toDate();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Material(
        elevation: 3,
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        //========================================//
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 30),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            color: isdarkmode.value ? const Color(0xff34354A) : Colors.white,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(timeStatus['date'],
                          style: const TextStyle(
                              color: darkRed, fontWeight: FontWeight.bold)),
                      //--------------------------//
                      Container(
                          height: 40,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: lightGreen,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              timeStatus["late"] == "0 hrs & 0 mins"
                                  ? "On Time"
                                  : "Late",
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.black),
                            ),
                          )),
                    ]),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                          'Checkin: ${DateFormat('K:mm:ss').format(dateTime)}'),
                      timeStatus['checkout'] == null
                          ? const Text("Checkout: - -")
                          : Text(
                              'Checkout: ${DateFormat('K:mm:ss').format(dateTime2)}'),
                    ]),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: timeStatus["checkout"] == null
                    ? Text(
                        "Total Working Hours: ${((DateTime.now().difference(dateTime).inSeconds) / 3600).toInt()} : ${(((DateTime.now().difference(dateTime).inSeconds) % 3600) / 60).toInt()}")
                    : Text('Total Working Hours: ${timeStatus["workHours"]}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

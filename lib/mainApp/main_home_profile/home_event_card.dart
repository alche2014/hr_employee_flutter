// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unnecessary_string_interpolations

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';

// ignore: must_be_immutable
class HomeEventCard extends StatelessWidget {
  String date;
  String month;
  String head;
  String timeDate;
  String pic;
  HomeEventCard(this.date, this.month, this.head, this.timeDate, this.pic,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      child: Card(
        clipBehavior: Clip.antiAlias,
        color: MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.white
            : Color(0xff34354A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            // mainAxisSize: MainAxisSize.min,
            children: [
              Stack(
                children: [
                  Image(
                    image: AssetImage('assets/$pic.png'),
                    height: 150,
                    width: MediaQuery.of(context).size.width,
                    fit: BoxFit.cover,
                  ),
                ],
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Column(
                      children: [
                        Text(
                          '$date',
                          style: const TextStyle(fontSize: 35),
                        ),
                        Text('$month',
                            style: const TextStyle(
                                color: purpleDark,
                                fontSize: 17,
                                fontWeight: FontWeight.bold)), //color red
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$head',
                          style: const TextStyle(
                            fontSize: 16,
                            color: purpleDark,
                            fontWeight: FontWeight.bold,
                          ),
                        ), //color red
                        SizedBox(height: 10),
                        Text('$timeDate',
                            style: const TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

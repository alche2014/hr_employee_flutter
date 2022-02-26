// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, unnecessary_string_interpolations

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';

class BirthDayCard extends StatelessWidget {
  final String name;
  final String date;
  final String day;
  BirthDayCard(this.name, this.date, this.day, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: Material(
        elevation: 3,
        borderRadius: BorderRadius.circular(10),
        color: MediaQuery.of(context).platformBrightness == Brightness.light
            ? Colors.white
            : Color(0xff34354A),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.85,
          // height: 100,
          // margin: EdgeInsets.fromLTRB(20, 0, 0, 0),
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  ClipRRect(
                    borderRadius:
                        BorderRadius.circular(10.0), //add border radius here
                    child: Image.asset('assets/ben.jpg',
                        height: 85), //add image location here
                  ),
                  SizedBox(width: 20),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('$name',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      Row(children: [
                        Icon(
                          Icons.date_range,
                          size: 17,
                          color: Colors.grey,
                        ),
                        SizedBox(width: 5),
                        Text('$date',
                            style: const TextStyle(color: Colors.grey)),
                      ]),
                      Text('$day', style: const TextStyle(color: purpleDark)),
                    ],
                  ),
                ]),
                // SizedBox(width: 100),
                Align(
                  alignment: Alignment.center,
                  child: IconButton(
                      icon: Icon(
                        Icons.celebration_outlined,
                        size: 45,
                        color: purpleDark,
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: Text('Hamza Ali'),
                            content: Text('Happy Birthday'),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                child: Text('Okay'),
                              )
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

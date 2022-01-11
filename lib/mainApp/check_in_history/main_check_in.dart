// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/check_in_history/utility/check_in_card.dart';
import 'package:hr_app/mainApp/check_in_history/utility/drop_down.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:intl/intl.dart';

//-----------checkin History/Screen3---------------//

//-------------Final String defined---------------//

class MainCheckIn extends StatefulWidget {
  final uid;
  MainCheckIn({Key? key, this.uid}) : super(key: key);

  @override
  _MainCheckInState createState() => _MainCheckInState();
}

class _MainCheckInState extends State<MainCheckIn> {
  var totalemployee = 0;
  var ontime = 0;
  var late = 0;
  var absent = 0;
  String dropdownValue = 'January';
  @override
  void initState() {
    dropdownValue = DateFormat('MMMM').format(DateTime.now()).toString();
    totalAbsents();
    setState(() {});
    super.initState();
  }

  totalAbsents() {
    var date = DateTime.now();
    var lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
    var from =
        DateFormat("dd-MMMM-yyyy").parse("1-$dropdownValue-${date.year}");
    var to = dropdownValue == DateFormat("MMMM").format(date).toString()
        ? DateFormat("dd-MMMM-yyyy")
            .parse("${date.day}-$dropdownValue-${date.year}")
        : DateFormat("dd-MMMM-yyyy")
            .parse("${lastDayOfMonth.day}-$dropdownValue-${date.year}");

    int nbDays = to.difference(from).inDays + 1;
    print(nbDays);
    List abc = [];

    for (int i = 0; i < to.difference(from).inDays + 1; i++) {
      if (from.add(Duration(days: i)).weekday != 7 &&
          from.add(Duration(days: i)).weekday != 6) {
        abc.add(from.add(Duration(days: i)).weekday);
      }
    }

    List<int> days = List.generate(nbDays, (index) {
      int weekDay = DateTime(from.year, from.month, from.day + (index)).weekday;
      // print(weekDay);
      if (weekDay != DateTime.saturday && weekDay != DateTime.sunday) {
        return 1;
      }
      return 0;
    });
    absent = days.reduce((a, b) => a + b);
    totalemployee = absent;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Checkin History', true), //custom appbar
      body: Stack(
        children: [
          const BackgroundCircle(),
          Container(
            margin: EdgeInsets.only(top: 90),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      DropdownButton<String>(
                        value: dropdownValue,
                        icon: const Icon(Icons.arrow_drop_down_sharp),
                        iconSize: 40,
                        elevation: 20,
                        // style: const TextStyle(color: Colors.black),
                        onChanged: (String? newValue) {
                          setState(() {
                            dropdownValue = newValue!;
                            totalAbsents();
                          });
                        },
                        items: <String>[
                          'January',
                          'February',
                          'March ',
                          'April',
                          'May',
                          'June',
                          'July',
                          'August',
                          'September',
                          'October',
                          'November',
                          'December'
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value), //using a string value
                          );
                        }).toList(),
                        underline:
                            DropdownButtonHideUnderline(child: Container()),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection("attendance")
                          .where("empId", isEqualTo: "${widget.uid}")
                          .where("month", isEqualTo: dropdownValue)
                          .orderBy("checkin", descending: true)
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Text("ERROR"),
                          );
                        } else if (snapshot.hasData) {
                          return snapshot.data!.docs.isEmpty
                              ? Center(
                                  child: Container(
                                    height: MediaQuery.of(context).size.height -
                                        400,
                                    margin:
                                        EdgeInsets.only(bottom: 20, top: 50),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Icon(
                                          Icons.calendar_today,
                                          color: Color(0xFFBF2B38),
                                          size: 100,
                                        ),
                                        Text(
                                          "It's empty here.",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w600),
                                        ),
                                        Text(
                                          "No records found.",
                                          style: TextStyle(
                                              color: Colors.grey[400],
                                              fontSize: 12,
                                              fontFamily: "Roboto",
                                              fontWeight: FontWeight.w400),
                                        ),
                                      ],
                                    ),
                                  ),
                                )
                              : Column(children: [
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),
                                    child: Material(
                                      elevation: 3,
                                      borderRadius: BorderRadius.circular(10),
                                      color: isdarkmode.value
                                          ? Color(0xff34354A)
                                          : Colors.white,
                                      child: Container(
                                        height: 130,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 20, vertical: 10),
                                        child: StreamBuilder<QuerySnapshot>(
                                            stream: FirebaseFirestore.instance
                                                .collection("attendance")
                                                .where("empId",
                                                    isEqualTo: "${widget.uid}")
                                                .where("month",
                                                    isEqualTo: dropdownValue)
                                                .where("late",
                                                    isEqualTo: "0 hrs & 0 mins")
                                                .snapshots(),
                                            builder: (context,
                                                AsyncSnapshot<QuerySnapshot>
                                                    snapshotx) {
                                              var date = DateTime.now();

                                              var firstDayThisMonth = DateTime(
                                                  date.year,
                                                  date.month,
                                                  date.day);
                                              var firstDayNextMonth = DateTime(
                                                  firstDayThisMonth.year,
                                                  firstDayThisMonth.month + 1,
                                                  firstDayThisMonth.day);

                                              return Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  SizedBox(
                                                    height: 15,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: const [
                                                      Text(
                                                        'Absents',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Text('On Time',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text('Late',
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 10,
                                                  ),
                                                  Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Text(
                                                          snapshot.hasData
                                                              ? (absent -
                                                                      snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length)
                                                                  .toString()
                                                              : "0",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.blue,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          snapshotx.hasData
                                                              ? snapshotx.data!
                                                                  .docs.length
                                                                  .toString()
                                                              : "0",
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.green,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                      Text(
                                                          snapshotx.hasData
                                                              ? (snapshot
                                                                          .data!
                                                                          .docs
                                                                          .length -
                                                                      snapshotx
                                                                          .data!
                                                                          .docs
                                                                          .length)
                                                                  .toString()
                                                              : "0",
                                                          style: TextStyle(
                                                              color: Colors
                                                                  .red[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ],
                                                  ),
                                                  SizedBox(
                                                    height: 25,
                                                  ),
                                                  //----------------------------Bar----------------------------------//

                                                  FittedBox(
                                                    child: Container(
                                                      clipBehavior:
                                                          Clip.antiAlias,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
                                                        color: Colors.grey[300],
                                                      ),
                                                      height: 15,
                                                      width:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              1,
                                                      child: Row(
                                                        children: [
                                                          Container(
                                                            height: 15,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                (((absent - snapshot.data!.docs.length) /
                                                                        totalemployee *
                                                                        100) /
                                                                    100),
                                                            color: Colors.blue,
                                                          ),
                                                          Container(
                                                            height: 15,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                (((snapshotx.hasData
                                                                            ? snapshotx.data!.docs.length
                                                                            : 0) /
                                                                        totalemployee *
                                                                        100) /
                                                                    100),
                                                            color: Colors.green,
                                                          ),
                                                          Container(
                                                            height: 15,
                                                            width: MediaQuery.of(
                                                                        context)
                                                                    .size
                                                                    .width *
                                                                (((snapshotx.hasData
                                                                            ? (snapshot.data!.docs.length -
                                                                                snapshotx.data!.docs.length)
                                                                            : 0) /
                                                                        totalemployee *
                                                                        100) /
                                                                    100),
                                                            color: Colors.red,
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  )
                                                ],
                                              );
                                            }),
                                      ),
                                    ),
                                  ),
                                  ListView.builder(
                                      padding: EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics: NeverScrollableScrollPhysics(),
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return CheckInCard(
                                            snapshot.data!.docs[index]);
                                      })
                                ]);
                        } else {
                          return Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                      }),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

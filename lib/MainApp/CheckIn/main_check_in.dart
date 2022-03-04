// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

import 'check_in_card.dart';

//-----------checkin History/Screen3---------------//

//-------------Final String defined---------------//

class MainCheckIn extends StatefulWidget {
  const MainCheckIn({Key? key}) : super(key: key);

  @override
  _MainCheckInState createState() => _MainCheckInState();
}

class _MainCheckInState extends State<MainCheckIn> {
  var totalemployee = 0;
  var ontime = 0;
  var late = 0;
  var absent = 0;
  DateTime now = DateTime.now();
  String dropdownValue =
      '${DateFormat('MMMM yyyy').format(DateTime.now()).toString()}';
  @override
  void initState() {
    super.initState();
  }

  // totalAbsents() {
  //   var date = DateTime.now();
  //   var lastDayOfMonth = DateTime(date.year, date.month + 1, 0);
  //   var from =
  //       DateFormat("dd-MMMM-yyyy").parse("1-$dropdownValue-${date.year}");
  //   var to = dropdownValue == DateFormat("MMMM").format(date).toString()
  //       ? DateFormat("dd-MMMM-yyyy")
  //           .parse("${date.day}-$dropdownValue-${date.year}")
  //       : DateFormat("dd-MMMM-yyyy")
  //           .parse("${lastDayOfMonth.day}-$dropdownValue-${date.year}");

  //   int nbDays = to.difference(from).inDays + 1;
  //   List abc = [];

  //   for (int i = 0; i < to.difference(from).inDays + 1; i++) {
  //     if (from.add(Duration(days: i)).weekday != 7 &&
  //         from.add(Duration(days: i)).weekday != 6) {
  //       abc.add(from.add(Duration(days: i)).weekday);
  //     }
  //   }

  //   List<int> days = List.generate(nbDays, (index) {
  //     int weekDay = DateTime(from.year, from.month, from.day + (index)).weekday;
  //     if (weekDay != DateTime.saturday && weekDay != DateTime.sunday) {
  //       return 1;
  //     }
  //     return 0;
  //   });
  //   absent = days.reduce((a, b) => a + b);
  //   totalemployee = absent;

  //   setState(() {});
  // }

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
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: 120),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("attendance")
                        .where("empId", isEqualTo: uid)
                        .where("month", isEqualTo: dropdownValue)
                        .orderBy("checkin", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
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
                                  height:
                                      MediaQuery.of(context).size.height - 400,
                                  margin: EdgeInsets.only(bottom: 20, top: 50),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      Icon(
                                        Icons.calendar_today,
                                        color: purpleDark,
                                        size: 100,
                                      ),
                                      Text(
                                        "It's empty here.",
                                        style: const TextStyle(
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
                            : ListView.builder(
                                padding: EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CheckInCard(
                                    snapshot.data!.docs[index],
                                  );
                                });
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: ListTile(
                  leading: InkWell(
                      onTap: () {
                        setState(() {
                          now = DateTime(now.year, now.month - 1);
                          dropdownValue =
                              '${DateFormat('MMMM yyyy').format(now).toString()}';
                          ;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_back_ios_new, size: 18))),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.calendar_today_outlined,
                          color: purpleDark, size: 20),
                      Text(" ${DateFormat('MMMM yyyy').format(now)}",
                          style: TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: purpleDark)),
                    ],
                  ),
                  trailing: InkWell(
                      onTap: () {
                        if (now.year == DateTime.now().year &&
                            now.month == DateTime.now().month) {
                          Fluttertoast.showToast(msg: "No more records");
                        } else {
                          setState(() {
                            now = DateTime(now.year, now.month + 1);
                            dropdownValue =
                                '${DateFormat('MMMM yyyy').format(now).toString()}';
                            ;
                          });
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_forward_ios, size: 18))),
                ),
              ),
              Container(height: 1, color: Colors.grey.shade400),
              Container(
                height: 50,
                color: Colors.grey.shade100,
                child: Row(children: const [
                  Expanded(
                      flex: 2,
                      child: Text("Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Clock in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Clock out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Working Hrs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade)))
                ]),
              )
            ],
          ),
        ],
      ),
    );
  }
}

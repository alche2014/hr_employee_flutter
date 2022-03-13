// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

class TeamReports extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  const TeamReports({Key? key}) : super(key: key);

  @override
  _TeamReportsState createState() => _TeamReportsState();
}

class _TeamReportsState extends State<TeamReports> {
  DateTime now = DateTime.now();
  List<Map<String, dynamic>> empAtten = [];
  int presentEmp = 0;
  DateTime avg = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 00);
  List avgCheckin = [];
  List avgCheckout = [];
  int avgIn = 0;
  int avgOut = 0;

  @override
  void initState() {
    super.initState();
    loadTeam();
  }

  loadTeam() {
    FirebaseFirestore.instance
        .collection('employees')
        .where("reportingToId", isEqualTo: uid)
        .where("active", isEqualTo: true)
        .snapshots()
        .listen((onValue) async {
      setState(() {
        for (var doc in onValue.docs) {
          FirebaseFirestore.instance
              .collection("attendance")
              .where("empId", isEqualTo: doc.id.toString())
              .where("date",
                  isEqualTo: DateFormat('MMMM dd yyyy').format(now).toString())
              .snapshots()
              .listen((onValues) {
            setState(() {
              if (onValues.docs.isEmpty) {
                empAtten.add({
                  "id": doc.id.toString(),
                  "image": doc['imagePath'],
                  "name": doc['displayName'],
                  "desig": doc['designation'],
                  "absent": "true",
                  "late": "",
                  "checkin": null,
                  "checkout": null,
                });
              } else {
                presentEmp++;
                empAtten.add({
                  "id": doc.id.toString(),
                  "image": doc['imagePath'],
                  "name": doc['displayName'],
                  "desig": doc['designation'],
                  "absent": "false",
                  "late": onValues.docs.first['late'],
                  "checkin": onValues.docs.first['checkin'],
                  "checkout": onValues.docs.first['checkout'],
                });
                avgIn = avgIn +
                    int.parse(onValues.docs.first['checkin']
                        .toDate()
                        .difference(avg)
                        .inMinutes
                        .toString());
                if (onValues.docs.first['checkout'] != null) {
                  avgOut = avgOut +
                      int.parse(onValues.docs.first['checkout']
                          .toDate()
                          .difference(avg)
                          .inMinutes
                          .toString());
                  avgCheckout.add(onValues.docs.first['checkout']
                      .toDate()
                      .difference(avg)
                      .inMinutes);
                }
                avgCheckin.add(onValues.docs.first['checkin']
                    .toDate()
                    .difference(avg)
                    .inMinutes);
              }
            });
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Team Reports', false),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                margin: EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Expanded(
                        child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      margin: EdgeInsets.only(top: 10, bottom: 10, right: 8),
                      padding: EdgeInsets.all(15),
                      child: Text("Team Members",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade)),
                    )),
                    Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5))),
                            margin:
                                EdgeInsets.only(top: 10, bottom: 10, left: 8),
                            padding: EdgeInsets.all(11),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month_outlined,
                                    color: purpleDark),
                                Text(DateFormat('dd MMMM yyyy').format(now),
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontFamily: "Poppins",
                                        fontWeight: FontWeight.w500,
                                        color: greyShade)),
                              ],
                            )))
                  ],
                ),
              ),
              Container(
                height: 55,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 10),
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(35),
                      topRight: Radius.circular(35),
                    ),
                    color: Colors.white),
                child: Container(
                  margin: EdgeInsets.only(top: 30, left: 12, right: 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text("Avg Team Punctuality",
                          textAlign: TextAlign.start,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: purpleDark)),
                      Icon(Icons.download_for_offline_outlined,
                          color: purpleDark)
                    ],
                  ),
                ),
              ),
              Container(
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 20),
                    Container(
                        color: Colors.white,
                        child: Row(
                          children: [
                            Expanded(child: avgPresent("On Time", "20 Days")),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade300),
                            Expanded(child: avgPresent("Late", "10 Days")),
                            Container(
                                width: 1,
                                height: 40,
                                color: Colors.grey.shade300),
                            Expanded(child: avgPresent("Exceptions", "01 Days"))
                          ],
                        )),
                    Container(
                      margin: EdgeInsets.all(10),
                      height: 1,
                      color: Colors.grey.shade300,
                    ),
                    Container(
                      color: Colors.white,
                      child: empAtten.isEmpty
                          ? shimmer(context)
                          : ListView.builder(
                              padding: EdgeInsets.all(0),
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: empAtten.length,
                              itemBuilder: (context, index) {
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.transparent,
                                        radius: 20,
                                        child: ClipRRect(
                                          clipBehavior: Clip.antiAlias,
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: empAtten[index]["image"]
                                                      .toString() !=
                                                  null
                                              ? CachedNetworkImage(
                                                  imageUrl: empAtten[index]
                                                          ["image"]
                                                      .toString(),
                                                  fit: BoxFit.cover,
                                                  height: 40,
                                                  width: 40,
                                                  progressIndicatorBuilder: (context,
                                                          url,
                                                          downloadProgress) =>
                                                      CircularProgressIndicator(
                                                    value: downloadProgress
                                                        .progress,
                                                    color: Colors.white,
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                )
                                              : Image.asset(
                                                  'assets/placeholder.png',
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),
                                      title: Text(
                                        empAtten[index]["name"].toString(),
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      subtitle: Text(
                                        empAtten[index]["desig"].toString(),
                                        style: TextStyle(fontSize: 11),
                                      ),
                                      trailing: SizedBox(
                                          width: 150,
                                          child: empAtten[index]["absent"]
                                                      .toString() ==
                                                  "true"
                                              ? Container(
                                                  width: 70,
                                                  height: 30,
                                                  alignment: Alignment.center,
                                                  margin:
                                                      EdgeInsets.only(left: 80),
                                                  padding: EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color: Colors.red.shade600,
                                                  ),
                                                  child: Text(
                                                    "Absent",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                  ))
                                              : Row(
                                                  children: [
                                                    Expanded(
                                                        child: Row(children: [
                                                      SizedBox(
                                                        height: 15,
                                                        width: 15,
                                                        child: Image.asset(
                                                            "assets/Arrowdown.png"),
                                                      ),
                                                      Text(
                                                          DateFormat('K:mma')
                                                              .format(empAtten[
                                                                          index]
                                                                      [
                                                                      "checkin"]
                                                                  .toDate())
                                                              .toLowerCase(),
                                                          style: TextStyle(
                                                              color: empAtten[index]
                                                                              [
                                                                              "late"]
                                                                          .toString() ==
                                                                      "0 hrs & 0 mins"
                                                                  ? Colors.green
                                                                  : Colors.red))
                                                    ])),
                                                    SizedBox(width: 15),
                                                    Expanded(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            height: 15,
                                                            width: 15,
                                                            child: Image.asset(
                                                                "assets/Arrowup.png"),
                                                          ),
                                                          Text(
                                                              empAtten[index][
                                                                          'checkout'] ==
                                                                      null
                                                                  ? "  -- : --"
                                                                  : DateFormat(
                                                                          'K:mma')
                                                                      .format(empAtten[
                                                                              index]
                                                                          [
                                                                          'checkout']),
                                                              style: TextStyle(
                                                                  color: empAtten[index]
                                                                              [
                                                                              'checkout'] ==
                                                                          null
                                                                      ? Colors
                                                                          .black
                                                                      : Colors
                                                                          .green)),
                                                        ],
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(top: 10, bottom: 10),
                                      height: 1,
                                      color: Colors.grey.shade300,
                                    ),
                                  ],
                                );
                              }),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }

  Widget avgPresent(title, subtitle) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(title,
                style: TextStyle(
                    fontSize: 11,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: title == "Late"
                        ? Colors.red.shade500
                        : title == "On Time"
                            ? Colors.green
                            : purpleDark)),
            Text(subtitle,
                style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                    color: Colors.grey.shade500)),
          ],
        ));
  }
}

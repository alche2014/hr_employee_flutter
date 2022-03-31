// ignore_for_file: avoid_unnecessary_containers, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/MainApp/main_home_profile/teamInfo.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
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
  // DateTime avg = DateTime(
  //     DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 00);
  List avgCheckin = [];
  List avgCheckout = [];
  int avgIn = 0;
  String aaa = '10 : 25 : 01';

  int avgInEmp = 0;
  int avgOutEmp = 0;
  int workHours = 0;
  List avgCheckinEmp = [];
  List avgCheckoutEmp = [];
  int avgOut = 0;
  String date = "March 2022";
  final List<ChartData> chartData = <ChartData>[];
  final List<ChartData2> chartData2 = <ChartData2>[];
  DateTime avg = DateTime(
      DateTime.now().year, DateTime.now().month, DateTime.now().day, 00, 00);

  @override
  void initState() {
    super.initState();

    loadTeamAvg();
    loadTeamAtt();
  }

  loadTeamAvg() {
    for (int i = 1;
        i < DateTime(DateTime.now().year, DateTime.now().month + 1, 25).day + 1;
        i++) {
      FirebaseFirestore.instance
          .collection('attendance')
          .where("reportingToId", isEqualTo: uid)
          .where("date", isEqualTo: "March $i 2022")
          .snapshots()
          .listen((onValue) async {
        setState(() {
          if (onValue.docs.isNotEmpty) {
            avgIn = 0;
            avgCheckin.clear();
            for (var doc in onValue.docs) {
              avgIn = avgIn +
                  int.parse(doc['checkin']
                      .toDate()
                      .difference(DateTime(
                          DateTime.now().year, DateTime.now().month, i, 00, 00))
                      .inMinutes
                      .toString());
              avgCheckin.add(doc['checkin']
                  .toDate()
                  .difference(DateTime(
                      DateTime.now().year, DateTime.now().month, i, 00, 00))
                  .inMinutes);
              if (doc['checkout'] != null) {
                avgOut = avgOut +
                    int.parse(doc['checkout']
                        .toDate()
                        .difference(DateTime(DateTime.now().year,
                            DateTime.now().month, i, 00, 00))
                        .inMinutes
                        .toString());
                avgCheckout.add(doc['checkout']
                    .toDate()
                    .difference(DateTime(
                        DateTime.now().year, DateTime.now().month, i, 00, 00))
                    .inMinutes);
              }
            }

            chartData.add(ChartData(
                "March $i",
                DateTime(
                    now.year,
                    now.month,
                    i,
                    avgIn / avgCheckin.length ~/ 60,
                    (avgIn / avgCheckin.length % 60).toInt())));
            chartData2.add(ChartData2(
                "March $i",
                DateTime(
                    now.year,
                    now.month,
                    i,
                    avgOut / avgCheckout.length ~/ 60,
                    (avgOut / avgCheckout.length % 60).toInt())));
          }
        });
      });
    }
  }

  loadTeamAtt() {
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
              .where("month",
                  isEqualTo: DateFormat('MMMM yyyy').format(now).toString())
              .snapshots()
              .listen((onValues) {
            avgInEmp = 0;
            int out = 0;
            workHours = 0;
            if (onValues.docs.isNotEmpty) {
              for (var docs in onValues.docs) {
                setState(() {
                  avgInEmp = avgInEmp +
                      int.parse(docs['checkin']
                          .toDate()
                          .difference(DateTime.parse(DateFormat('MMMM dd yyyy')
                              .parse(docs["date"])
                              .toString()))
                          .inMinutes
                          .toString());
                  if (docs['checkout'] != null) {
                    workHours = workHours +
                        ((int.parse(docs['workHours'].split(":")[0].trim()) *
                                60) +
                            int.parse(docs['workHours'].split(":")[0].trim()));

                    out++;
                    avgOutEmp = avgOutEmp +
                        int.parse(docs['checkout']
                            .toDate()
                            .difference(DateTime.parse(
                                DateFormat('MMMM dd yyyy')
                                    .parse(docs["date"])
                                    .toString()))
                            .inMinutes
                            .toString());
                  }
                });
              }
              empAtten.add({
                "id": doc.id.toString(),
                "image": doc['imagePath'],
                "name": doc['displayName'],
                'workHours': workHours,
                "checkin":
                    "${(avgInEmp / onValues.docs.length ~/ 60).toInt()} : ${(avgInEmp / onValues.docs.length % 60).toInt()}",
                "checkout":
                    "${(avgOutEmp / out ~/ 60).toInt()} : ${(avgOutEmp / out % 60).toInt()}"
              });
            } else {
              setState(() {
                empAtten.add({
                  "id": doc.id.toString(),
                  "image": doc['imagePath'],
                  "name": doc['displayName'],
                  'workHours': workHours,
                  "checkin": " -- : -- ",
                  "checkout": " -- : -- "
                });
              });
            }
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
                    children: [
                      InkWell(
                        onTap: () {
                          print(chartData.toString());
                        },
                        child: Text("Avg Team Punctuality",
                            textAlign: TextAlign.start,
                            style: TextStyle(
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w500,
                                color: purpleDark)),
                      ),
                      Icon(Icons.download_for_offline_outlined,
                          color: purpleDark)
                    ],
                  ),
                ),
              ),
              Container(
                  color: Colors.white,
                  child: SfCartesianChart(
                      enableSideBySideSeriesPlacement: true,
                      primaryXAxis: CategoryAxis(),
                      primaryYAxis: DateTimeAxis(
                        labelFormat: '{value}',
                        dateFormat: DateFormat.jm(),
                      ),
                      enableAxisAnimation: true,
                      series: <ChartSeries>[
                        SplineSeries<ChartData2, String>(
                            dataSource: chartData2,
                            xValueMapper: (ChartData2 data, _) => data.x,
                            yValueMapper: (ChartData2 data, _) {
                              return data.y!.hour;
                            }),
                        SplineSeries<ChartData, String>(
                            dataSource: chartData,
                            xValueMapper: (ChartData data, _) => data.x,
                            yValueMapper: (ChartData data, _) {
                              return data.y!.hour;
                            })
                      ])),
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
                      margin: EdgeInsets.only(top: 30, left: 12, right: 12),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              print(chartData.toString());
                            },
                            child: Text("Work Hours & Timings",
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                    fontSize: 14,
                                    fontFamily: "Poppins",
                                    fontWeight: FontWeight.w500,
                                    color: purpleDark)),
                          ),
                          Icon(Icons.download_for_offline_outlined,
                              color: purpleDark)
                        ],
                      ),
                    ),
                    empAtten.isEmpty
                        ? shimmer(context)
                        : ListView.builder(
                            padding: EdgeInsets.all(0),
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            itemCount: empAtten.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.only(
                                    top: 2, left: 12, right: 12),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context, rootNavigator: true)
                                        .push(MaterialPageRoute(
                                            builder: (BuildContext context) =>
                                                TeamMemberInfo(
                                                    teamId:
                                                        "${empAtten[index]['id']}")));
                                  },
                                  child: Row(children: [
                                    Expanded(
                                      flex: 1,
                                      child: CircleAvatar(
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
                                                  height: 30,
                                                  width: 30,
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
                                    ),
                                    Expanded(
                                      flex: 9,
                                      child: Stack(
                                        children: [
                                          LinearPercentIndicator(
                                            linearStrokeCap:
                                                LinearStrokeCap.butt,

                                            fillColor: Colors.transparent,
                                            backgroundColor: Colors.transparent,
                                            lineHeight: 25,
                                            restartAnimation: true,
                                            animationDuration: 1000,
                                            animateFromLastPercent: false,
                                            // animation: true,
                                            percent: 1.0,
                                            progressColor: Colors.teal,
                                            // trailing: Text("9:00am"),
                                          ),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  left: 12, top: 6),
                                              alignment: Alignment.centerLeft,
                                              child: Text(
                                                empAtten[index]['checkin'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              )),
                                          Container(
                                              margin: EdgeInsets.only(
                                                  right: 12, top: 6),
                                              alignment: Alignment.centerRight,
                                              child: Text(
                                                empAtten[index]['checkout'],
                                                style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.black),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: Container(
                                          alignment: Alignment.center,
                                          child: Text(
                                            empAtten[index]['workHours'] == 0
                                                ? "-- : --"
                                                : "${(empAtten[index]['workHours'] ~/ 60).toInt()} : ${(empAtten[index]['workHours'] % 60).toInt()}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                fontSize: 10,
                                                color: Colors.black),
                                          )),
                                    ),
                                  ]),
                                ),
                              );
                            }),
                  ],
                ),
              ),
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

class ChartData {
  ChartData(this.x, this.y);
  final String x;
  final DateTime? y;
}

class ChartData2 {
  ChartData2(this.x, this.y);
  final String x;
  final DateTime? y;
}

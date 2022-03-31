import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/CheckIn/check_in_card.dart';
import 'package:intl/intl.dart';

class CheckinHistory extends StatefulWidget {
  final memId;
  const CheckinHistory({Key? key, this.memId}) : super(key: key);

  @override
  State<CheckinHistory> createState() => _CheckinHistoryState();
}

class _CheckinHistoryState extends State<CheckinHistory> {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("attendance")
                        .where("empId", isEqualTo: widget.memId)
                        .where("month", isEqualTo: dropdownValue)
                        .orderBy("checkin", descending: true)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return snapshot.data!.docs.isEmpty
                            ? Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height - 450,
                                  margin: const EdgeInsets.only(
                                      bottom: 20, top: 50),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.calendar_today,
                                        color: purpleDark,
                                        size: 100,
                                      ),
                                      const Text(
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
                            : ListView.builder(
                                padding: const EdgeInsets.all(0),
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: snapshot.data!.docs.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return CheckInCard(
                                    snapshot.data!.docs[index],
                                  );
                                });
                      } else {
                        return const Center(
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
                      const Icon(Icons.calendar_today_outlined,
                          color: purpleDark, size: 20),
                      Text(" ${DateFormat('MMMM yyyy').format(now)}",
                          style: const TextStyle(
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
                          padding: const EdgeInsets.all(10),
                          child:
                              const Icon(Icons.arrow_forward_ios, size: 18))),
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

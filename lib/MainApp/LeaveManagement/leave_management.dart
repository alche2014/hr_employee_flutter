import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/LeaveManagement/leave_history_card.dart';
import 'package:hr_app/MainApp/main_home_profile/apply_leaves.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';
// import 'package:percent_indicator/percent_indicator.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class LeaveManagement extends StatefulWidget {
  const LeaveManagement({Key? key}) : super(key: key);

  @override
  State<LeaveManagement> createState() => _LeaveManagementState();
}

class _LeaveManagementState extends State<LeaveManagement> {
  String button = "Approved";
  int total = 0;
  double used = 0;
  @override
  void initState() {
    super.initState();
    for (int index = 0; index < leaveData.length; index++) {
      if (leaveData[index]["active"] == true &&
          leaveData[index]["status"] == true &&
          int.parse(leaveData[index]["minExpDays"]) <
              (joiningDate == ""
                  ? 0
                  : DateTime.now()
                      .difference(DateFormat('dd-MMM-yyyy').parse(joiningDate))
                      .inDays)) {
        total = total + int.parse(leaveData[index]!['leaveQuota'].toString());
        used = used + leaveData[index]!['taken'].toDouble();
      }
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'My Leaves', false),
      body: joiningDate == ''
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    "assets/Leave-management.png",
                    height: 75,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'No Leaves assigned yet',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : leaveData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/Leave-management.png",
                        height: 75,
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'No Leaves assigned yet',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                  children: [
                    const SizedBox(height: 25),
                    CircularPercentIndicator(
                      animationDuration: 1000,
                      animateFromLastPercent: false,
                      animation: true,
                      radius: 90.0,
                      lineWidth: 10.0,
                      percent: used / total.toDouble(),
                      center: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: '$total / ',
                              style: const TextStyle(
                                  color: Color(0XFF5B5B5B), fontSize: 15),
                              children: <TextSpan>[
                                TextSpan(
                                    text: "${total - used.toInt()}",
                                    style: const TextStyle(
                                        fontSize: 30,
                                        color: purpleDark,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                          const Text("Leave Balance",
                              style: TextStyle(fontSize: 14)),
                        ],
                      ),
                      progressColor: purpleDark,
                    ),
                    const SizedBox(height: 5),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    const AddLeave()));
                      },
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        child: const Text("Click to Apply for Leaves",
                            style: TextStyle(fontSize: 15)),
                      ),
                    ),
                    Container(
                      margin: const EdgeInsets.all(15),
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(children: [
                              Row(
                                children: const [
                                  Icon(Icons.fiber_manual_record_rounded,
                                      color: greyShade, size: 12),
                                  Text("  Total Leaves",
                                      style: TextStyle(
                                          fontSize: 13, color: greyShade)),
                                ],
                              ),
                              Text("$total",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: purpleDark,
                                      fontWeight: FontWeight.bold)),
                            ]),
                            Column(children: [
                              Row(
                                children: const [
                                  Icon(Icons.fiber_manual_record_rounded,
                                      size: 12, color: purpleDark),
                                  Text("  Leave Used",
                                      style: TextStyle(
                                          fontSize: 13, color: purpleDark)),
                                ],
                              ),
                              Text("${used.toInt()}",
                                  style: const TextStyle(
                                      fontSize: 25,
                                      color: purpleDark,
                                      fontWeight: FontWeight.bold)),
                            ]),
                          ]),
                    ),
                    SizedBox(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      child: ListView.builder(
                          padding: const EdgeInsets.all(0),
                          itemCount: leaveData.length,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return leaveData[index]["active"] == true &&
                                    leaveData[index]["status"] == true &&
                                    int.parse(leaveData[index]["minExpDays"]) <
                                        (joiningDate == ""
                                            ? 0
                                            : DateTime.now()
                                                .difference(
                                                    DateFormat('dd-MMM-yyyy')
                                                        .parse(joiningDate))
                                                .inDays)
                                ? Container(
                                    margin: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        CircularPercentIndicator(
                                          animationDuration: 1000,
                                          animateFromLastPercent: true,
                                          animation: true,
                                          radius: 25.0,
                                          lineWidth: 3.0,
                                          percent: (leaveData[index]!['taken'])
                                                  .toDouble() /
                                              leaveData[index]!['leaveQuota']
                                                  .toDouble(),
                                          center: RichText(
                                            text: TextSpan(
                                              text:
                                                  '${leaveData[index]!['leaveQuota']}/',
                                              style: const TextStyle(
                                                  color: Color(0XFF5B5B5B),
                                                  fontSize: 11),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:
                                                        "${(leaveData[index]!['leaveQuota'] - leaveData[index]!['taken']).toInt()}",
                                                    style: const TextStyle(
                                                        fontSize: 14,
                                                        color: purpleDark,
                                                        fontWeight:
                                                            FontWeight.bold)),
                                              ],
                                            ),
                                          ),
                                          progressColor: purpleDark,
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                            leaveData[index]!["name"]
                                                .toString(),
                                            style:
                                                const TextStyle(fontSize: 13)),
                                      ],
                                    ),
                                  )
                                : Container();
                          }),
                    ),
                    Container(
                      height: 100,
                      width: MediaQuery.of(context).size.width,
                      margin: const EdgeInsets.only(top: 10),
                      decoration: const BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(35),
                            topRight: Radius.circular(35),
                          ),
                          color: Colors.white),
                      child: Container(
                        margin:
                            const EdgeInsets.only(top: 10, left: 12, right: 12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    button = "Approved";
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: button != "Approved"
                                        ? Colors.white
                                        : purpleDark,
                                  ),
                                  child: Text(
                                    'Approved',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: button != "Approved"
                                          ? Colors.grey.shade500
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              flex: 5,
                              child: InkWell(
                                onTap: () {
                                  setState(() {
                                    button = "Leave History";
                                  });
                                },
                                child: Container(
                                  height: 45,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15, vertical: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: button == "Approved"
                                        ? Colors.white
                                        : purpleDark,
                                  ),
                                  child: Text(
                                    'Leave History',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: button == "Approved"
                                          ? Colors.grey.shade500
                                          : Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    button == "Approved"
                        ? Container(
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('requests')
                                    .where("empId", isEqualTo: uid)
                                    .where("leaveStatus", isEqualTo: "approved")
                                    .orderBy("timeStamp", descending: true)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!.docs.isEmpty
                                        ? notFound()
                                        : ListView.builder(
                                            padding: const EdgeInsets.only(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return LeaveHistoryCard(
                                                  snapshot.data!.docs[index],
                                                  false);
                                            });
                                  } else if (!snapshot.hasData) {
                                    return notFound();
                                  } else if (!snapshot.hasError) {
                                    return const Text("Error");
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                          )
                        : Container(
                            color: Colors.white,
                            child: StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('requests')
                                    .where("empId", isEqualTo: uid)
                                    .orderBy("timeStamp", descending: true)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (snapshot.hasData) {
                                    return snapshot.data!.docs.isEmpty
                                        ? notFound()
                                        : ListView.builder(
                                            padding: const EdgeInsets.only(),
                                            itemCount:
                                                snapshot.data!.docs.length,
                                            shrinkWrap: true,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemBuilder: (context, index) {
                                              return LeaveHistoryCard(
                                                  snapshot.data!.docs[index],
                                                  false);
                                            });
                                  } else if (!snapshot.hasData) {
                                    return notFound();
                                  } else if (!snapshot.hasError) {
                                    return const Text("Error");
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                }),
                          ),
                  ],
                )),
      floatingActionButton: joiningDate == ''
          ? Container()
          : leaveData.isEmpty
              ? Container()
              : FloatingActionButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const AddLeave()));
                  },
                  child: const Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  backgroundColor: purpleDark,
                ),
    );
  }

  Widget notFound() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.5,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.history,
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
              "You haven't created any requests yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click create request to get started.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}

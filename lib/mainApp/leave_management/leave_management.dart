import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Notification/screen_notification.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/colors.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/experiences/main_experiences.dart';
import 'package:hr_app/mainApp/leave_management/leave_history/leave_history.dart';
import 'package:hr_app/mainApp/leave_management/utility/leave_card.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';

class LeaveManagement extends StatefulWidget {
  const LeaveManagement({Key? key}) : super(key: key);

  @override
  State<LeaveManagement> createState() => _LeaveManagementState();
}

class _LeaveManagementState extends State<LeaveManagement> {
  String? userId;
  List leaves = [];
  String joiningDate = '';
  @override
  void initState() {
    setState(() {});
    super.initState();
    load();
  }

  load() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;

    FirebaseFirestore.instance
        .collection('employees')
        .doc(firebaseUser.uid)
        .snapshots()
        .listen((onValue) {
      setState(() {});
      leaves = onValue.data()!['leaves'] ?? [];

      joiningDate = onValue.data()!['joiningDate'] ?? "";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          iconTheme: const IconThemeData(),
          toolbarTextStyle: TextStyle(
            color: isdarkmode.value == false ? Colors.grey : Colors.white,
          ),
          title: Text(
            'Leaves Management',
            style: TextStyle(
                color: isdarkmode.value == false
                    ? Colors.grey.shade800
                    : Colors.white),
          ),
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context, rootNavigator: true).push(
                    MaterialPageRoute(
                        builder: (context) => Notifications(uid: userId)));
              },
              icon: Icon(Icons.notifications,
                  color: isdarkmode.value == false
                      ? Colors.grey.shade800
                      : Colors.white),
            ),
          ],
        ),
        body: Stack(
          children: [
            const BackgroundCircle(),
            Padding(
              padding: const EdgeInsets.only(top: 70.0),
              child: joiningDate == ''
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
                  : leaves.isEmpty
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
                            Align(
                              alignment: Alignment.topRight,
                              child: Container(
                                margin: EdgeInsets.only(top: 15),
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => LeaveHistory(
                                                leaveData: leaves,
                                                joiningDate: joiningDate)));
                                  },
                                  child: Text(
                                    'Leave History',
                                    style:
                                        TextStyle(color: Colors.grey.shade800),
                                  ),
                                ),
                              ),
                            ),
                            ListView.builder(
                                padding: const EdgeInsets.only(),
                                itemCount: leaves.length,
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (BuildContext context, int index) {
                                  return leaves[index]["active"] == true &&
                                          leaves[index]["status"] == true &&
                                          int.parse(
                                                  leaves[index]["minExpDays"]) <
                                              (joiningDate == ""
                                                  ? 0
                                                  : DateTime.now()
                                                      .difference(DateFormat(
                                                              'dd-MMM-yyyy')
                                                          .parse(joiningDate))
                                                      .inDays)
                                      ? LeaveCard(
                                          text: leaves[index],
                                          allLeaves: leaves,
                                          joiningDate: joiningDate)
                                      : Container();
                                }),
                          ],
                        )),
            ),
          ],
        ));
  }
}

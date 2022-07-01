// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/CheckIn/checkin_history.dart';
import 'package:hr_app/MainApp/LeaveManagement/leave_history.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';

class TeamMemberInfo extends StatefulWidget {
  final teamId;
  const TeamMemberInfo({Key? key, this.teamId}) : super(key: key);

  @override
  State<TeamMemberInfo> createState() => _TeamMemberInfoState();
}

class _TeamMemberInfoState extends State<TeamMemberInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: StreamBuilder<DocumentSnapshot>(
          stream: FirebaseFirestore.instance
              .collection("employees")
              .doc(widget.teamId)
              .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return const Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                TeamUpperPortion(
                  data: snapshot.data!.data(),
                  title: "Profile",
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height - 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        widget.teamId == ""
                            ? ProfilePic()
                            : TeamProfile(data: snapshot.data!.data()),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 5, left: 20, right: 20),
                          child: Theme(
                            data: ThemeData(
                              dividerColor: Colors.transparent,
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            MyProfileEdit(
                                                teamId: widget.teamId)));
                              },
                              iconColor: purpleDark,
                              title: Row(children: [
                                SizedBox(
                                    height: 20,
                                    child: Image.asset("assets/profile.png")),
                                const Text(
                                  "  Personal Info",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: purpleDark,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: purpleDark, size: 18),
                            ),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          margin: const EdgeInsets.only(
                              top: 10, bottom: 5, left: 20, right: 20),
                          child: Theme(
                            data: ThemeData(
                              dividerColor: Colors.transparent,
                            ),
                            child: ListTile(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            Center(
                                                child: LeaveHistory(
                                                    value: "Requests",
                                                    memId: widget.teamId,
                                                    team: false))));
                              },
                              iconColor: purpleDark,
                              title: Row(children: [
                                SizedBox(
                                    height: 20,
                                    child: Image.asset("assets/personal.png")),
                                const Text(
                                  "  Requests",
                                  style: TextStyle(
                                      fontSize: 16.0,
                                      color: purpleDark,
                                      fontWeight: FontWeight.bold),
                                )
                              ]),
                              trailing: const Icon(Icons.arrow_forward_ios,
                                  color: purpleDark, size: 18),
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 20),
                          height: 1,
                          color: Colors.grey.shade400,
                        ),
                        Container(
                            height: MediaQuery.of(context).size.height / 1.44,
                            child: CheckinHistory(memId: widget.teamId)),
                        const SizedBox(height: 20)
                      ],
                    ),
                  ),
                ),
              ],
            );
          }),
    );
  }
}

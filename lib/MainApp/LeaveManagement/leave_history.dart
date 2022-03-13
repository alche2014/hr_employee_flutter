import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/LeaveManagement/leave_history_card.dart';
// import 'package:hr_app/MainApp/LeaveManagement/leave_history_card.dart';
import 'package:hr_app/MainApp/main_home_profile/apply_leaves.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/CheckIn/main_check_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class LeaveHistory extends StatefulWidget {
  final value;
  const LeaveHistory({Key? key, this.value}) : super(key: key);

  @override
  State<LeaveHistory> createState() => _LeaveHistoryState();
}

class _LeaveHistoryState extends State<LeaveHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("Leave Management",
            style: TextStyle(
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
      body: Padding(
        padding: const EdgeInsets.only(top: 90),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('requests')
                  .where("empId", isEqualTo: uid)
                  .orderBy("timeStamp", descending: true)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.hasData) {
                  return snapshot.data!.docs.isEmpty
                      ? notFound()
                      : ListView.builder(
                          padding: const EdgeInsets.only(),
                          itemCount: snapshot.data!.docs.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return LeaveHistoryCard(snapshot.data!.docs[index]);
                          });
                } else if (!snapshot.hasData) {
                  return notFound();
                } else if (!snapshot.hasError) {
                  return const Text("Error");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => const AddLeave()));
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

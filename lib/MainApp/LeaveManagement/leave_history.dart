import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/LeaveManagement/leave_history_card.dart';
import 'package:hr_app/MainApp/main_home_profile/apply_leaves.dart';
import 'package:hr_app/main.dart';

class LeaveHistory extends StatefulWidget {
  final value, memId, team;
  LeaveHistory({Key? key, this.value, this.memId, this.team}) : super(key: key);

  @override
  State<LeaveHistory> createState() => _LeaveHistoryState();
}

class _LeaveHistoryState extends State<LeaveHistory> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text(widget.value,
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
      body: Padding(
        padding: const EdgeInsets.only(top: 10),
        child: SingleChildScrollView(
          child: StreamBuilder<QuerySnapshot>(
              stream: widget.team == true
                  ? FirebaseFirestore.instance
                      .collection('requests')
                      .where("managerId", isEqualTo: uid)
                      .orderBy("timeStamp", descending: true)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection('requests')
                      .where("empId", isEqualTo: widget.memId)
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
                            return LeaveHistoryCard(
                                snapshot.data!.docs[index], widget.team);
                          });
                } else if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasError) {
                  return const Text("Error");
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              }),
        ),
      ),
      floatingActionButton: widget.value == "Requests"
          ? Container()
          : joiningDate == ''
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
              widget.value == "Requests"
                  ? "No requests found"
                  : "You haven't created any requests yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
          ],
        ),
      ),
    );
  }
}

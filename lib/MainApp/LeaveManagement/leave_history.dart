import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/LeaveManagement/leave_history_card.dart';
import 'package:hr_app/MainApp/main_home_profile/apply_leaves.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/CheckIn/main_check_in.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:intl/intl.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:instant/instant.dart';

import 'package:timezone/timezone.dart' as tz;

class LeaveHistory extends StatefulWidget {
  final value;
  const LeaveHistory({Key? key, this.value}) : super(key: key);

  @override
  State<LeaveHistory> createState() => _LeaveHistoryState();
}

class _LeaveHistoryState extends State<LeaveHistory> {
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
      setState(() {
        leaves = onValue.data()!['leaves'] ?? [];
        joiningDate = onValue.data()!['joiningDate'] ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: widget.value
          ? AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                color: isdarkmode.value ? Colors.white : Colors.grey.shade800,
                onPressed: () => Navigator.of(context).pop(),
              ),
              title: Text(
                "Leave Management",
                style: TextStyle(
                    fontFamily: 'Sodia',
                    color:
                        isdarkmode.value ? Colors.white : Colors.grey.shade800),
              ))
          : AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              centerTitle: false,
              automaticallyImplyLeading: false,
              title: Text(
                "Leave Management",
                style: TextStyle(
                    fontFamily: 'Sodia',
                    color:
                        isdarkmode.value ? Colors.white : Colors.grey.shade800),
              )),
      body: Stack(children: [
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CreateButton(createRequest: leaves, joiningDate: joiningDate),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where("empId", isEqualTo: userId)
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
                                      snapshot.data!.docs[index]);
                                });
                      } else if (!snapshot.hasData) {
                        return notFound();
                      } else if (!snapshot.hasError) {
                        return const Text("Error");
                      } else {
                        return const Center(child: CircularProgressIndicator());
                      }
                    }),
              ],
            ),
          ),
        ),
      ]),
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

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: FittedBox(
        child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MainCheckIn()));
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                  height: 20, child: Image.asset('assets/custom/filter.png')),
            )),
      ),
    );
  }
}

class CreateButton extends StatefulWidget {
  final createRequest, joiningDate;
  const CreateButton({this.createRequest, this.joiningDate, Key? key})
      : super(key: key);

  @override
  State<CreateButton> createState() => _CreateButtonState();
}

class _CreateButtonState extends State<CreateButton> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          OutlinedButton(
              child: const Text("+Create Request"),
              style: OutlinedButton.styleFrom(
                  primary: purpleDark,
                  backgroundColor: Colors.transparent,
                  onSurface: Colors.orangeAccent,
                  side: const BorderSide(color: purpleDark, width: 1)),
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (BuildContext context) => AddLeave(
                          leavesData: widget.createRequest,
                          joiningDate: widget.joiningDate,
                        ));
              }),
          const SizedBox(width: 150),
        ],
      ),
    );
  }
}

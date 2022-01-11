import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/check_in_history/main_check_in.dart';
import 'package:hr_app/mainApp/leave_management/utility/leave_history_card.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:hr_app/mainApp/main_home_profile/apply_leaves.dart';

import '../../../colors.dart';

String leave = 'Leave Type';
String approved = 'apd';
String no = 'no';

String body =
    'Hello guys we have discussed about post-corona vacation plan and our decision is to go to bali';

class LeaveHistory extends StatefulWidget {
  final leaveData, joiningDate;
  const LeaveHistory({this.leaveData, this.joiningDate, Key? key})
      : super(key: key);

  @override
  State<LeaveHistory> createState() => _LeaveHistoryState();
}

class _LeaveHistoryState extends State<LeaveHistory> {
  @override
  void initState() {
    super.initState();
    loadFirebaseUser();
  }

  String? userId;

  //getting current user data
  loadFirebaseUser() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;
    // print("Firebase User Id :: ${firebaseUser.uid}");
  }

  var leaveData;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Leaves History', true),
      body: Stack(children: [
        const BackgroundCircle(),
        Padding(
          padding: const EdgeInsets.only(top: 80),
          child: SingleChildScrollView(
            child: Column(
              children: [
                CreateButton(
                    createRequest: widget.leaveData,
                    joiningDate: widget.joiningDate),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('requests')
                        .where("empId", isEqualTo: userId)
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
              color: Color(0xFFBF2B38),
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
// LeaveHistoryCard(leave, '', no),
// LeaveHistoryCard(leave, body, approved),

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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          OutlinedButton(
            child: const Text("+Create Request"),
            style: OutlinedButton.styleFrom(
                primary: darkRed,
                backgroundColor: Colors.transparent,
                onSurface: Colors.orangeAccent,
                side: const BorderSide(color: darkRed, width: 1)),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AddLeave(
                        leavesData: widget.createRequest,
                        joiningDate: widget.joiningDate,
                      ));
            },
          ),
          const SizedBox(width: 150),
          // GestureDetector(
          //   onTap: () {
          //     Navigator.of(context)
          //         .push(MaterialPageRoute(builder: (context) => MainCheckIn()));
          //   },
          //   child: Container(
          //       child: Row(
          //     children: const [
          //       Text('Filter',
          //           style: TextStyle(
          //               color: Colors.grey, fontWeight: FontWeight.bold)),
          //       SizedBox(width: 2),
          //       Icon(Icons.tune),
          //     ],
          //   )),
          // ),
        ],
      ),
    );
  }
}

// Container(
//     height: 280,
//     child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: annCardData.length,
//         itemBuilder: (context, index) => annCardData[index]),
//   ),

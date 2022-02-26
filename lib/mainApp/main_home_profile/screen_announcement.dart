import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/appbar.dart';

import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class Announcements extends StatefulWidget {
  const Announcements({Key? key}) : super(key: key);

  @override
  _AnnouncementsState createState() => _AnnouncementsState();
}

class _AnnouncementsState extends State<Announcements> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;

  // late FirebaseUser firebaseUser;
  late String userId;
  late String value;

  late ScrollController con;
  late Stream? stream;

  @override
  void initState() {
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isNetwork = false;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isNetwork = true;
        });
      }
    });

    super.initState();
    con = ScrollController();
    con.addListener(() {
      if (con.offset >= con.position.maxScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else if (con.offset <= con.position.minScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
    stream = null;
    loadData();
    loadFirebaseUser();
  }

  loadData() async {
    stream = await load();
    setState(() {});
    loadFirebaseUser();
  }

  loadFirebaseUser() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    userId = firebaseUser!.uid;
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  Future<Stream> load() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    DocumentReference collectionReference = FirebaseFirestore.instance
        .collection('employees')
        .doc(firebaseUser!.uid);
    Stream<DocumentSnapshot> query = collectionReference.snapshots();
    return query;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildMyAppBar(context, 'Announcements', false),
        body: Stack(children: [
          stream == null
              ? _shimmer()
              : Container(
                  padding: Platform.isIOS
                      ? const EdgeInsets.only(bottom: 50, top: 110)
                      : const EdgeInsets.only(bottom: 15, top: 80),
                  child: StreamBuilder(
                      stream: stream,
                      builder: (context, AsyncSnapshot snapshot2) {
                        if (snapshot2.hasData) {
                          {
                            return StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection("announcements")
                                    .where("Employees", arrayContains: userId)
                                    .orderBy("timeStamp", descending: true)
                                    .snapshots(),
                                builder: (context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return const Center();
                                  } else if (snapshot.hasError) {
                                    return const Center(
                                      child: Text("ERROR"),
                                    );
                                  } else if (snapshot.hasData) {
                                    return SingleChildScrollView(
                                      child: ListView.builder(
                                        shrinkWrap: true,
                                        padding: EdgeInsets.all(0),
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        itemCount: snapshot.data!.docs.length,
                                        itemBuilder: (_, i) {
                                          return Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15,
                                                      vertical: 2),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 10),
                                                child: Container(
                                                  // margin: EdgeInsets.symmetric(vertical: 10),
                                                  width: MediaQuery.of(context)
                                                          .size
                                                          .width *
                                                      0.9,

                                                  padding:
                                                      const EdgeInsets.all(10),
                                                  decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              4),
                                                      border: Border.all(
                                                          width: 1,
                                                          color: Colors
                                                              .grey.shade300)),
                                                  //-----------------text in card-----------------
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: <Widget>[
                                                      Text(
                                                        snapshot.data!.docs[i][
                                                            'announcementTitle']!,
                                                        style: TextStyle(
                                                          color:
                                                              Colors.red[800],
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 17,
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Column(
                                                          children: [
                                                            Text(
                                                              snapshot.data!
                                                                      .docs[i][
                                                                  "announcementDes"]!,
                                                              maxLines: null,
                                                              style:
                                                                  const TextStyle(
                                                                      fontSize:
                                                                          14),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      const SizedBox(
                                                          height: 15),
                                                      Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            DateFormat.jm()
                                                                .add_yMd()
                                                                .format(DateTime
                                                                    .parse(snapshot
                                                                        .data!
                                                                        .docs[i]
                                                                            [
                                                                            "timeStamp"]!
                                                                        .toDate()
                                                                        .toString()))
                                                                .toString(),
                                                            // model.date.toString(),
                                                            style:
                                                                const TextStyle(
                                                              fontSize: 10,
                                                              color:
                                                                  Colors.grey,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ));
                                        },
                                      ),
                                    );
                                  } else {
                                    return const Center();
                                  }
                                });
                          }
                        } else {
                          return _shimmer();
                        }
                      }),
                ),
        ]));
  }

  Widget _shimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: const Color(0xFFE0E0E0),
        highlightColor: const Color(0xFFF5F5F5),
        child: Column(
          children: [0]
              .map((_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4.0)),
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.only(top: 30, left: 30),
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(50.0)),
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 4.0),
                                color: Colors.white,
                                width: double.infinity,
                                height: 8.0,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )))
              .toList(),
        ),
      ),
    );
  }
}

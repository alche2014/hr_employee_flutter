// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';

class PrivacyApp extends StatefulWidget {
  const PrivacyApp({Key? key}) : super(key: key);

  @override
  _PrivacyAppState createState() => _PrivacyAppState();
}

class _PrivacyAppState extends State<PrivacyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          const BackgroundCircle(),
          NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled) => [
                    buildMyNewAppBar(context, 'Privacy', true),
                  ],
              body: Builder(builder: (context) {
                return StreamBuilder<DocumentSnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('aboutPrivacy')
                        .doc("privacyAdmin")
                        .snapshots(),
                    builder:
                        (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (snapshot.hasError) {
                        return Center(child: Text("Error"));
                      } else if (snapshot.hasData) {
                        return SingleChildScrollView(
                          child: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Center(
                                          child: Image.asset(
                                              'assets/privacy.png',
                                              height: 108)),
                                      const SizedBox(height: 20),
                                      //-----------------------------------------------------------//
                                      Text(snapshot.data!["header1"] ?? "",
                                          style: TextStyle(
                                              fontSize: 18,
                                              color: Color(0XFFC53B4B))),
                                      SizedBox(height: 20),
                                      Text(snapshot.data!["body1"] ?? "",
                                          style: TextStyle(
                                              height: 1.5,
                                              fontSize: 13,
                                              color: Color(0XFF5B5B5B))),
                                      SizedBox(height: 40),
                                      //-----------------------------------------------------------//
                                      Text(snapshot.data!["header2"] ?? "",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0XFF535353))),
                                      SizedBox(height: 20),
                                      Text(snapshot.data!["body2"] ?? "",
                                          style: TextStyle(
                                              height: 1.5,
                                              fontSize: 13,
                                              color: Color(0XFF5B5B5B))),
                                      //-----------------------------------------------------------//
                                      SizedBox(height: 40),
                                      Text(snapshot.data!["header3"] ?? "",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Color(0XFF535353))),
                                      SizedBox(height: 20),
                                      Text(snapshot.data!["body3"] ?? "",
                                          style: TextStyle(
                                              height: 1.5,
                                              fontSize: 13,
                                              color: Color(0XFF5B5B5B))),
                                      SizedBox(height: 10),
                                      snapshot.data!["bullets"].length == 0
                                          ? Container()
                                          : ListView.builder(
                                              shrinkWrap: true,
                                              itemCount: snapshot
                                                  .data!["bullets"].length,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              padding: EdgeInsets.all(0),
                                              itemBuilder: (context, ind) {
                                                return Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    RichText(
                                                      text: TextSpan(
                                                        text: '• ',
                                                        style: TextStyle(
                                                            color: Color(
                                                                0XFF5B5B5B),
                                                            fontSize: 13),
                                                        children: <TextSpan>[
                                                          TextSpan(
                                                              text: snapshot
                                                                          .data![
                                                                      "bullets"]
                                                                  [ind],
                                                              style: TextStyle(
                                                                  fontSize:
                                                                      13)),
                                                        ],
                                                      ),
                                                    ),
                                                    SizedBox(height: 5),
                                                  ],
                                                );
                                              }),
                                    ]),
                              ),
                            ],
                          ),
                        );
                      } else {
                        return SpinKitCircle(
                          itemBuilder: (_, int index) {
                            return DecoratedBox(
                              decoration: BoxDecoration(
                                color:
                                    index.isEven ? Colors.black : Colors.white,
                              ),
                            );
                          },
                          size: 30.0,
                        );
                      }
                    });
              }))
        ]));
  }
}

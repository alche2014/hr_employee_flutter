import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/UserprofileScreen.dart/addKin.dart';

import 'package:hr_app/Constants/constants.dart';

class MainKin extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final kinInfo;
  const MainKin({this.kinInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var experience = kinInfo['kinInfo'];
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Next of KIN', false),
        body: SingleChildScrollView(
            child: Container(
                margin: const EdgeInsets.only(bottom: 50, top: 10),
                child: CardOne(kinInfo: experience, mainExp: kinInfo))),
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddKinInfo(
                          data: kinInfo,
                          uid: kinInfo['uid'],
                          editable: false)));
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            ),
            backgroundColor: kPrimaryColor));
  }
}

class CardOne extends StatefulWidget {
  final kinInfo;
  final mainExp;
  const CardOne({this.kinInfo, this.mainExp, Key? key}) : super(key: key);

  @override
  _CardOneState createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: widget.kinInfo == null
            ? notfound()
            : widget.kinInfo != null && widget.kinInfo.length == 0
                ? notfound()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        widget.kinInfo != null ? widget.kinInfo.length : 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddKinInfo(
                                      data: widget.kinInfo[index],
                                      uid: widget.mainExp["uid"],
                                      editable: true)));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.white, width: 0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Row(
                                children: [
                                  const Expanded(
                                    flex: 4,
                                    child: Text(
                                      "Name: ",
                                      style: TextStyle(
                                          color: Color(0XFF535353),
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 7,
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 10),
                                      child: Text(
                                        widget.kinInfo[index]['name'],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 3),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Relation: ",
                                            style: TextStyle(
                                                color: Color(0XFF535353),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 7,
                                            child: Container(
                                              margin: const EdgeInsets.only(
                                                  left: 10),
                                              child: Text(
                                                widget.kinInfo[index]
                                                        ['relation'] ??
                                                    "Relation",
                                                style: TextStyle(
                                                    color: widget.kinInfo[index]
                                                                ['relation'] ==
                                                            null
                                                        ? Colors.grey[500]
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15),
                                              ),
                                            ))
                                      ])),
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 3, bottom: 3),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Age: ",
                                            style: TextStyle(
                                                color: Color(0XFF535353),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                widget.kinInfo[index]['age'] ==
                                                        ""
                                                    ? "Age"
                                                    : widget.kinInfo[index]
                                                            ['age'] +
                                                        " Years",
                                                style: TextStyle(
                                                    color: widget.kinInfo[index]
                                                                ['age'] ==
                                                            ""
                                                        ? Colors.grey[500]
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15)),
                                          ),
                                        )
                                      ])),
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 3, bottom: 3),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Expanded(
                                          flex: 4,
                                          child: Text(
                                            "CNIC: ",
                                            style: TextStyle(
                                                color: Color(0XFF535353),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                widget.kinInfo[index]['cnic'] ==
                                                        ""
                                                    ? "CNIC"
                                                    : widget.kinInfo[index]
                                                        ['cnic'],
                                                style: TextStyle(
                                                    color: widget.kinInfo[index]
                                                                ['cnic'] ==
                                                            ""
                                                        ? Colors.grey[500]
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15)),
                                          ),
                                        )
                                      ])),
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 3, bottom: 3),
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        const Expanded(
                                          flex: 4,
                                          child: Text(
                                            "Percentage: ",
                                            style: TextStyle(
                                                color: Color(0XFF535353),
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 7,
                                          child: Container(
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                                widget.kinInfo[index]
                                                            ['percentage'] ==
                                                        ""
                                                    ? "Percentage"
                                                    : widget.kinInfo[index]
                                                            ['percentage'] +
                                                        "%",
                                                style: TextStyle(
                                                    color: widget.kinInfo[index]
                                                                [
                                                                'percentage'] ==
                                                            ""
                                                        ? Colors.grey[500]
                                                        : Colors.grey[700],
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15)),
                                          ),
                                        )
                                      ])),
                            ],
                          ),
                        ),
                      );
                    }),
      ),
    );
  }

  Widget notfound() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.4,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.person_outlined,
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
              "You haven't added any Information yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click Add New Button to get started.",
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

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/UserprofileScreen.dart/AddLicences.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/constants.dart';

class MainLicences extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final licenses;
  const MainLicences({this.licenses, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var license = licenses['licenses'];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'Licences & Certificates', false),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 50, top: 15),
              child: CardOne(
                licenses: license,
                mainExp: licenses,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddLicencesInfo(
                      data: licenses, uid: licenses['uid'], editable: false)));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}

class CardOne extends StatefulWidget {
  final licenses;
  final mainExp;
  const CardOne({this.licenses, this.mainExp, Key? key}) : super(key: key);

  @override
  _CardOneState createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: widget.licenses == null
          ? notfound()
          : widget.licenses != null && widget.licenses.length == 0
              ? notfound()
              : ListView.builder(
                  padding: EdgeInsets.zero,
                  // separatorBuilder: (context, index) => Divider(
                  // color: Colors.grey, )
                  itemCount:
                      widget.licenses != null ? widget.licenses.length : 0,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddLicencesInfo(
                                      data: widget.licenses[index],
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
                                  Text(
                                    widget.licenses == null
                                        ? "Name"
                                        : widget.licenses[index]['name'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 6, bottom: 6),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.licenses[index]['type'] ==
                                                      "null"
                                                  ? "Type"
                                                  : widget.licenses[index]
                                                      ['type'],
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                  color: widget.licenses[index]
                                                              ['type'] ==
                                                          "null"
                                                      ? Colors.grey[700]
                                                      : Colors.black),
                                            )
                                          ])),
                                  Container(
                                      margin: const EdgeInsets.only(bottom: 6),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: <Widget>[
                                            Text(
                                              widget.licenses[index]
                                                      ['startDate'] ??
                                                  "Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                  color: widget.licenses[index]
                                                              ['startDate'] ==
                                                          null
                                                      ? Colors.grey[700]
                                                      : Colors.black),
                                            ),
                                            const Text(' - '),
                                            Text(
                                              widget.licenses[index]
                                                      ['endDate'] ??
                                                  "Date",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15,
                                                  color: widget.licenses[index]
                                                              ['endDate'] ==
                                                          null
                                                      ? Colors.grey[700]
                                                      : Colors.black),
                                            )
                                          ]))
                                ])));
                  }),
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
              Icons.notes,
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
              "You haven't added any Licences yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click Add New Licences to get started.",
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

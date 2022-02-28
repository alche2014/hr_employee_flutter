import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';

import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';

import 'appbar.dart';
import 'add_experiences.dart';

class MainExperiences extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final workexp;
  const MainExperiences({this.workexp, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var experience = workexp['workExperience'];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'Experiences', true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 50, top: 15),
              child: Column(
                children: [
                  CardOne(
                    workexp: experience,
                    mainExp: workexp,
                  ),
                ],
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
                  builder: (context) => AddExperience(
                        data: workexp,
                        uid: workexp['uid'],
                        editable: false,
                      )));
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
  final workexp;
  final mainExp;
  const CardOne({this.workexp, this.mainExp, Key? key}) : super(key: key);

  @override
  _CardOneState createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: widget.workexp == null
            ? notfound()
            : widget.workexp != null && widget.workexp.length == 0
                ? notfound()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        widget.workexp != null ? widget.workexp.length : 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var dateto = widget.workexp[index]['expLastDate'] == "" ||
                              widget.workexp[index]['expLastDate'] == null
                          ? ""
                          : widget.workexp[index]['expLastDate'];
                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddExperience(
                                        data: widget.workexp[index],
                                        uid: widget.mainExp['uid'],
                                        editable: true,
                                      )));
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
                                widget.workexp == null
                                    ? "Title"
                                    : widget.workexp[index]['title'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                  margin:
                                      const EdgeInsets.only(top: 4, bottom: 3),
                                  child: Row(
                                    children: [
                                      Text(
                                        widget.workexp[index]['companyName'] ==
                                                ""
                                            ? "Company Name"
                                            : widget.workexp[index]
                                                ['companyName'],
                                        style: TextStyle(
                                            color: isdarkmode.value == false
                                                ? Colors.grey[700]
                                                : Colors.grey[500],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                      const Text(" - "),
                                      Text(
                                        widget.workexp[index]['empStatus'] ??
                                            "Status",
                                        style: TextStyle(
                                            color: isdarkmode.value == false
                                                ? Colors.grey[700]
                                                : Colors.grey[500],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                    ],
                                  )),
                              Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  dateto == ""
                                      ? widget.workexp[index]['expstartDate']
                                      : widget.workexp[index]['expstartDate'] ==
                                              null
                                          ? "Date"
                                          : widget.workexp[index]
                                                  ['expstartDate'] +
                                              " - " +
                                              dateto,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
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
              Icons.work_outline_outlined,
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
              "You haven't added any experience yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click Add New Experience to get started.",
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

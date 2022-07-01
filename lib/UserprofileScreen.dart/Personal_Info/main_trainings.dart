import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/UserprofileScreen.dart/AddTrainings.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/constants.dart';

class MainTrainings extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final trainings;
  const MainTrainings({this.trainings, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var training = trainings['trainings'];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'Trainings', false),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 50, top: 15),
              child: CardOne(
                trainings: training,
                mainExp: trainings,
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
                  builder: (context) => AddTrainings(
                      data: trainings,
                      uid: trainings['uid'],
                      editable: false)));
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
  final trainings;
  final mainExp;
  const CardOne({this.trainings, this.mainExp, Key? key}) : super(key: key);

  @override
  _CardOneState createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: widget.trainings == null
            ? notfound()
            : widget.trainings != null && widget.trainings.length == 0
                ? notfound()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        widget.trainings != null ? widget.trainings.length : 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddTrainings(
                                        data: widget.trainings[index],
                                        uid: widget.mainExp["uid"],
                                        editable: true)));
                          },
                          child: Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(
                                      color: Colors.white, width: 0)),
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.trainings == null
                                          ? "Name"
                                          : widget.trainings[index]['name'],
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
                                                widget.trainings[index]
                                                            ['type'] ==
                                                        "null"
                                                    ? "Type"
                                                    : widget.trainings[index]
                                                        ['type'],
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color:
                                                        widget.trainings[index]
                                                                    ['type'] ==
                                                                "null"
                                                            ? Colors.grey[700]
                                                            : Colors.black),
                                              )
                                            ])),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 3, bottom: 6),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              Text(
                                                widget.trainings[index]
                                                        ['expstartDate'] ??
                                                    "Date",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: widget.trainings[
                                                                    index][
                                                                'expstartDate'] ==
                                                            null
                                                        ? Colors.grey[700]
                                                        : Colors.black),
                                              ),
                                              const Text(' - '),
                                              Text(
                                                widget.trainings[index]
                                                        ['expLastDate'] ??
                                                    "Date",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 15,
                                                    color: widget.trainings[
                                                                    index][
                                                                'expLastDate'] ==
                                                            null
                                                        ? Colors.grey[700]
                                                        : Colors.black),
                                              )
                                            ]))
                                  ])));
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
              "You haven't added any Trainings yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click Add New Trainings to get started.",
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

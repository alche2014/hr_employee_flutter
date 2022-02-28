import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/UserprofileScreen.dart/AddDependent.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/constants.dart';

class MainDependents extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final dependentsInfo;
  const MainDependents({this.dependentsInfo, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var experience = dependentsInfo['dependentsInfo'];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'Dependents', false),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.only(bottom: 50, top: 15),
              child: CardOne(
                dependentsInfo: experience,
                mainExp: dependentsInfo,
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
                  builder: (context) => AddDependentsInfo(
                      data: dependentsInfo,
                      uid: dependentsInfo['uid'],
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
  final dependentsInfo;
  final mainExp;
  const CardOne({this.dependentsInfo, this.mainExp, Key? key})
      : super(key: key);

  @override
  _CardOneState createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: widget.dependentsInfo == null
            ? notfound()
            : widget.dependentsInfo != null && widget.dependentsInfo.length == 0
                ? notfound()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount: widget.dependentsInfo != null
                        ? widget.dependentsInfo.length
                        : 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AddDependentsInfo(
                                        data: widget.dependentsInfo[index],
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
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              widget.dependentsInfo[index]
                                                          ['name'] ==
                                                      ""
                                                  ? "Name"
                                                  : widget.dependentsInfo[index]
                                                      ['name'],
                                              style: TextStyle(
                                                  color: widget.dependentsInfo[
                                                              index]['name'] ==
                                                          ""
                                                      ? Colors.grey[500]
                                                      : Colors.grey[700]),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    Container(
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 3),
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
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 7,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                  child: Text(
                                                    widget.dependentsInfo[index]
                                                                ['relation'] ==
                                                            null
                                                        ? "Relation"
                                                        : widget.dependentsInfo[
                                                            index]['relation'],
                                                    style: TextStyle(
                                                        color: widget.dependentsInfo[
                                                                        index][
                                                                    'relation'] ==
                                                                null
                                                            ? Colors.grey[500]
                                                            : Colors.grey[700]),
                                                  ),
                                                ),
                                              )
                                            ])),
                                    Container(
                                        margin: const EdgeInsets.only(
                                          top: 3,
                                          bottom: 3,
                                        ),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: <Widget>[
                                              const Expanded(
                                                flex: 4,
                                                child: Text(
                                                  "DOB: ",
                                                  style: TextStyle(
                                                      color: Color(0XFF535353),
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      fontSize: 14),
                                                ),
                                              ),
                                              Expanded(
                                                flex: 7,
                                                child: Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                  child: Text(
                                                    widget.dependentsInfo[index]
                                                                ['dob'] ==
                                                            ""
                                                        ? "DOB"
                                                        : widget.dependentsInfo[
                                                            index]['dob'],
                                                    style: TextStyle(
                                                        color: widget.dependentsInfo[
                                                                        index]
                                                                    ['dob'] ==
                                                                ""
                                                            ? Colors.grey[500]
                                                            : Colors.grey[700]),
                                                  ),
                                                ),
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
              "You haven't added any Dependent yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click Add New Dependent to get started.",
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

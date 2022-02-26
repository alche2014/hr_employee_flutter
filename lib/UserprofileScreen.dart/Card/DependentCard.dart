// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/UserprofileScreen.dart/Personal_Info/main_dependent.dart';

import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';

class DependentsCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const DependentsCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var courseDocument = data;
    var dependentsInfo = courseDocument['dependentsInfo'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Dependents',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                )),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainDependents(
                                dependentsInfo: data,
                              )));
                },
                child: Container(
                  width: 50,
                  height: 30,
                  alignment: Alignment.centerRight,
                  child: const Text('Edit',
                      style: TextStyle(
                          color: kPrimaryColor,
                          fontSize: 13,
                          fontWeight: FontWeight.w400)),
                ),
              ),
            ),
          ]),
          dependentsInfo == null
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 5),
                    child: Text(
                      "No Dependent added yet",
                      style: TextStyle(
                          color: isdarkmode.value == false
                              ? Colors.grey[700]
                              : Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                )
              : dependentsInfo != null && dependentsInfo.length == 0
                  ? Center(
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 15, top: 5),
                      child: Text(
                        "No Dependent added yet",
                        style: TextStyle(
                            color: isdarkmode.value == false
                                ? Colors.grey[700]
                                : Colors.grey[500],
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    ))
                  : Container(
                      padding:
                          const EdgeInsets.only(left: 7, right: 7, top: 10),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: dependentsInfo.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 3, bottom: 3, left: 5),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
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
                                              dependentsInfo[index]['name'] ==
                                                      ""
                                                  ? "Name"
                                                  : dependentsInfo[index]
                                                      ['name'],
                                              style: TextStyle(
                                                  color: dependentsInfo[index]
                                                              ['name'] ==
                                                          ""
                                                      ? Colors.grey[500]
                                                      : Colors.grey[700],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 3, bottom: 3, left: 5),
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
                                            margin:
                                                const EdgeInsets.only(left: 10),
                                            child: Text(
                                              dependentsInfo[index]
                                                      ['relation'] ??
                                                  "Relation",
                                              style: TextStyle(
                                                  color: dependentsInfo[index]
                                                              ['relation'] ==
                                                          null
                                                      ? Colors.grey[500]
                                                      : Colors.grey[700],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 6, bottom: 16, left: 5),
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
                                                    fontWeight: FontWeight.w500,
                                                    fontSize: 14),
                                              ),
                                            ),
                                            Expanded(
                                                flex: 7,
                                                child: Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            left: 10),
                                                    child: Text(
                                                        dependentsInfo[index]
                                                                    ['dob'] ==
                                                                ""
                                                            ? "DOB"
                                                            : dependentsInfo[index]
                                                                ['dob'],
                                                        style: TextStyle(
                                                            color: dependentsInfo[index]['dob'] ==
                                                                    ""
                                                                ? Colors
                                                                    .grey[500]
                                                                : Colors
                                                                    .grey[700],
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            fontSize: 15))))
                                          ]))
                                ]);
                          }),
                    ),
        ],
      ),
    );
  }
}

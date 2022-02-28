// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/UserprofileScreen.dart/Personal_Info/main_kin.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';

class KinCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const KinCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var courseDocument = data;
    var kinInfo = courseDocument['kinInfo'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Next of KIN',
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
                          builder: (context) => MainKin(
                                kinInfo: data,
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
          kinInfo == null
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10, top: 5),
                    child: Text(
                      "No Data added yet",
                      style: TextStyle(
                          color: isdarkmode.value == false
                              ? Colors.grey[700]
                              : Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                )
              : kinInfo != null && kinInfo.length == 0
                  ? Center(
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 15, top: 5),
                      child: Text(
                        "No Data added yet",
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
                          const EdgeInsets.only(top: 10, left: 7, right: 7),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: kinInfo.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
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
                                              kinInfo == null
                                                  ? "Name"
                                                  : kinInfo[index]['name'],
                                              style: TextStyle(
                                                  color: kinInfo[index]
                                                              ['name'] ==
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
                                              kinInfo[index]['relation'] ??
                                                  "Relation",
                                              style: TextStyle(
                                                  color: kinInfo[index]
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
                                        top: 3, bottom: 3, left: 5),
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
                                              kinInfo[index]['age'] == ""
                                                  ? "Age"
                                                  : kinInfo[index]['age'] +
                                                      " Years",
                                              style: TextStyle(
                                                  color: kinInfo[index]
                                                              ['age'] ==
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
                                              kinInfo[index]['cnic'] == ""
                                                  ? "CNIC"
                                                  : kinInfo[index]['cnic'],
                                              style: TextStyle(
                                                  color: kinInfo[index]
                                                              ['cnic'] ==
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
                                        top: 3, bottom: 5, left: 5),
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
                                              kinInfo[index]['percentage'] == ""
                                                  ? "Percentage"
                                                  : kinInfo[index]
                                                          ['percentage'] +
                                                      "%",
                                              style: TextStyle(
                                                  color: kinInfo[index]
                                                              ['percentage'] ==
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
                                ],
                              ),
                            );
                          }),
                    ),
        ],
      ),
    );
  }
}

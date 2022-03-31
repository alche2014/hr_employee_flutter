// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/UserprofileScreen.dart/main_education.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';

class EducationCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data, teamEdit;
  const EducationCard({Key? key, this.data, this.teamEdit}) : super(key: key);

  @override
  _EducationCardState createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  @override
  Widget build(BuildContext context) {
    var courseDocument = widget.data;
    var edu = courseDocument['education'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Education',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: purpleDark)),
            Expanded(
              flex: 2,
              child: widget.teamEdit
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainEducationCard(
                                      mainEdu: widget.data,
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
                    )
                  : const Text(""),
            ),
          ]),
          education(widget.data),
        ],
      ),
    );
  }

  //this widget contains employees educational information
  Widget education(snapshot) {
    var courseDocument = snapshot;
    var edu = snapshot['education'];
    return Container(
        width: MediaQuery.of(context).size.width,
        child: Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: edu == null
                  ? Center(
                      child: Text(
                        "No Education added yet",
                        style: TextStyle(
                            color: isdarkmode.value == false
                                ? Colors.grey[700]
                                : Colors.grey[500],
                            fontWeight: FontWeight.w400,
                            fontSize: 13),
                      ),
                    )
                  : edu != null && edu.length == 0
                      ? Center(
                          child: Text(
                          "No Education added yet",
                          style: TextStyle(
                              color: isdarkmode.value == false
                                  ? Colors.grey[700]
                                  : Colors.grey[500],
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ))
                      : Container(
                          padding:
                              const EdgeInsets.only(left: 2, right: 7, top: 10),
                          child: ListView.builder(
                              padding: EdgeInsets.zero,
                              itemCount: edu != null || edu.length <= 2
                                  ? edu.length
                                  : 3,
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
                                      child: Text(
                                        edu == null
                                            ? "School"
                                            : edu[index]['school'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 4, bottom: 3, left: 5),
                                      child: Text(
                                        edu == null
                                            ? "Degree"
                                            : edu[index]['degree'],
                                        style: TextStyle(
                                            color: isdarkmode.value == false
                                                ? Colors.grey[700]
                                                : Colors.grey[500],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15),
                                      ),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(
                                          bottom: 6, top: 3, left: 5),
                                      child: Container(
                                        // margin:
                                        //     EdgeInsets.only(left: 4),
                                        child: Text(
                                          edu == null
                                              ? "Years "
                                              : (edu[index]['expstartDate'] +
                                                  " - " +
                                                  edu[index]['expLastDate']),
                                          style: TextStyle(
                                              color: isdarkmode.value == false
                                                  ? Colors.grey[700]
                                                  : Colors.grey[500],
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                        ),
            ),
          ),
        ]));
  }
}

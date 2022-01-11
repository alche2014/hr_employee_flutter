// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/education/main_education.dart';

import '../../../colors.dart';

class EducationCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const EducationCard({Key? key, this.data}) : super(key: key);

  @override
  _EducationCardState createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  @override
  Widget build(BuildContext context) {
    var courseDocument = widget.data;
    var edu = courseDocument['education'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
              color: isdarkmode.value == false
                  ? Colors.grey.withOpacity(0.2)
                  : Colors.white,
              width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                const Text('Education',
                    style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        fontSize: 16,
                        color: darkRed)),
                Expanded(
                  flex: 2,
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => MainEducationCard(
                                    mainEdu: widget.data,
                                  )));
                    },
                    child: Container(
                      width: 60,
                      height: 40,
                      padding:
                          const EdgeInsets.only(top: 5, right: 10, bottom: 5),
                      alignment: Alignment.topRight,
                      child: Icon(Icons.edit_outlined,
                          color: isdarkmode.value == false
                              ? Color(0xff34354A)
                              : Colors.grey[500]),
                    ),
                  ),
                ),
              ]),
              education(widget.data),
            ],
          ),
        ),
      ),
    );
  }

  //this widget contains employees educational information
  Widget education(snapshot) {
    var courseDocument = snapshot;
    var edu = snapshot['education'];
    return Container(
        padding: const EdgeInsets.only(left: 8, right: 8),
        width: MediaQuery.of(context).size.width,
        // color: Colors.yellow,
        margin: const EdgeInsets.only(top: 10),
        child: Column(children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.only(bottom: 15),
            child: Container(
              margin: const EdgeInsets.only(right: 10),
              child: edu == null
                  ? Center(
                      child: Text(
                        "No education added yet",
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
                          "No education added yet",
                          style: TextStyle(
                              color: isdarkmode.value == false
                                  ? Colors.grey[700]
                                  : Colors.grey[500],
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          // separatorBuilder: (context, index) => Divider(
                          // color: Colors.grey, ),
                          itemCount:
                              edu != null || edu.length <= 2 ? edu.length : 3,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    edu == null
                                        ? "School"
                                        : edu[index]['school'],
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
                                        // Expanded(
                                        //   flex: 1,
                                        //   child: Icon(
                                        //     Icons.title,
                                        //     color: Color(0xFFBF2B38),
                                        //     size: 18,
                                        //   ),
                                        // ),

                                        Text(
                                          edu == null
                                              ? "Degree"
                                              : edu[index]['degree'],
                                          style: TextStyle(
                                              color: isdarkmode.value == false
                                                  ? Colors.grey[700]
                                                  : Colors.grey[500],
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        )
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(bottom: 6),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: <Widget>[
                                        Expanded(
                                          flex: 8,
                                          child: Container(
                                            // margin:
                                            //     EdgeInsets.only(left: 4),
                                            child: Text(
                                              edu == null
                                                  ? "Years "
                                                  : (edu[index]
                                                          ['expstartDate'] +
                                                      " - " +
                                                      edu[index]
                                                          ['expLastDate']),
                                              style: TextStyle(
                                                  color:
                                                      isdarkmode.value == false
                                                          ? Colors.grey[700]
                                                          : Colors.grey[500],
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
          ),
        ]));
  }
}

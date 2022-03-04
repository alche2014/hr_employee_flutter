// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/UserprofileScreen.dart/Personal_Info/main_trainings.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';

class TrainingsCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const TrainingsCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var courseDocument = data;
    var trainings = courseDocument['trainings'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Trainings',
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
                          builder: (context) => MainTrainings(
                                trainings: data,
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
          trainings == null
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 5),
                    child: Text(
                      "Not added yet",
                      style: TextStyle(
                          color: isdarkmode.value == false
                              ? Colors.grey[700]
                              : Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                )
              : trainings != null && trainings.length == 0
                  ? Center(
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 15, top: 5),
                      child: Text(
                        "Not added yet",
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
                          const EdgeInsets.only(left: 2, right: 7, top: 10),
                      child: ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: trainings.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 3, bottom: 3, left: 5),
                                    child: Text(
                                      trainings == null
                                          ? "Name"
                                          : trainings[index]['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 3, bottom: 3, left: 5),
                                    child: Text(
                                      trainings[index]['type'] == "null"
                                          ? "Type"
                                          : trainings[index]['type'],
                                      style: TextStyle(
                                          color:
                                              trainings[index]['type'] == "null"
                                                  ? Colors.grey[500]
                                                  : Colors.grey[700],
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15),
                                    ),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 3, bottom: 6, left: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                              trainings[index]['startDate'] ==
                                                      null
                                                  ? "Date"
                                                  : trainings[index][index]
                                                      ['startDate'],
                                              style: TextStyle(
                                                  color: trainings[index]
                                                              ['date'] ==
                                                          null
                                                      ? Colors.grey[500]
                                                      : Colors.grey[700],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15)),
                                          const Text(' - '),
                                          Text(
                                              trainings[index]['endDate'] ==
                                                      null
                                                  ? "Date"
                                                  : trainings[index]['endDate'],
                                              style: TextStyle(
                                                  color: trainings[index]
                                                              ['date'] ==
                                                          null
                                                      ? Colors.grey[500]
                                                      : Colors.grey[700],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15))
                                        ],
                                      ))
                                ]));
                          }),
                    ),
        ],
      ),
    );
  }
}

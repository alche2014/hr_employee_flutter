// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/MainApp/CheckIn/team_reports.dart';
import 'package:hr_app/UserprofileScreen.dart/main_experience.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';

class ExperienceCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data, teamEdit;
  const ExperienceCard({Key? key, this.data, this.teamEdit}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var courseDocument = data;
    var workexp = courseDocument['workExperience'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Experience',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: purpleDark)),
            Expanded(
              flex: 2,
              child: teamEdit
                  ? InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    MainExperiences(workexp: data)));
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
                  : Text(""),
            ),
          ]),
          workexp == null
              ? Center(
                  child: Text(
                    "No Experience added yet",
                    style: TextStyle(
                        color: isdarkmode.value == false
                            ? Colors.grey[700]
                            : Colors.grey[500],
                        fontWeight: FontWeight.w400,
                        fontSize: 13),
                  ),
                )
              : workexp != null && workexp.length == 0
                  ? Center(
                      child: Text(
                      "No Experience added yet",
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
                          itemCount: workexp.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var dateto = workexp[index]['expLastDate'] == "" ||
                                    workexp[index]['expLastDate'] == null
                                ? ""
                                : workexp[index]['expLastDate'];

                            return Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  margin:
                                      const EdgeInsets.only(left: 5, bottom: 3),
                                  child: Text(
                                    workexp == null
                                        ? "Title"
                                        : workexp[index]['title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                    margin: const EdgeInsets.only(
                                        top: 4, bottom: 3, left: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          workexp[index]['companyName'] == ""
                                              ? "Company Name"
                                              : workexp[index]['companyName'],
                                          style: TextStyle(
                                              color: isdarkmode.value == false
                                                  ? Colors.grey[700]
                                                  : Colors.grey[500],
                                              fontWeight: FontWeight.w400,
                                              fontSize: 15),
                                        ),
                                        const Text(" - "),
                                        Text(
                                          workexp[index]['empStatus'] == null
                                              ? "Status"
                                              : workexp[index]['empStatus'],
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
                                  margin: const EdgeInsets.only(
                                      top: 3, bottom: 6, left: 5),
                                  child: Text(
                                    dateto == ""
                                        ? workexp[index]['expstartDate']
                                        : workexp[index]['expstartDate'] == null
                                            ? "Date"
                                            : workexp[index]['expstartDate'] +
                                                " - " +
                                                dateto,
                                    style: TextStyle(
                                        color: isdarkmode.value == false
                                            ? Colors.grey[700]
                                            : Colors.grey[500],
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            );
                          }),
                    ),
        ],
      ),
    );
  }
}

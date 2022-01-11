// ignore_for_file: file_names

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/experiences/main_experiences.dart';

import '../../../colors.dart';

class ExperienceCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const ExperienceCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var courseDocument = data;
    var workexp = courseDocument['workExperience'];
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
                const Text('Experience',
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
                              builder: (context) => MainExperiences(
                                    workexp: data,
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
              workexp == null
                  ? Center(
                      child: Text(
                        "No experience added yet",
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
                          "No experience added yet",
                          style: TextStyle(
                              color: isdarkmode.value == false
                                  ? Colors.grey[700]
                                  : Colors.grey[500],
                              fontWeight: FontWeight.w400,
                              fontSize: 13),
                        ))
                      : ListView.builder(
                          padding: EdgeInsets.zero,
                          itemCount: workexp.length,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemBuilder: (BuildContext context, int index) {
                            var dateto = workexp[index]['expLastDate'] ?? "";

                            return Container(
                              margin: const EdgeInsets.only(bottom: 10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    workexp == null
                                        ? "Title"
                                        : workexp[index]['title'],
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
                                          workexp == null
                                              ? "Company Name"
                                              : workexp[index]['companyName'] +
                                                  " - " +
                                                  "" +
                                                  workexp[index]['empStatus'],
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
                                          child: Text(
                                            dateto == ""
                                                ? workexp[index]['expstartDate']
                                                : workexp[index]
                                                        ['expstartDate'] +
                                                    " - " +
                                                    dateto,
                                            style: TextStyle(
                                                color: isdarkmode.value == false
                                                    ? Colors.grey[700]
                                                    : Colors.grey[500],
                                                fontWeight: FontWeight.w400,
                                                fontSize: 15),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
              const SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}

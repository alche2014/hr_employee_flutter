// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/UserprofileScreen.dart/Personal_Info/main_licences.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';

class LicencesCard extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const LicencesCard({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var courseDocument = data;
    var licenses = courseDocument['licenses'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Licenses & Certificates',
                style: TextStyle(
                  color: kPrimaryColor,
                  fontWeight: FontWeight.bold,
                )),
            Expanded(
              flex: 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainLicences(
                                licenses: data,
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
          licenses == null
              ? Center(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 15, top: 5),
                    child: Text(
                      "No Licences added yet",
                      style: TextStyle(
                          color: isdarkmode.value == false
                              ? Colors.grey[700]
                              : Colors.grey[500],
                          fontWeight: FontWeight.w400,
                          fontSize: 13),
                    ),
                  ),
                )
              : licenses != null && licenses.length == 0
                  ? Center(
                      child: Container(
                      margin: const EdgeInsets.only(bottom: 15, top: 5),
                      child: Text(
                        "No Licences added yet",
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
                          itemCount: licenses != null || licenses.length <= 2
                              ? licenses.length
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
                                        bottom: 4, left: 5),
                                    child: Text(
                                      licenses == null
                                          ? "Name"
                                          : licenses[index]['name'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 3, bottom: 3, left: 5),
                                    child: Text(
                                        licenses[index]['type'] == "null"
                                            ? "Type"
                                            : licenses[index]['type'],
                                        style: TextStyle(
                                            color: licenses[index]['type'] ==
                                                    "null"
                                                ? Colors.grey[500]
                                                : Colors.grey[700],
                                            fontWeight: FontWeight.w400,
                                            fontSize: 15)),
                                  ),
                                  Container(
                                      margin: const EdgeInsets.only(
                                          top: 3, bottom: 6, left: 5),
                                      child: Row(
                                        children: [
                                          Text(
                                              licenses[index]['startDate'] ==
                                                      null
                                                  ? "Date"
                                                  : licenses[index]
                                                      ['startDate'],
                                              style: TextStyle(
                                                  color: licenses[index]
                                                              ['date'] ==
                                                          null
                                                      ? Colors.grey[500]
                                                      : Colors.grey[700],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15)),
                                          const Text(' - '),
                                          Text(
                                              licenses[index]['endDate'] == null
                                                  ? "Date"
                                                  : licenses[index]['endDate'],
                                              style: TextStyle(
                                                  color: licenses[index]
                                                              ['date'] ==
                                                          null
                                                      ? Colors.grey[500]
                                                      : Colors.grey[700],
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 15))
                                        ],
                                      ))
                                ]);
                          }),
                    ),
        ],
      ),
    );
  }
}

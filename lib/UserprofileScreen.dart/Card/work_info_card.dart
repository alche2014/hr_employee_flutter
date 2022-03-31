// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';

class WorkInfoCard extends StatefulWidget {
  final data, teamEdit;
  const WorkInfoCard({Key? key, this.data, this.teamEdit}) : super(key: key);

  @override
  _WorkInfoCardState createState() => _WorkInfoCardState();
}

class _WorkInfoCardState extends State<WorkInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Work Info',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: purpleDark,
                  fontFamily: "Poppins")),
          work(widget.data)
        ],
      ),
    );
  }

  Widget work(snapshot) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      width: MediaQuery.of(context).size.width,
      padding: const EdgeInsets.only(bottom: 5, left: 7, right: 7, top: 10),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(
                top: 3,
                bottom: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Employee Type: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["empType"] ?? "Employee Type",
                        style: TextStyle(
                            color: snapshot["empType"] == null
                                ? Colors.grey[500]
                                : Colors.grey[700],
                            fontFamily: "Sofia Pro",
                            fontWeight: FontWeight.w400,
                            fontSize: 14),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(
                top: 3,
                bottom: 3,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Office Timing: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["shift"] ?? "Office Timing",
                        style: TextStyle(
                            color: snapshot["shift"] == null
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
              margin: const EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Designation: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["designation"] == null ||
                                snapshot["designation"] == ""
                            ? "Designation"
                            : snapshot["designation"],
                        style: TextStyle(
                            color: snapshot["designation"] == null ||
                                    snapshot["designation"] == ""
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
              margin: const EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Role: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["roleName"] ?? "Role",
                        style: TextStyle(
                            color: snapshot["roleName"] == null
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
              margin: const EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Department: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["department"] ?? "Department",
                        style: TextStyle(
                            color: snapshot["department"] == null
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
              margin: const EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Reporting To: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["reportingTo"] ?? "Reporting To",
                        style: TextStyle(
                            color: snapshot["reportingTo"] == null
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
              margin: const EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Work Phone: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["workPhone"] ?? "Work Phone",
                        style: TextStyle(
                            color: snapshot["workPhone"] == null
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
              margin: const EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Joining Date: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["joiningDate"] == null ||
                                snapshot["joiningDate"] == ""
                            ? "Joining Date"
                            : snapshot["joiningDate"],
                        style: TextStyle(
                            color: snapshot["joiningDate"] == null ||
                                    snapshot["joiningDate"] == ""
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
              margin: const EdgeInsets.only(top: 3, bottom: 3),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Location: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["location"] ?? "Location",
                        style: TextStyle(
                            color: snapshot["location"] == null
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
      ),
    );
  }
}

class MyTextField extends StatelessWidget {
  const MyTextField({
    Key? key,
    required this.hint,
  }) : super(key: key);
  final String hint;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: TextField(
        enabled: false,
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
          ),
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          filled: true,
          fillColor: Theme.of(context).scaffoldBackgroundColor,
          hintText: hint,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}

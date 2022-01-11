// ignore_for_file: file_names, prefer_typing_uninitialized_variables
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/main.dart';
import '../../../colors.dart';

class WorkInfoCard extends StatefulWidget {
  final data;
  const WorkInfoCard({Key? key, this.data}) : super(key: key);

  @override
  _WorkInfoCardState createState() => _WorkInfoCardState();
}

class _WorkInfoCardState extends State<WorkInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),
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
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text('Work Info',
                        style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 16,
                            fontStyle: FontStyle.normal,
                            color: darkRed)),
                  ]),
              work(widget.data)
            ],
          ),
        ),
      ),
    );
  }

  Widget work(snapshot) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(bottom: 15, left: 1, right: 1),
      child: InkWell(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              margin: const EdgeInsets.only(top: 6, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Employee Type: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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
                            fontWeight: FontWeight.w400,
                            fontSize: 15),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              margin: const EdgeInsets.only(top: 6, bottom: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Office Timing: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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
              margin: const EdgeInsets.only(
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Designation: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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
              margin: const EdgeInsets.only(
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Role: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
                          fontSize: 14),
                    ),
                  ),
                  Expanded(
                    flex: 7,
                    child: Container(
                      margin: const EdgeInsets.only(left: 10),
                      child: Text(
                        snapshot["role"] ?? "Role",
                        style: TextStyle(
                            color: snapshot["role"] == null ||
                                    snapshot["role"] == ""
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
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Department: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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
              margin: const EdgeInsets.only(
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Reporting To: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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
              margin: const EdgeInsets.only(
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Work Phone: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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
              margin: const EdgeInsets.only(
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Joining Date: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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
              margin: const EdgeInsets.only(
                top: 6,
                bottom: 6,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  const Expanded(
                    flex: 4,
                    child: Text(
                      "Location: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontWeight: FontWeight.w400,
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

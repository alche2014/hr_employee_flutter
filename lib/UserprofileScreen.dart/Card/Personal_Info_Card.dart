// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/UserprofileScreen.dart/Personal_Info/contact_info.dart';
import 'package:hr_app/Constants/colors.dart';

class PersonalInfoCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const PersonalInfoCard({Key? key, this.data}) : super(key: key);

  @override
  _PersonalInfoCardState createState() => _PersonalInfoCardState();
}

class _PersonalInfoCardState extends State<PersonalInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Personal Data',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: purpleDark)),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              ContactInfo(data: widget.data)));
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
                )),
          ]),
          personalInfo(widget.data),
          const SizedBox(height: 15),
        ],
      ),
    );
  }

  Widget personalInfo(snapshot) {
    return Container(
      padding: const EdgeInsets.only(bottom: 5, left: 5, top: 10, right: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 4,
                  child: Text(
                    "Name: ",
                    style: TextStyle(
                        color: Color(0XFF535353),
                        fontFamily: "Sofia Pro",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["displayName"] ?? "Name",
                    style: TextStyle(
                        color: snapshot["displayName"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 4,
                  child: Text(
                    "Email: ",
                    style: TextStyle(
                        color: Color(0XFF535353),
                        fontFamily: "Sofia Pro",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["otherEmail"] == "" ||
                            snapshot["otherEmail"] == null
                        ? "Email"
                        : snapshot["otherEmail"],
                    style: TextStyle(
                        color: snapshot["otherEmail"] == "" ||
                                snapshot["otherEmail"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 4,
                  child: Text(
                    "Phone: ",
                    style: TextStyle(
                        color: Color(0XFF535353),
                        fontFamily: "Sofia Pro",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["phone"] ?? "Phone",
                    style: TextStyle(
                        color: snapshot["phone"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 4,
                  child: Text(
                    "City: ",
                    style: TextStyle(
                        color: Color(0XFF535353),
                        fontFamily: "Sofia Pro",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["cityName"] ?? "City",
                    style: TextStyle(
                        color: snapshot["cityName"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: const Text(
                      "Gender: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["gender"] ?? "Gender",
                    style: TextStyle(
                        color: snapshot["gender"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(right: 8),
                    child: const Text(
                      "Marital Status: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["maritalStatus"] ?? "Marital Status",
                    style: TextStyle(
                        color: snapshot["maritalStatus"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 4,
                  child: Text(
                    "Blood Group: ",
                    style: TextStyle(
                        color: Color(0XFF535353),
                        fontFamily: "Sofia Pro",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["bloodGroup"] ?? "Blood Group",
                    style: TextStyle(
                        color: snapshot["bloodGroup"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                const Expanded(
                  flex: 4,
                  child: Text(
                    "Address: ",
                    style: TextStyle(
                        color: Color(0XFF535353),
                        fontFamily: "Sofia Pro",
                        fontWeight: FontWeight.w500,
                        fontSize: 14),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["address"] ?? "Address",
                    style: TextStyle(
                        color: snapshot["address"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: const Text(
                      "Emergency Contact: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["emergencyPhone"] ?? "Emergency Contact",
                    style: TextStyle(
                        color: snapshot["emergencyPhone"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: const Text(
                      "CNIC: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["cnic"] == null || snapshot["cnic"] == ""
                        ? "CNIC"
                        : snapshot["cnic"],
                    style: TextStyle(
                        color:
                            snapshot["cnic"] == null || snapshot["cnic"] == ""
                                ? Colors.grey[500]
                                : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: const Text(
                      "DOB: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["dob"] == null || snapshot["dob"] == ""
                        ? "Date of Birth"
                        : snapshot['dob'],
                    style: TextStyle(
                        color: snapshot["dob"] == null || snapshot["dob"] == ""
                            ? Colors.grey[500]
                            : Colors.grey[700],
                        fontWeight: FontWeight.w400,
                        fontSize: 15),
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: Container(
                    padding: const EdgeInsets.only(right: 5),
                    child: const Text(
                      "Age: ",
                      style: TextStyle(
                          color: Color(0XFF535353),
                          fontFamily: "Sofia Pro",
                          fontWeight: FontWeight.w500,
                          fontSize: 14),
                    ),
                  ),
                ),
                Expanded(
                  flex: 7,
                  child: Text(
                    snapshot["age"] ?? "Age",
                    style: TextStyle(
                        color: snapshot["age"] == null
                            ? Colors.grey[500]
                            : Colors.grey[700],
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
    // });
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

// ignore_for_file: file_names
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/UserprofileScreen.dart/Personal_Info/MedicalInfo.dart';
import 'package:hr_app/UserprofileScreen.dart/Personal_Info/contact_info.dart';
import 'package:hr_app/Constants/colors.dart';

class MedicalInfoCard extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data, teamEdit;
  const MedicalInfoCard({Key? key, this.data, this.teamEdit}) : super(key: key);

  @override
  _MedicalInfoCardState createState() => _MedicalInfoCardState();
}

class _MedicalInfoCardState extends State<MedicalInfoCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            const Text('Medical Info',
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: purpleDark)),
            widget.teamEdit
                ? InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  MedicalInfo(data: widget.data)));
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
                    ))
                : Container(),
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
                    "Medical Card ID: ",
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
                    snapshot["medicalId"] == "" || snapshot["medicalId"] == null
                        ? "Card Id"
                        : snapshot["medicalId"],
                    style: TextStyle(
                        color: snapshot["medicalId"] == "" ||
                                snapshot["medicalId"] == null
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
                    "Health Condition: ",
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
                    snapshot["healthCondition"] ?? "Health Condition",
                    style: TextStyle(
                        color: snapshot["healthCondition"] == null
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
                    "Any Disease: ",
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
                    snapshot["disease"] ?? "Disease",
                    style: TextStyle(
                        color: snapshot["disease"] == null
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
                    "Any Allergies: ",
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
                    snapshot["allergy"] ?? "Allergy",
                    style: TextStyle(
                        color: snapshot["allergy"] == null
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

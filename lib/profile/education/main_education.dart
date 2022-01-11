import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/education/add_education.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';

class MainEducationCard extends StatelessWidget {
  final mainEdu;
  const MainEducationCard({this.mainEdu, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var education = mainEdu['education'];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Education', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              children: [
                EducationCard(
                  education: education,
                  mainEdu: mainEdu,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Education(
                      data: education,
                      // uid: mainEdu,
                      editable: false)));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        backgroundColor: kPrimaryColor,
      ),
    );
  }
}

class EducationCard extends StatefulWidget {
  final education, mainEdu;
  const EducationCard({this.education, this.mainEdu, Key? key})
      : super(key: key);

  @override
  _EducationCardState createState() => _EducationCardState();
}

class _EducationCardState extends State<EducationCard> {
  @override
  Widget build(BuildContext context) {
    // var workexpDocument = widget.workexp['workExperience'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: ListView.builder(
            padding: EdgeInsets.zero,
            itemCount: widget.education != null ? widget.education.length : 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              return InkWell(
                onTap: () {
                  print("uid::::::::::::::::::::::${widget.mainEdu["uid"]}");
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Education(
                              data: widget.education[index],
                              uid: widget.mainEdu,
                              editable: true)));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.4), width: 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.education == null
                            ? "school"
                            : widget.education[index]['school'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Text(
                          widget.education == null
                              ? "Degree"
                              : widget.education[index]['degree'],
                          // +
                          //     " - "
                          //+
                          // "" +
                          // widget.education[index]['degree'],
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(bottom: 6),
                        child: Text(
                          widget.education == null
                              ? "Years"
                              : (widget.education[index]['expstartDate'] +
                                  " - " +
                                  widget.education[index]['expLastDate']),
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      ),
    );
  }
}

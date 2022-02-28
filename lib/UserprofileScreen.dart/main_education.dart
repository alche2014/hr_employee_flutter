import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'appbar.dart';
import 'add_education.dart';

class MainEducationCard extends StatelessWidget {
  final mainEdu;
  const MainEducationCard({this.mainEdu, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var education = mainEdu['education'];
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: buildMyAppBar(context, 'Education', true),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.only(bottom: 50, top: 15),
              child: EducationCard(
                education: education,
                mainEdu: mainEdu,
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => Education(
                      data: education, uid: mainEdu["uid"], editable: false)));
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
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        child: widget.education == null
            ? notfound()
            : widget.education != null && widget.education.length == 0
                ? notfound()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    itemCount:
                        widget.education != null ? widget.education.length : 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      return InkWell(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => Education(
                                      data: widget.education[index],
                                      uid: widget.mainEdu['uid'],
                                      editable: true)));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              border:
                                  Border.all(color: Colors.white, width: 0)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.education == null
                                    ? "school"
                                    : widget.education[index]['school'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 6, bottom: 6),
                                child: Text(
                                  widget.education[index]['degree'] == ""
                                      ? "Degree"
                                      : widget.education[index]['degree'],
                                  style: TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15,
                                      color: widget.education[index]
                                                  ['degree'] ==
                                              ""
                                          ? Colors.grey[700]
                                          : Colors.black),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  widget.education == null
                                      ? "Years"
                                      : (widget.education[index]
                                              ['expstartDate'] +
                                          " - " +
                                          widget.education[index]
                                              ['expLastDate']),
                                  style: const TextStyle(
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

  Widget notfound() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height / 1.4,
        margin: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.menu_book_sharp,
              color: purpleDark,
              size: 100,
            ),
            const Text(
              "It's empty here.",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "You haven't added any education yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click Add New Education to get started.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            )
          ],
        ),
      ),
    );
  }
}

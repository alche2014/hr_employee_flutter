import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/experiences/add_experiences.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';

class MainExperiences extends StatelessWidget {
  // ignore: prefer_typing_uninitialized_variables
  final workexp;
  const MainExperiences({this.workexp, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var experience = workexp['workExperience'];
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Experiences', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              children: [
                CardOne(
                  workexp: experience,
                  mainExp: workexp,
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => AddExperience(
                        data: workexp,
                        editable: false,
                      )));
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

class CardOne extends StatefulWidget {
  final workexp;
  final mainExp;
  const CardOne({this.workexp, this.mainExp, Key? key}) : super(key: key);

  @override
  _CardOneState createState() => _CardOneState();
}

class _CardOneState extends State<CardOne> {
  @override
  Widget build(BuildContext context) {
    // var workexpDocument = widget.workexp['workExperience'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
      child: Container(
        margin: const EdgeInsets.only(top: 10),
        child: widget.workexp == null
            ? notfound()
            : widget.workexp != null && widget.workexp.length == 0
                ? notfound()
                : ListView.builder(
                    padding: EdgeInsets.zero,
                    // separatorBuilder: (context, index) => Divider(
                    // color: Colors.grey, )
                    itemCount:
                        widget.workexp != null ? widget.workexp.length : 0,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (BuildContext context, int index) {
                      var dateto = widget.workexp[index]['expLastDate'] ?? "";
                      return InkWell(
                        onTap: () {
                          print(
                              "uid::::::::::::::::::::::${widget.mainExp["uid"]}");

                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AddExperience(
                                        data: widget.workexp[index],
                                        uid: widget.mainExp,
                                        editable: true,
                                      )));
                        },
                        child: Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.only(
                              left: 10, top: 10, bottom: 10),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(3),
                              border: Border.all(
                                  color: Colors.grey.withOpacity(0.3),
                                  width: 1)),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                widget.workexp == null
                                    ? "Title"
                                    : widget.workexp[index]['title'],
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 6, bottom: 6),
                                child: Text(
                                  widget.workexp == null
                                      ? "Company Name"
                                      : widget.workexp[index]['companyName'] +
                                          " - " +
                                          "" +
                                          widget.workexp[index]['empStatus'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(bottom: 6),
                                child: Text(
                                  dateto == ""
                                      ? widget.workexp[index]['expstartDate']
                                      : widget.workexp[index]['expstartDate'] +
                                          " - " +
                                          dateto,
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
              Icons.work_outline_outlined,
              color: Color(0xFFBF2B38),
              size: 100,
            ),
            Text(
              "It's empty here.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 16,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w600),
            ),
            Text(
              "You haven't added any experience yet.",
              style: TextStyle(
                  color: Colors.grey[400],
                  fontSize: 12,
                  fontFamily: "Roboto",
                  fontWeight: FontWeight.w400),
            ),
            Text(
              "Click Add New Experience to get started.",
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

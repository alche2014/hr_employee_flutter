import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/experiences/add_experiences.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';

class MainExperiences extends StatelessWidget {
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
                CardOne(workexp: experience),
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
  const CardOne({this.workexp, Key? key}) : super(key: key);

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
        child: ListView.builder(
            padding: EdgeInsets.zero,
            // separatorBuilder: (context, index) => Divider(
            // color: Colors.grey, )
            itemCount: widget.workexp != null ? widget.workexp.length : 0,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              var dateto = widget.workexp[index]['expLastDate'] ?? "";
              return InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AddExperience(
                                data: widget.workexp[index],
                                editable: true,
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.only(left: 10, top: 10, bottom: 10),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(3),
                      border: Border.all(
                          color: Colors.grey.withOpacity(0.3), width: 1)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        widget.workexp == null
                            ? "Title"
                            : widget.workexp[index]['title'],
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 6, bottom: 6),
                        child: Text(
                          widget.workexp == null
                              ? "Company Name"
                              : widget.workexp[index]['companyName'] +
                                  " - " +
                                  "" +
                                  widget.workexp[index]['empStatus'],
                          style: const TextStyle(
                              color: Colors.black,
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

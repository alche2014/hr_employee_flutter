// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/mainApp/main_home_profile/apply_leaves.dart';

// ignore: must_be_immutable
class LeaveCard extends StatelessWidget {
  //resue card but with chainging
  final text;
  final allLeaves;
  final joiningDate;

  VoidCallback? press;
  LeaveCard({Key? key, this.text, this.allLeaves, this.joiningDate, this.press})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        onTap: press,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            border: Border.all(color: Colors.grey.shade300, width: 1),
          ),
          child: Column(
            children: <Widget>[
              Row(
                children: [
                  CircleAvatar(
                      radius: 25,
                      backgroundColor: lightPink,
                      child: Icon(Icons.layers, color: purpleDark, size: 32)),
                  SizedBox(
                    width: 20,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8),
                      Text(text!["name"].toString(),
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Text(
                          (text!['leaveQuota'] - text!['taken']).toString() +
                              " Leaves Pending",
                          style: TextStyle(color: Colors.grey, fontSize: 14)),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => AddLeave(
                                    leavesData: allLeaves,
                                    joiningDate: joiningDate,
                                  ));
                        },
                        child: Text(
                          'Apply Now',
                          style:
                              TextStyle(color: Colors.red[800], fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 10),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//=============================================================//

// ignore: must_be_immutable
class MyCustomCard extends StatelessWidget {
  String? header;
  String? body;
  bool? status;
  bool? buttonToggle;
  bool? statusToggle;
  bool? picOrName;

  MyCustomCard(
      {Key? key,
      this.header,
      this.body,
      this.status,
      this.buttonToggle,
      this.statusToggle,
      this.picOrName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2)),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$header',
                      style: TextStyle(
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? purpleLight
                            : lightRedForDark, //color red
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                    //==============================================//
                    if (statusToggle == true)
                      Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: status == true ? lightGreen : lightPink,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: status == true
                                ? Text('Approved', textAlign: TextAlign.center)
                                : Text('Pending', textAlign: TextAlign.center),
                          )),
                    //----------------------------------------//
                    if (statusToggle == false)
                      TextButton(
                        onPressed: () {},
                        child: Text(
                          'Edit',
                          style: TextStyle(
                              color:
                                  MediaQuery.of(context).platformBrightness ==
                                          Brightness.light
                                      ? purpleLight
                                      : lightRedForDark),
                        ),
                      ),
                    if (status == null) SizedBox(),
                  ],
                ),
              ),
              SizedBox(height: 10),
              //==================================//
              if (picOrName == true)
                Row(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.asset('assets/images/user.png'),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('Lee Williamson'),
                        Text('Designation'),
                      ],
                    ),
                  ],
                ),
              if (picOrName == false)
                Text('Name Here',
                    style: TextStyle(
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? purpleLight
                          : lightRedForDark, //color red
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    )),
              if (picOrName == null) SizedBox(),
              //===============================================//
              SizedBox(height: 20.0),
              Text(
                '$body',
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              SizedBox(height: 30),
              Text(
                '14:01 20/10/2020',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 10),
              if (buttonToggle == true)
                Row(
                  children: [
                    ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                            primary:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? purpleLight
                                    : lightRedForDark),
                        child: Text('Reject')),
                    SizedBox(width: 10),
                    //------------------//
                    ElevatedButton(
                        onPressed: () {
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (context) => TeamManager()));
                        },
                        style: ElevatedButton.styleFrom(
                            primary:
                                MediaQuery.of(context).platformBrightness ==
                                        Brightness.light
                                    ? Colors.green[700]
                                    : lightGreen),
                        child: Text(
                          'Approved',
                          // style: TextStyle(color: Colors.white),
                        )),
                  ],
                ),
              if (buttonToggle == false)
                Row(
                  children: [
                    Container(
                        height: 40,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: lightGreen,
                        ),
                        child: const Padding(
                          padding: EdgeInsets.all(10.0),
                          child: Text(
                            'Approved',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.black),
                          ),
                        )),
                  ],
                ),
              if (buttonToggle == null) SizedBox(),
            ],
          ),
        ),
      ),
    );
  }
}

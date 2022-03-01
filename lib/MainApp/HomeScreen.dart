import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/MainApp/CheckIn/main_check_in.dart';
import 'package:hr_app/MainApp/screen_notification.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';

class HrDashboard extends StatefulWidget {
  const HrDashboard({Key? key}) : super(key: key);

  @override
  _HrDashboardState createState() => _HrDashboardState();
}

class _HrDashboardState extends State<HrDashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        body: Column(children: [
          UpperPortion(),
          const Text(
            "09:12",
            style: TextStyle(
                fontFamily: "Poppins",
                color: Colors.black,
                fontSize: 30,
                fontWeight: FontWeight.w400),
          ),
          Container(
            margin: const EdgeInsets.only(top: 5, bottom: 5),
            child: const Text(
              "Wednesday,Sep 29",
              style: TextStyle(
                  fontFamily: "Poppins",
                  color: greyShade,
                  fontSize: 16,
                  fontWeight: FontWeight.w400),
            ),
          ),
          const SizedBox(height: 5),
          Container(
            height: 145,
            width: 145,
            decoration:
                const BoxDecoration(color: purpleDark, shape: BoxShape.circle),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/Group.png',
                  height: 50,
                  width: 50,
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  child: const Text(
                    "CLOCK IN",
                    style: TextStyle(
                        fontFamily: "Poppins",
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 15),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(
                Icons.location_on,
                size: 20,
                color: Colors.grey,
              ),
              Text("Location: $yourAddress",
                  style: const TextStyle(
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      color: greyShade)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/checkin.png',
                      height: 25,
                      width: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        "09:12",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text("Clock in",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: lightGrey)),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/checkout.png',
                      height: 25,
                      width: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        "09:12",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text("Clock out",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: lightGrey)),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  children: [
                    Image.asset(
                      'assets/workingHrs.png',
                      height: 25,
                      width: 25,
                    ),
                    Container(
                      margin: const EdgeInsets.only(top: 5),
                      child: const Text(
                        "09:12",
                        style: TextStyle(
                            fontFamily: "Poppins",
                            color: Colors.black,
                            fontSize: 18,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
                    const Text("Working Hr's",
                        style: TextStyle(
                            fontSize: 15,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                            color: lightGrey)),
                  ],
                ),
              ),
            ],
          ),
          TextButton(
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => MainCheckIn(uid: uid)));
              },
              child: const Text('View History',
                  style: TextStyle(
                      decoration: TextDecoration.underline,
                      fontSize: 15,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF5B3F6E)))),
          Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            height: 1,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Container(
              margin: const EdgeInsets.only(top: 40),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/announcement.jpg',
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: SizedBox(
                        height: 30,
                        width: 30,
                        child: Image.asset(
                          'assets/leaves.jpg',
                        ),
                      ),
                    ),
                    Expanded(
                        flex: 3,
                        child: SizedBox(
                            height: 30,
                            width: 30,
                            child: Image.asset('assets/team.jpg')))
                  ]))
        ]));
  }
}

class UpperPortion extends StatelessWidget {
  final data;
  const UpperPortion({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 28),
                          Expanded(
                            flex: 8,
                            child: Container(
                              padding: const EdgeInsets.only(top: 62.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Hello, $empName",
                                    style: const TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                        fontSize: 17,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    DateFormat('EEEE, dd MMMM yyyy')
                                        .format(DateTime.now()),
                                    style: const TextStyle(
                                        fontFamily: "Poppins",
                                        color: Colors.white,
                                        fontSize: 11,
                                        fontWeight: FontWeight.w400),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true).push(
                                    MaterialPageRoute(
                                        builder: (context) => Notifications(
                                            uid: userId, key: null)));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(top: 62.0),
                                child: Image.asset(
                                  'assets/notification_Icon.png',
                                  height: 25,
                                  width: 25,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Expanded(
                            flex: 3,
                            child: Container(
                              padding:
                                  const EdgeInsets.only(top: 50.0, right: 20),
                              child: Container(
                                height: 55,
                                width: 55,
                                child: Container(
                                    decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        image: imagePath == null ||
                                                imagePath == ""
                                            ? const DecorationImage(
                                                image: NetworkImage(
                                                    'https://via.placeholder.com/150'))
                                            : DecorationImage(
                                                image: NetworkImage(imagePath),
                                                fit: BoxFit.fill))),
                                decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Colors.white),
                              ),
                            ),
                          )
                        ]),
                  ),
                  height: 180,
                  decoration: const BoxDecoration(
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment.topCenter,
                          end: Alignment(0, -13.0),
                          colors: [purpleLight, purpleDark])))),
          Positioned(
            top: 130,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Colors.grey.shade100,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

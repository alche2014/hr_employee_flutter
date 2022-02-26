// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/AboutCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/DependentCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/KinCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/LicenceCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/work_info_card.dart';
import 'package:hr_app/UserprofileScreen.dart/screen_dependent.dart';
import 'package:hr_app/UserprofileScreen.dart/TrainingsCard.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/Login/auth.dart';
import 'package:hr_app/Constants/constants.dart';
import 'Card/AccountInfoCard.dart';
import 'Card/EducationCard.dart';
import 'Card/ExperienceCard.dart';
import 'Card/Personal_Info_Card.dart';
import 'Card/skillsCard.dart';

class MyProfileEdit extends StatefulWidget {
  const MyProfileEdit({Key? key}) : super(key: key);

  @override
  _MyProfileEditState createState() => _MyProfileEditState();
}

class _MyProfileEditState extends State<MyProfileEdit> {
  Connectivity? connectivity;

  StreamSubscription<ConnectivityResult>? subscription;

  bool isNetwork = true;

  var firebaseUser;

  String? userId;

  Stream? stream;

  String? urlList;

  String? value;
  int guest = 0;

  loadData() async {
    stream = null;

    firebaseUser = await FirebaseAuth.instance.currentUser!;
    userId = firebaseUser!.uid;

    await FirebaseFirestore.instance
        .collection("employees")
        .where('uid', isEqualTo: firebaseUser.uid)
        .get()
        .then((value) {
      guest = value.docs.length;
    });
    setState(() {});
    stream = await load();
  }

  Future<Stream> load() async {
    DocumentReference collectionReference = guest == 0
        ? FirebaseFirestore.instance.collection('guest').doc(firebaseUser!.uid)
        : FirebaseFirestore.instance
            .collection('employees')
            .doc(firebaseUser!.uid);
    Stream<DocumentSnapshot> query = collectionReference.snapshots();
    return query;
  }

  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = Connectivity();

    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {
          isNetwork = false;
        });
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {
          isNetwork = true;
        });
      }
    });

    loadData();
  }

  void showLoadingDialog(BuildContext context, String value) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            LoadingDialog(value: value)));
  }

  @override
  void dispose() {
    subscription!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: stream == null
          ? Center(child: CircularProgressIndicator())
          : StreamBuilder<DocumentSnapshot>(
              stream: guest == 0
                  ? FirebaseFirestore.instance
                      .collection("guests")
                      .doc("$userId")
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("employees")
                      .doc("$userId")
                      .snapshots(),
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.hasError) {
                  return Center(child: CircularProgressIndicator());
                } else if (!snapshot.hasData) {
                  return Center(child: CircularProgressIndicator());
                }

                return Column(
                  children: [
                    UpperPortion(data: snapshot.data!.data()),
                    Container(
                      width: MediaQuery.of(context).size.width - 40,
                      height: MediaQuery.of(context).size.height - 250,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            ProfilePic(data: snapshot.data!.data()),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              child: Theme(
                                data: ThemeData(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                    title: Row(
                                      children: const [
                                        Icon(Icons.person, color: purpleDark),
                                        Text(
                                          "  Personal Info",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              color: purpleDark,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    children: [
                                      AboutCard(data: snapshot.data!.data()),
                                      closing(),
                                      KinCard(data: snapshot.data!.data()),
                                      closing(),
                                      Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 25, vertical: 10),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Emergency Contact',
                                                  style: TextStyle(
                                                    color: kPrimaryColor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                                InkWell(
                                                    child: Container(
                                                        width: 50,
                                                        height: 30,
                                                        alignment: Alignment
                                                            .centerRight,
                                                        child: const Text(
                                                            'Edit',
                                                            style: TextStyle(
                                                                color:
                                                                    kPrimaryColor,
                                                                fontSize: 13,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w400))),
                                                    onTap: () {
                                                      Navigator.of(context).push(
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  Dependent(
                                                                      dependent: snapshot
                                                                          .data!
                                                                          .data())));
                                                    }),
                                              ],
                                            ),
                                            //------------Body----------
                                            dependent(snapshot.data!.data())
                                          ],
                                        ),
                                      ),
                                      closing(),
                                      DependentsCard(
                                          data: snapshot.data!.data()),
                                      closing(),
                                      PersonalInfoCard(
                                          data: snapshot.data!.data()),
                                    ]),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              child: Theme(
                                data: ThemeData(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                  title: Row(
                                    children: const [
                                      Icon(Icons.person, color: purpleDark),
                                      Text(
                                        "  Profile Info",
                                        style: TextStyle(
                                            color: purpleDark,
                                            fontSize: 16.0,
                                            fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  children: [
                                    EducationCard(data: snapshot.data!.data()),
                                    closing(),
                                    ExperienceCard(data: snapshot.data!.data()),
                                    closing(),
                                    LicencesCard(data: snapshot.data!.data()),
                                    closing(),
                                    TrainingsCard(data: snapshot.data!.data()),
                                    closing(),
                                    SkillsCard(data: snapshot.data!.data()),
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              margin: EdgeInsets.only(top: 10, bottom: 5),
                              child: Theme(
                                data: ThemeData(
                                  dividerColor: Colors.transparent,
                                ),
                                child: ExpansionTile(
                                    title: Row(
                                      children: const [
                                        Icon(Icons.person, color: purpleDark),
                                        Text(
                                          "  Employment Info",
                                          style: TextStyle(
                                              color: purpleDark,
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        )
                                      ],
                                    ),
                                    children: [
                                      guest == 0
                                          ? Container()
                                          : WorkInfoCard(
                                              data: snapshot.data!.data()),
                                      closing(),
                                      AccountInfoCard(
                                          data: snapshot.data!.data())
                                    ]),
                              ),
                            ),
                            guest != 0
                                ? Container()
                                : Container(
                                    alignment: Alignment.centerLeft,
                                    child: TextButton.icon(
                                      onPressed: () {
                                        showDialog(
                                          context: context,
                                          barrierDismissible:
                                              false, // user must tap button for close dialog!
                                          builder: (BuildContext context) {
                                            return CupertinoAlertDialog(
                                              title: Text('Quit'),
                                              content: const Text(
                                                  'Are you sure you want to LOGOUT?'),
                                              actions: <Widget>[
                                                FlatButton(
                                                  child: const Text('No'),
                                                  onPressed: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                FlatButton(
                                                  child: const Text('Yes'),
                                                  onPressed: () {
                                                    AuthService()
                                                        .signOut(context);
                                                  },
                                                )
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      icon: Icon(Icons.logout,
                                          color: isdarkmode.value == false
                                              ? const Color(0xff34354A)
                                              : Colors.grey[500]),
                                      label: Text('Log Out',
                                          style: TextStyle(
                                              color: isdarkmode.value == false
                                                  ? const Color(0xff34354A)
                                                  : Colors.grey[500])),
                                    ),
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              }),
    );
  }

  Widget closing() {
    return Container(
        margin: EdgeInsets.only(left: 25, right: 25, top: 10, bottom: 10),
        height: 1,
        color: Colors.grey.shade300);
  }

  Widget dependent(snapshot) {
    return Container(
        padding: const EdgeInsets.only(bottom: 5, left: 5, right: 5, top: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Name: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["depName"] ?? "Name",
                          style: TextStyle(
                              color: snapshot["depName"] == null
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
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Relation: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["relation"] ?? "Relation",
                          style: TextStyle(
                              color: snapshot["relation"] == null
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
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Phone: ",
                        style: TextStyle(
                            color: Color(0XFF535353),
                            fontWeight: FontWeight.w500,
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["depPhone"] ?? "Phone",
                          style: TextStyle(
                              color: snapshot["depPhone"] == null
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
                  child: Padding(
                    padding: const EdgeInsets.only(top: 52.0),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SizedBox(width: 20),
                          Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 17),
                          Text(
                            "  Profile",
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 17,
                                fontWeight: FontWeight.w500),
                          ),
                        ]),
                  ),
                  height: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment.topCenter,
                          end: Alignment(0, -13.0),
                          colors: const [purpleLight, purpleDark])))),
          Positioned(
            top: 120,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  topRight: Radius.circular(35),
                ),
                color: Colors.grey.shade100,
              ),
            ),
          ),
          Positioned(
              top: 85,
              left: 35,
              child: Container(
                height: 90,
                width: 90,
                child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image:
                            data['imagePath'] == null || data['imagePath'] == ""
                                ? DecorationImage(
                                    image: NetworkImage(
                                        'https://via.placeholder.com/150'))
                                : DecorationImage(
                                    image: NetworkImage(
                                        data["imagePath"]), // picked file
                                  ))),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                ),
                padding: EdgeInsets.all(4),
              ))
        ],
      ),
    );
  }
}

//====================================================//

class ProfilePic extends StatefulWidget {
  final data;
  ProfilePic({Key? key, this.data}) : super(key: key);

  @override
  State<ProfilePic> createState() => _ProfilePicState();
}

class _ProfilePicState extends State<ProfilePic> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      margin: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 9,
            child: Container(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.data['displayName'] ?? "Name: Nill",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(height: 3),
                    Row(
                      children: [
                        Text("Employee Id: ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14)),
                        Text(widget.data['empId'] ?? " Nill",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                color: Colors.grey.shade600, fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 3),
                    Text(widget.data['department'] ?? "Department: Nill",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14)),
                    SizedBox(height: 3),
                    Text(widget.data['designation'] ?? "Designation: Nill",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: Colors.grey.shade600, fontSize: 14)),
                  ]),
            ),
          ),
          // Expanded(
          //   flex: 1,
          //   child: Icon(
          //     Icons.edit,
          //     color: purpleDark,
          //   ),
          // )
        ],
      ),
    );
  }
}

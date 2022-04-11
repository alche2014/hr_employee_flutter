// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, deprecated_member_use
import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/MainApp/screen_notification.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/AboutCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/AssetsCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/ContacInfoCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/DependentCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/KinCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/LicenceCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/MedicalInfoCard.dart';
import 'package:hr_app/UserprofileScreen.dart/Card/work_info_card.dart';
import 'package:hr_app/UserprofileScreen.dart/ProfilePic.dart';
import 'package:hr_app/UserprofileScreen.dart/screen_dependent.dart';
import 'package:hr_app/UserprofileScreen.dart/TrainingsCard.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/MainApp/Login/auth.dart';
import 'package:hr_app/Constants/constants.dart';
import 'Card/AccountInfoCard.dart';
import 'Card/EducationCard.dart';
import 'Card/ExperienceCard.dart';
import 'Card/Personal_Info_Card.dart';
import 'Card/skillsCard.dart';

// ignore: must_be_immutable
class MyProfileEdit extends StatefulWidget {
  final teamId;
  const MyProfileEdit({Key? key, this.teamId}) : super(key: key);

  @override
  _MyProfileEditState createState() => _MyProfileEditState();
}

class _MyProfileEditState extends State<MyProfileEdit> {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isNetwork = true;
  int guest = 1;
  String? urlList;
  String? value;

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
      body: StreamBuilder<DocumentSnapshot>(
          stream: widget.teamId == ""
              ? guest == 0
                  ? FirebaseFirestore.instance
                      .collection("guests")
                      .doc(uid)
                      .snapshots()
                  : FirebaseFirestore.instance
                      .collection("employees")
                      .doc(uid)
                      .snapshots()
              : FirebaseFirestore.instance
                  .collection("employees")
                  .doc(widget.teamId)
                  .snapshots(),
          builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
            if (snapshot.hasError) {
              return Center(child: CircularProgressIndicator());
            } else if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }

            return Column(
              children: [
                widget.teamId == ""
                    ? UpperPortion(
                        userId: widget.teamId == "" ? uid : widget.teamId,
                        title: "Profile",
                        showBack: true)
                    : TeamUpperPortion(
                        data: snapshot.data!.data(),
                        title: "Profile",
                      ),
                SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  height: MediaQuery.of(context).size.height - 200,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        widget.teamId == ""
                            ? ProfilePic()
                            : TeamProfile(data: snapshot.data!.data()),
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
                                collapsedIconColor: purpleDark,
                                iconColor: purpleDark,
                                title: Row(
                                  children: [
                                    SizedBox(
                                        height: 20,
                                        child:
                                            Image.asset("assets/profile.png")),
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
                                  AboutCard(
                                      data: snapshot.data!.data(),
                                      teamEdit:
                                          widget.teamId == "" ? true : false),
                                  closing(),
                                  PersonalInfoCard(
                                      data: snapshot.data!.data(),
                                      teamEdit:
                                          widget.teamId == "" ? true : false),
                                  closing(),
                                  ContactInfoCard(
                                      data: snapshot.data!.data(),
                                      teamEdit:
                                          widget.teamId == "" ? true : false),
                                  closing(),
                                  MedicalInfoCard(
                                      data: snapshot.data!.data(),
                                      teamEdit:
                                          widget.teamId == "" ? true : false),
                                  closing(),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 10),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              'Emergency Contact',
                                              style: TextStyle(
                                                color: kPrimaryColor,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 14,
                                              ),
                                            ),
                                            widget.teamId == ""
                                                ? InkWell(
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
                                                    })
                                                : Container(),
                                          ],
                                        ),
                                        //------------Body----------
                                        dependent(snapshot.data!.data())
                                      ],
                                    ),
                                  ),
                                  closing(),
                                  DependentsCard(
                                      data: snapshot.data!.data(),
                                      teamEdit:
                                          widget.teamId == "" ? true : false),
                                  // closing(),
                                  // KinCard(
                                  //     data: snapshot.data!.data(),
                                  //     teamEdit:
                                  //         widget.teamId == "" ? true : false),
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
                              collapsedIconColor: purpleDark,
                              iconColor: purpleDark,
                              title: Row(
                                children: [
                                  SizedBox(
                                      height: 20,
                                      child:
                                          Image.asset("assets/personal.png")),
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
                                EducationCard(
                                    data: snapshot.data!.data(),
                                    teamEdit:
                                        widget.teamId == "" ? true : false),
                                closing(),
                                ExperienceCard(
                                    data: snapshot.data!.data(),
                                    teamEdit:
                                        widget.teamId == "" ? true : false),
                                closing(),
                                LicencesCard(
                                    data: snapshot.data!.data(),
                                    teamEdit:
                                        widget.teamId == "" ? true : false),
                                closing(),
                                TrainingsCard(
                                    data: snapshot.data!.data(),
                                    teamEdit:
                                        widget.teamId == "" ? true : false),
                                closing(),
                                SkillsCard(
                                    data: snapshot.data!.data(),
                                    teamEdit:
                                        widget.teamId == "" ? true : false),
                              ],
                            ),
                          ),
                        ),
                        guest == 0
                            ? Container()
                            : Container(
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
                                      collapsedIconColor: purpleDark,
                                      iconColor: purpleDark,
                                      title: Row(
                                        children: [
                                          SizedBox(
                                              height: 20,
                                              child: Image.asset(
                                                  "assets/employment.png")),
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
                                                data: snapshot.data!.data(),
                                                teamEdit: widget.teamId == ""
                                                    ? true
                                                    : false),
                                      ]),
                                ),
                              ),
                        guest == 0
                            ? Container()
                            : Container(
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
                                      collapsedIconColor: purpleDark,
                                      iconColor: purpleDark,
                                      title: Row(
                                        children: const [
                                          SizedBox(
                                              height: 20,
                                              child: Icon(
                                                Icons.account_box_outlined,
                                                color: purpleDark,
                                              )),
                                          Text(
                                            "  Account Info",
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
                                            : AccountInfoCard(
                                                data: snapshot.data!.data(),
                                                teamEdit: widget.teamId == ""
                                                    ? true
                                                    : false),
                                      ]),
                                ),
                              ),
                        guest == 0
                            ? Container()
                            : Container(
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
                                      collapsedIconColor: purpleDark,
                                      iconColor: purpleDark,
                                      title: Row(
                                        children: const [
                                          SizedBox(
                                              height: 20,
                                              child: Icon(
                                                Icons.assignment_sharp,
                                                color: purpleDark,
                                              )),
                                          Text(
                                            "  Assets Info",
                                            style: TextStyle(
                                                color: purpleDark,
                                                fontSize: 16.0,
                                                fontWeight: FontWeight.bold),
                                          )
                                        ],
                                      ),
                                      children: [
                                        AssetsCard(
                                            data: snapshot.data!.data(),
                                            teamEdit: widget.teamId == ""
                                                ? true
                                                : false),
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
                                                AuthService().signOut(context);
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
                        SizedBox(height: 20)
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
              Container(
                margin: const EdgeInsets.only(top: 3, bottom: 3, left: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Text(
                        "Address: ",
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
                          snapshot["depAddress"] ?? "Address",
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
  final userId, title, showBack;
  const UpperPortion({Key? key, this.userId, this.title, this.showBack})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  padding: EdgeInsets.only(top: 35),
                  child: ListTile(
                      title: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            showBack
                                ? Icon(Icons.arrow_back_ios_new,
                                    color: Colors.white, size: 19)
                                : Text(""),
                            SizedBox(width: 20),
                            Text(
                              title,
                              style: TextStyle(
                                  fontFamily: "Poppins",
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ),
                      trailing: InkWell(
                        onTap: () {
                          Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute(
                                  builder: (context) =>
                                      Notifications(uid: uid, key: null)));
                        },
                        child: Icon(Icons.notifications,
                            color: Colors.white, size: 22),
                      )),
                  height: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment.topCenter,
                          end: Alignment(0, -13.0),
                          colors: const [purpleLight, purpleDark])))),
          Positioned(
            top: 135,
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
              top: 95,
              left: 35,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ProfilePicture()));
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: 40,
                    child: ClipRRect(
                      clipBehavior: Clip.antiAlias,
                      borderRadius: BorderRadius.circular(100),
                      child: imagePath != null || imagePath != ""
                          ? CachedNetworkImage(
                              imageUrl: imagePath,
                              fit: BoxFit.cover,
                              height: 94,
                              width: 94,
                              progressIndicatorBuilder:
                                  (context, url, downloadProgress) =>
                                      CircularProgressIndicator(
                                value: downloadProgress.progress,
                                color: Colors.white,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
                            )
                          : Image.asset(
                              'assets/placeholder.png',
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle, color: Colors.white),
                  padding: EdgeInsets.all(4),
                ),
              ))
        ],
      ),
    );
  }
}

//====================================================//

class TeamUpperPortion extends StatelessWidget {
  final data, title;
  const TeamUpperPortion({Key? key, this.title, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                  padding: EdgeInsets.only(top: 35),
                  child: ListTile(
                    title: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Icon(Icons.arrow_back_ios_new,
                              color: Colors.white, size: 19),
                          SizedBox(width: 20),
                          Text(
                            title,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                  ),
                  height: 180,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                          tileMode: TileMode.clamp,
                          begin: Alignment.topCenter,
                          end: Alignment(0, -13.0),
                          colors: const [purpleLight, purpleDark])))),
          Positioned(
            top: 135,
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
              top: 95,
              left: 35,
              child: Container(
                height: 100,
                width: 100,
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(100),
                    child: data['imagePath'] != null || data['imagePath'] != ""
                        ? CachedNetworkImage(
                            imageUrl: data['imagePath'],
                            fit: BoxFit.cover,
                            height: 94,
                            width: 94,
                            progressIndicatorBuilder:
                                (context, url, downloadProgress) =>
                                    CircularProgressIndicator(
                              value: downloadProgress.progress,
                              color: Colors.white,
                            ),
                            errorWidget: (context, url, error) =>
                                const Icon(Icons.error),
                          )
                        : Image.asset(
                            'assets/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                  ),
                ),
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.white),
                padding: EdgeInsets.all(4),
              ))
        ],
      ),
    );
  }
}

class ProfilePic extends StatefulWidget {
  ProfilePic({Key? key}) : super(key: key);

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
                    Text(empName,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text("Employee Id: ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                                fontSize: 14)),
                        Text(empId == "" ? " Nill" : empId,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                color: Colors.grey.shade600,
                                fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(department ?? "Department: Nill",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(height: 5),
                    Text(designation ?? "Designation: Nill",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

class TeamProfile extends StatefulWidget {
  final data;
  const TeamProfile({this.data, Key? key}) : super(key: key);

  @override
  State<TeamProfile> createState() => _TeamProfileState();
}

class _TeamProfileState extends State<TeamProfile> {
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
                    Text(widget.data['displayName'],
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            fontFamily: "Poppins",
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                    SizedBox(height: 5),
                    Row(
                      children: [
                        Text("Employee Id: ",
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                                color: Colors.grey.shade600,
                                fontSize: 14)),
                        Text(empId == "" ? " Nill" : empId,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontFamily: "Poppins",
                                color: Colors.grey.shade600,
                                fontSize: 14)),
                      ],
                    ),
                    SizedBox(height: 5),
                    Text(widget.data['department'] ?? "Department: Nill",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        )),
                    SizedBox(height: 5),
                    Text(widget.data['designation'] ?? "Designation: Nill",
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.grey.shade600,
                          fontFamily: "Poppins",
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        )),
                  ]),
            ),
          ),
        ],
      ),
    );
  }
}

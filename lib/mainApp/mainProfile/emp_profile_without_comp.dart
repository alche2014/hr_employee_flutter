// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Dailog/loading2.dart';
import 'package:hr_app/Notification/screen_notification.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/Login/auth.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:hr_app/mainApp/mainProfile/Card/AboutCard.dart';
import 'package:hr_app/mainApp/mainProfile/Card/AccountInfoCard.dart';
import 'package:hr_app/mainApp/mainProfile/Card/EducationCard.dart';
import 'package:hr_app/mainApp/mainProfile/Card/ExperienceCard.dart';
import 'package:hr_app/mainApp/mainProfile/Card/personal_info_card.dart';
import 'package:hr_app/mainApp/mainProfile/Card/work_info_card.dart';
import 'package:hr_app/mainApp/mainProfile/Dependent/screen_dependent.dart';
import 'package:hr_app/mainApp/personal_Info/main_personal_info.dart';
import 'package:shimmer/shimmer.dart';
import 'Card/skillsCard.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:open_file/open_file.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;

class EmpProfileWithoutComp extends StatefulWidget {
  final userId;
  const EmpProfileWithoutComp({Key? key, this.userId}) : super(key: key);

  @override
  _EmpProfileWithoutCompState createState() => _EmpProfileWithoutCompState();
}

class _EmpProfileWithoutCompState extends State<EmpProfileWithoutComp> {
  Connectivity? connectivity;

  late StreamSubscription<ConnectivityResult> subscription;

  bool isNetwork = true;

  late File _image;

  //  late  FirebaseUser  firebaseUser;

  late String user;

  late Stream? stream;

  // late Map<String, String>? _paths;

  late List<String>? _extension;

  late FileType? _pickType;

  bool _multiPick = true;

  List<UploadTask>? _tasks = <UploadTask>[];

  late String? urlList;
  late bool _com;
  late String? value;
  loadFirebaseUser() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    user = firebaseUser!.uid;
    print("Firebase User Id :: ${firebaseUser.uid}");
    //  checking user exists or not
    final Emp = FirebaseAuth.instance.currentUser!;
    _com = await AuthService().userExist(Emp);
  }

  Future<Stream> load() async {
    auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
    DocumentReference collectionReference =
        FirebaseFirestore.instance.collection('guests').doc(firebaseUser!.uid);
    Stream<DocumentSnapshot> query = collectionReference.snapshots();
    return query;
  }

  @override
  void initState() {
    super.initState();
    loadFirebaseUser().whenComplete(() {
      setState(() {});
    });

    // loadFirebaseUser();
    //check internet connection
    connectivity = new Connectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
      print(result.toString());
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
    stream = null;
    loadData();
  }

  loadData() async {
    if (mounted) {
      setState(() {
        // make changes here
      });
    }

    //  setState(() {});
    loadFirebaseUser();
    stream = await load();
  }

  auth.User? firebaseUser = auth.FirebaseAuth.instance.currentUser;
  static Reference storage = FirebaseStorage.instance.ref();

  upload(fileName, filePath) async {
    _extension = fileName.toString().split('.').last as List<String>?;
    // StorageReference storageRef = FirebaseStorage.instance
    //     .ref()
    //     .child("Documents/${fileName + hashCode.toString()}");
    // final StorageUploadTask uploadTask = storageRef.putFile(
    //   File(filePath),
    // StorageMetadata(
    //   contentType: '$_pickType/$_extension',
    // ),
    // );
    Reference upload =
        storage.child(("Documents/${fileName + hashCode.toString()}"));
    UploadTask uploadTask = upload.putFile(filePath);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();

    urlList = await (await uploadTask).ref.getDownloadURL();
    Map<String, dynamic> serializedMessage = {
      "docName": fileName,
      "docUrl": urlList,
    };

    await FirebaseFirestore.instance
        .collection("guests")
        .doc(firebaseUser!.uid)
        .update({
      "empDocs": FieldValue.arrayUnion([serializedMessage])
    });
    setState(() {
      _tasks!.add(uploadTask);
    });
    return downloadUrl.toString();
  }

  var imgUrl;

  var dio = Dio();

  String? _openResult = 'Unknown';

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
  }

  String? fullPath;

  void showDownloadProgress(received, total) {
    if (total != -1) {
      print("${(received / total * 100).toStringAsFixed(0) + "%"}");
    }
  }

  void showLoadingDialog(BuildContext context, String value) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            LoadingDialog2(value: value)));
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        iconTheme: const IconThemeData(),
        toolbarTextStyle: TextStyle(
          color: isdarkmode.value == false ? Colors.grey : Colors.white,
        ),
        title: Text(
          'Profiless',
          style: TextStyle(
              color: isdarkmode.value == false
                  ? Colors.grey.shade500
                  : Colors.white),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context, rootNavigator: true).push(MaterialPageRoute(
                  builder: (context) => Notifications(uid: firebaseUser!.uid)));
            },
            icon: Icon(Icons.notifications,
                color: isdarkmode.value == false
                    ? Colors.grey.shade500
                    : Colors.white),
          ),
        ],
      ),
      body: Container(
        child: stream == null
            ? _shimmer()
            : StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("guests")
                    .doc(firebaseUser!.uid)
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return Center(child: CircularProgressIndicator());
                  } else if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator());
                  }

                  return SingleChildScrollView(
                      child: Column(children: [
                    UpperPortion(data: snapshot.data!.data()),
                    //=====================================//
                    AboutCard(data: snapshot.data!.data()),
                    // WorkInfoCard(data: snapshot.data!.data()),
                    SkillsCard(data: snapshot.data!.data()),
                    ExperienceCard(data: snapshot.data!.data()),
                    EducationCard(data: snapshot.data!.data()),
                    PersonalInfoCard(data: snapshot.data!.data()),
                    AccountInfoCard(data: snapshot.data!.data()),
                    SizedBox(height: 30),

                    //------------------Dependent----------------------------
                    Container(
                      margin:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        border: Border.all(
                            width: 1, color: Colors.grey.withOpacity(0.2)),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          //-----------Heading------------
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Dependent',
                                style: TextStyle(
                                  color: kPrimaryColor,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 16,
                                  fontStyle: FontStyle.normal,
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.edit_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => Dependent(
                                                dependent:
                                                    snapshot.data!.data())));
                                  }),
                            ],
                          ),

                          //------------Body----------
                          dependent(snapshot.data!.data())
                        ],
                      ),
                    )
                  ]));
                }),
      ),
    );
  }

  Widget _shimmer() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
      child: Shimmer.fromColors(
        baseColor: Color(0xFFE0E0E0),
        highlightColor: Color(0xFFF5F5F5),
        child: Column(
          children: [0]
              .map((_) => Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Container(
                    padding: EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                        color: Colors.white24,
                        borderRadius: BorderRadius.circular(4.0)),
                    height: 100,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(top: 30, left: 30),
                          width: 48.0,
                          height: 48.0,
                          decoration: BoxDecoration(
                              color: Colors.green,
                              border: Border.all(),
                              borderRadius: BorderRadius.circular(50.0)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                margin: EdgeInsets.only(top: 4.0),
                                color: Colors.white,
                                width: double.infinity,
                                height: 8.0,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: Colors.white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 2.0),
                              ),
                              Container(
                                width: 40.0,
                                height: 8.0,
                                color: Colors.white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )))
              .toList(),
        ),
      ),
    );
  }

  Widget dependent(snapshot) {
    return Container(
        // width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.only(top: 10),
        padding: const EdgeInsets.only(bottom: 15, left: 8, right: 8),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 6, left: 5),
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
                            fontStyle: FontStyle.normal,
                            fontFamily: "Sofia Pro",
                            fontSize: 14),
                      ),
                    ),
                    Expanded(
                      flex: 7,
                      child: Container(
                        margin: const EdgeInsets.only(left: 10),
                        child: Text(
                          snapshot["depCompName"] ?? "Name",
                          style: TextStyle(
                              color: snapshot["depCompName"] == null
                                  ? Colors.grey[500]
                                  : Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 6, left: 5),
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
                            fontStyle: FontStyle.normal,
                            fontFamily: "Sofia Pro",
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
                                  : Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 6, bottom: 6, left: 5),
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
                            fontStyle: FontStyle.normal,
                            fontFamily: "Sofia Pro",
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
                                  : Colors.black54,
                              fontWeight: FontWeight.w400,
                              fontSize: 15),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ]));

    // });
  }
}

//===============================================//
class UpperPortion extends StatelessWidget {
  final data;
  const UpperPortion({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.30,
      child: Stack(
        children: [
          //--------------backimage-----------------//
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.30,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/foggy.jpg'),
                fit: BoxFit.cover,
              )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfilePic(data: data),
                          // IconButton(
                          //     onPressed: () {
                          //       Navigator.push(
                          //           context,
                          //           MaterialPageRoute(
                          //               builder: (context) =>
                          //                   MainPersonal_Info()));
                          //     },
                          //     icon: Icon(Icons.edit_outlined,
                          //         size: 30, color: Colors.white)),
                        ]),
                  ],
                ),
              ),
            ),
          ),
          //--------------backimage-end-----------------//

          //--------------mainWhite-Back-of-CenterCard---------------//
          Positioned(
            top: MediaQuery.of(context).size.height * 0.25,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          //-------------mainWhite--end-Back-of-CenterCard----------//
        ],
      ),
    );
  }
}

//====================================================//

class ProfilePic extends StatelessWidget {
  final data;
  const ProfilePic({Key? key, this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Row(children: [
          SizedBox(width: 10),
          data["imagePath"] != null
              ? CircleAvatar(
                  radius: 40,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(100),
                    child: Image(
                      image: NetworkImage(data["imagePath"]),
                      // FileImage(File(imagePath)),
                      height: 114,
                      width: 115,
                      fit: BoxFit.cover,
                      //  ),
                    ),
                  ))
              : CircleAvatar(
                  radius: 50,
                  child: ClipRRect(
                    clipBehavior: Clip.antiAlias,
                    borderRadius: BorderRadius.circular(100),
                    child: Image.asset(
                      "assets/user_image.png",
                      height: 114,
                      width: 115,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
          SizedBox(width: 15),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(data['name'],
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text(data['email'],
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.white,
                )),
          ]),
        ]),
      ),
    );
  }
}

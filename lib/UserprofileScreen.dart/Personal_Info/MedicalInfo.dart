import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/Constants/constants.dart';

// employee add his/her personal information in this screen

class MedicalInfo extends StatefulWidget {
  final data;
  const MedicalInfo({Key? key, this.data}) : super(key: key);
  @override
  _MedicalInfoState createState() => _MedicalInfoState();
}

class _MedicalInfoState extends State<MedicalInfo> {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String? userId;
  final FocusNode cityFocus = FocusNode();
  TextEditingController healthController = TextEditingController();
  TextEditingController medicalidController = TextEditingController();
  TextEditingController bloodgroupController = TextEditingController();
  TextEditingController diseaseController = TextEditingController();
  TextEditingController allergyController = TextEditingController();

  ScrollController? con;

  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {});
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {});
      }
    });

    userId = widget.data["uid"];

    bloodgroupController = TextEditingController(
        text:
            widget.data["bloodGroup"] == null || widget.data["bloodGroup"] == ""
                ? ""
                : widget.data["bloodGroup"]);

    medicalidController = TextEditingController(
        text: widget.data["medicalId"] == null || widget.data["medicalId"] == ""
            ? ""
            : widget.data["medicalId"]);
    allergyController = TextEditingController(
        text: widget.data["allergy"] == null || widget.data["allergy"] == ""
            ? ""
            : widget.data["allergy"]);
    diseaseController = TextEditingController(
        text: widget.data["disease"] == null || widget.data["disease"] == ""
            ? ""
            : widget.data["disease"]);

    healthController = TextEditingController(
        text: widget.data["healthCondition"] == null ||
                widget.data["healthCondition"] == ''
            ? ""
            : widget.data["healthCondition"]);

    con = ScrollController();
    con!.addListener(() {
      if (con!.offset >= con!.position.maxScrollExtent &&
          !con!.position.outOfRange) {
        setState(() {});
      } else if (con!.offset <= con!.position.minScrollExtent &&
          !con!.position.outOfRange) {
        setState(() {});
      } else {
        setState(() {});
      }
    });
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
        appBar: buildMyAppBar(context, 'Medical Information', true),
        body: Container(
            margin: const EdgeInsets.all(15),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const SizedBox(height: 15),
                    Text("  Medical Card ID", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: medicalidController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Medical Card ID'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      keyboardType: TextInputType.text,
                    ),
                    const SizedBox(height: 15),
                    Text("  Blood Group", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: bloodgroupController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Blood Group'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Text("  Health Condition", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: healthController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration(' Health Condition'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Text("  Any Disease", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: diseaseController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Disease'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Text("  Any Allergies", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: allergyController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Allergy'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    saveButton(context, onpress)
                  ],
                ),
              ),
            )));
  }

  onpress() {
    if (medicalidController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text('Medical Card Id is empty',
              style: TextStyle(color: Colors.black)),
        ),
      );
    } else {
      validateAndSave();
    }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }

  validateAndSave() async {
    int guest = 0;
    final user = FirebaseAuth.instance.currentUser!;

    await FirebaseFirestore.instance
        .collection("employees") //your collectionref
        .where('uid', isEqualTo: user.uid)
        .get()
        .then((value) {
      // var count = 0;
      guest = value.docs.length;
    });
    final form = _formKey.currentState;
    if (form!.validate()) {
      showLoadingDialog(context);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference reference = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(userId)
            : FirebaseFirestore.instance.collection("employees").doc(userId);
        await reference.update({
          "medicalId": medicalidController.text.isEmpty
              ? "null"
              : medicalidController.text,
          "bloodGroup": bloodgroupController.text == ""
              ? null
              : bloodgroupController.text,
          "allergy":
              allergyController.text == "" ? null : allergyController.text,
          "disease":
              diseaseController.text == "" ? null : diseaseController.text,
          "healthCondition":
              healthController.text == "" ? null : healthController.text,
        });
      }).whenComplete(() {
        Navigator.pop(context);

        Fluttertoast.showToast(
            msg: "Medical Information is added successfully");
        Navigator.pop(context);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e);
      });
    }
  }
}

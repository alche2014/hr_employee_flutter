import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/main.dart';

// employee add his/her personal information in this screen
enum Gender { male, female }

class ContactInfo extends StatefulWidget {
  final data;
  const ContactInfo({Key? key, this.data}) : super(key: key);
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String? cityName;
  var defaultCode = "+92";
  final FocusNode cityFocus = FocusNode();
  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController cityController = TextEditingController();
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

    defaultCode = widget.data["phone"] == null || widget.data["phone"] == ""
        ? "+92"
        : widget.data["phone"].split(" ")[0];

    phoneController = TextEditingController(
        text: widget.data["phone"] == null || widget.data["phone"] == ""
            ? ""
            : widget.data["phone"].split(" ")[1]);
    emailController = TextEditingController(
        text:
            widget.data["otherEmail"] == null || widget.data["otherEmail"] == ""
                ? ""
                : widget.data["otherEmail"]);

    cityController = TextEditingController(
        text: widget.data["cityName"] == null || widget.data["cityName"] == ""
            ? ""
            : widget.data["cityName"]);

    addressController = TextEditingController(
        text: widget.data["address"] == null || widget.data["address"] == ''
            ? ""
            : widget.data["address"]);

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
        appBar: buildMyAppBar(context, 'Contact Details', true),
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
                    Text("  Email", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      controller: emailController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Email'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        String pattern =
                            r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                        RegExp regex = RegExp(pattern);
                        if (!regex.hasMatch(value ?? '')) {
                          return 'Enter valid email';
                        } else {
                          return null;
                        }
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),
                    const SizedBox(height: 15),
                    Text("  Phone", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        style: TextFieldTextStyle(),
                        decoration: TextPhoneFieldDecoration(defaultCode)),
                    const SizedBox(height: 15),
                    Text("  City", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: cityController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('City'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Text("  Permanent Address", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: addressController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Permanent Address'),
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
    if (emailController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content:
              Text('Email is empty', style: TextStyle(color: Colors.black)),
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
    final form = _formKey.currentState;
    if (form!.validate()) {
      showLoadingDialog(context);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference reference = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(uid)
            : FirebaseFirestore.instance.collection("employees").doc(uid);
        await reference.update({
          "phone": phoneController.text.isEmpty
              ? null
              : defaultCode + " " + phoneController.text,
          "cityName": cityController.text == "" ? null : cityController.text,
          "address":
              addressController.text == "" ? null : addressController.text,
          "otherEmail": emailController.text == "" ? null : emailController.text
        });
      }).whenComplete(() {
        Navigator.pop(context);

        Fluttertoast.showToast(msg: "Contact detail is added successfully");
        Navigator.pop(context);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e);
      });
    }
  }
}

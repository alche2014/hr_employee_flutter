import 'dart:async';
import 'dart:io';

// import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import '../../colors.dart';

// employee add his/her personal information in this screen
class BankdataInfo extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final data;
  const BankdataInfo({Key? key, this.data}) : super(key: key);
  @override
  _BankdataInfoState createState() => _BankdataInfoState();
}

class _BankdataInfoState extends State<BankdataInfo> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late String bankName;
  late String bankNumber;
  late String userId;
  TextEditingController bankNameController = TextEditingController();
  TextEditingController bankNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = widget.data["uid"];
    bankNumberController = TextEditingController(text: widget.data["bankNo"]);
    bankNameController = TextEditingController(text: widget.data["bnkName"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Bank Information', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Form(
            key: _formKey,
            child: Container(
              margin: Platform.isIOS
                  ? const EdgeInsets.only(
                      left: 15, right: 12, bottom: 50, top: 120)
                  : const EdgeInsets.only(
                      left: 15, right: 12, bottom: 15, top: 90),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: bankNameController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Bank Name'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        const pattern = ('[a-zA-Z]+([s][a-zA-Z]+)*');
                        final regExp = RegExp(pattern);
                        if (value!.isEmpty) {
                          return null;
                        } else if (!regExp.hasMatch(value)) {
                          return 'Enter a Valid Name';
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.next,
                      controller: bankNumberController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Account Number'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Enter a number";
                        } else {
                          return null;
                        }
                      },
                    ),
                    const SizedBox(height: 65),
                  ],
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 12, bottom: 15),
              width: MediaQuery.of(context).size.width,
              height: 55,
              child: ElevatedButton(
                child: const Text('SAVE'), //next button
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  primary: darkRed,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                onPressed: () {
                  validateAndSave();
                },
              ),
            ),
          )
        ],
      ),
    );
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    int guest = 0;
    if (form!.validate()) {
      showLoadingDialog(context);
      final user = FirebaseAuth.instance.currentUser!;
      await FirebaseFirestore.instance
          .collection("employees")
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        guest = value.docs.length;
      });
      if (guest == 0) {
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          DocumentReference reference =
              FirebaseFirestore.instance.collection("guests").doc(user.uid);
          await reference.update({
            "bnkName":
                bankNameController.text == "" ? null : bankNameController.text,
            "bankNo": bankNumberController.text == ""
                ? null
                : bankNumberController.text,
          });
        }).whenComplete(() {
          Fluttertoast.showToast(msg: "Account info is updated successfully");
          Navigator.of(context).pop();
        }).catchError((e) {
          print('======Error====$e==== ');
        });
        Future.delayed(const Duration(milliseconds: 1150), () {
          Navigator.of(context).pop();
        });
      } else {
        FirebaseFirestore.instance
            .runTransaction((Transaction transaction) async {
          DocumentReference reference =
              FirebaseFirestore.instance.collection("employees").doc(user.uid);
          await reference.update({
            "bnkName":
                bankNameController.text == "" ? null : bankNameController.text,
            "bankNo": bankNumberController.text == ""
                ? null
                : bankNumberController.text,
          });
        }).whenComplete(() {
          Fluttertoast.showToast(msg: "Account info is updated successfully");
          Navigator.of(context).pop();
        }).catchError((e) {
          print('======Error====$e==== ');
        });
        Future.delayed(const Duration(milliseconds: 1150), () {
          Navigator.of(context).pop();
        });
      }
    } else {
      print('form is invalid');
    }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }
}

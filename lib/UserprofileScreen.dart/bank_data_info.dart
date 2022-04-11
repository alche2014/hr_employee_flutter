import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/UserprofileScreen.dart/appbar.dart';
import 'package:hr_app/Constants/constants.dart';

// employee add his/her bank information in this screen
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
  TextEditingController ibanController = TextEditingController();
  TextEditingController bankNumberController = TextEditingController();
  TextEditingController accountTitleController = TextEditingController();
  TextEditingController branchCodeController = TextEditingController();
  TextEditingController bankBranchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userId = widget.data["uid"];
    bankNumberController = TextEditingController(text: widget.data["bankNo"]);
    bankNameController = TextEditingController(text: widget.data["bnkName"]);
    ibanController = TextEditingController(text: widget.data["iban"]);
    bankBranchController =
        TextEditingController(text: widget.data["bankBranch"]);
    branchCodeController =
        TextEditingController(text: widget.data["branchCode"]);
    accountTitleController =
        TextEditingController(text: widget.data["accountTitle"]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.grey.shade100,
        appBar: buildMyAppBar(context, 'Bank Info', false),
        body: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.all(15),
            child: SingleChildScrollView(
                child: Form(
                    key: _formKey,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("  Bank Name", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            controller: bankNameController,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Bank Name'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
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
                          const SizedBox(height: 15),
                          Text("  Bank Number", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            controller: ibanController,
                            keyboardType: TextInputType.phone,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Bank Number'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          Text("  IBAN no", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            keyboardType: TextInputType.number,
                            controller: bankNumberController,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('IBAN No'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return "Enter a number";
                              } else {
                                return null;
                              }
                            },
                          ),
                          const SizedBox(height: 15),
                          Text("  Bank Branch", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            controller: bankBranchController,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Bank Branch'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 15),
                          Text("  Branch Code", style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            controller: branchCodeController,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Branch Code'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 15),
                          Text("  Account Title",
                              style: TextFieldHeadingStyle()),
                          const SizedBox(height: 10),
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.done,
                            keyboardType: TextInputType.text,
                            controller: accountTitleController,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Account Title'),
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                          ),
                          const SizedBox(height: 15),
                          saveButton(context, onpress)
                        ])))));
  }

  onpress() {
    if (bankNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content:
              Text('Bank Name is empty', style: TextStyle(color: Colors.black)),
        ),
      );
    } else {
      validateAndSave();
    }
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      int guest = 0;
      final user = FirebaseAuth.instance.currentUser!;

      await FirebaseFirestore.instance
          .collection("employees")
          .where('uid', isEqualTo: user.uid)
          .get()
          .then((value) {
        guest = value.docs.length;
      });
      showLoadingDialog(context);

      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference reference = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(userId)
            : FirebaseFirestore.instance.collection("employees").doc(userId);
        await reference.update({
          "bnkName":
              bankNameController.text == "" ? null : bankNameController.text,
          "bankNo": bankNumberController.text == ""
              ? null
              : bankNumberController.text,
          "iban": ibanController.text == "" ? null : ibanController.text,
          "bankBranch": bankBranchController.text == ""
              ? null
              : bankBranchController.text,
          "branchCode": branchCodeController.text == ""
              ? null
              : branchCodeController.text,
          "accountTitle": accountTitleController.text == ""
              ? null
              : accountTitleController.text,
        });
      }).whenComplete(() {
        // Navigator.pop(context);

        Fluttertoast.showToast(msg: "Account info is updated successfully");
      }).catchError((e) {});
      Future.delayed(const Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
      // }
    } else {}
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) =>
            const LoadingDialog(value: "Loading")));
  }
}

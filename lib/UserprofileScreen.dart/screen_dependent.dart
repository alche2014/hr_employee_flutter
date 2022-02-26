import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/constants.dart';

class Dependent extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final dependent;
  const Dependent({this.dependent, Key? key}) : super(key: key);

  @override
  State<Dependent> createState() => _DependentState();
}

class _DependentState extends State<Dependent> {
  TextEditingController _controller1 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  var defaultCode = "+92";

  late String userId;
  late String phone;
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  late ScrollController con;
  var _dropdownValue;
  String selectRelation = "Relation";
  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
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
    userId = widget.dependent["uid"];
    _controller1 = TextEditingController(text: widget.dependent["depName"]);

    selectRelation = widget.dependent["relation"];
    phoneController = TextEditingController(text: widget.dependent["depPhone"]);
    defaultCode = widget.dependent["depPhone"] == null ||
            widget.dependent["depPhone"] == ""
        ? "+92"
        : widget.dependent["depPhone"].split(" ")[0];

    phoneController = TextEditingController(
        text: widget.dependent["depPhone"] == null ||
                widget.dependent["depPhone"] == ""
            ? ""
            : widget.dependent["depPhone"].split(" ")[1]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildMyAppBar(context, 'Emergency Contact', false),
        body: Stack(children: [
          Container(
              height: MediaQuery.of(context).size.height,
              margin: const EdgeInsets.only(
                  bottom: 50, top: 15, left: 15, right: 10),
              child: SingleChildScrollView(
                  child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            textCapitalization: TextCapitalization.sentences,
                            textInputAction: TextInputAction.next,
                            controller: _controller1,
                            style: TextFieldTextStyle(),
                            decoration: TextFieldDecoration('Name'),
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
                          const SizedBox(height: 10),

                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(5),
                                border: Border.all(
                                    color: Colors.grey.shade300, width: 1)),
                            child: DropdownButtonFormField<String>(
                              decoration: const InputDecoration(
                                  contentPadding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(5),
                                    ),
                                  ),
                                  hintText: "Relation",
                                  hintStyle: TextStyle(
                                      fontSize: 14, color: Colors.grey),
                                  filled: true,
                                  fillColor: Colors.transparent),
                              value: selectRelation,
                              items: <String>[
                                'Brother',
                                'Sister',
                                'Father',
                                'Mother',
                                'Spouse',
                                'Daughter',
                                'Son',
                              ].map<DropdownMenuItem<String>>(
                                (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                },
                              ).toList(),
                              onChanged: (String? newValue) {
                                setState(() {
                                  // _dropdownValue = newValue;
                                  selectRelation = newValue!;
                                });
                              },
                            ),
                          ),
                          const SizedBox(height: 10),
//---------------------textfield-----------------------------
                          TextFormField(
                            keyboardType: TextInputType.phone,
                            textInputAction: TextInputAction.next,
                            controller: phoneController,
                            style: TextFieldTextStyle(),
                            decoration: InputDecoration(
                              isDense: true,
                              prefix: CountryCodePicker(
                                  initialSelection: defaultCode,
                                  padding: const EdgeInsets.all(0),
                                  onChanged: (CountryCode? selectedValue) {
                                    defaultCode =
                                        selectedValue!.dialCode.toString();
                                  },
                                  hideSearch: false,
                                  showCountryOnly: false,
                                  showOnlyCountryWhenClosed: false,
                                  alignLeft: false),
                              contentPadding: const EdgeInsets.only(
                                  bottom: 15, top: -5, left: 15),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey.shade300),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    color: Colors.grey.shade300, width: 1),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                                borderSide: BorderSide(
                                    width: 1, color: Colors.grey.shade300),
                              ),
                              labelText: 'Phone',
                              labelStyle: const TextStyle(color: Colors.grey),
                            ),
                          ),

                          const SizedBox(height: 65),
                        ],
                      )))),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: const EdgeInsets.only(left: 15, right: 12, bottom: 15),
              width: MediaQuery.of(context).size.width,
              height: 55,
              child: ElevatedButton(
                onPressed: () {
                  validateAndSave();
                },
                style: ElevatedButton.styleFrom(
                  primary: kPrimaryColor,
                  padding: const EdgeInsets.symmetric(
                    vertical: 20,
                  ),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5)),
                ),
                child: const Text(
                  'Save',
                ),
              ),
            ),
          ),
        ]));
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    if (form!.validate()) {
      // ignore: prefer_const_constructors
      if (selectRelation == "Relation") {
        const SnackBar(
            content: Text("Kindly Select Relation",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)));
      } else {
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
        showLoadingDialog(context);

        DocumentReference addEmpDep = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(userId)
            : FirebaseFirestore.instance.collection("employees").doc(userId);
        addEmpDep.update({
          "depName": _controller1.text.isEmpty
              ? ''
              : _controller1.text[0].toUpperCase() +
                  _controller1.text.substring(1).toString(),
          "depPhone": phoneController.text.isEmpty
              ? ''
              : defaultCode + " " + phoneController.text,
          "relation": selectRelation,
        }).whenComplete(() {
          Navigator.of(context).pop();
          Future.delayed(const Duration(milliseconds: 1050), () {
            Navigator.of(context).pop();
            Fluttertoast.showToast(
                msg: "Emergency Contact is added successfully");
          });
        });
      }
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

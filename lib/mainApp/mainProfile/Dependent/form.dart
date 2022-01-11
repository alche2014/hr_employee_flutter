import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/mainApp/Login/auth.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:hr_app/mainApp/work_info/utility/build_my_input_decoration.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:country_code_picker/country_code_picker.dart';

class DependentForm extends StatefulWidget {
  final dependent;
  const DependentForm({this.dependent, Key? key}) : super(key: key);

  @override
  _DependentFormState createState() => _DependentFormState();
}

class _DependentFormState extends State<DependentForm> {
  TextEditingController _controller1 = TextEditingController();
  TextEditingController _controller2 = TextEditingController();
  TextEditingController _controller3 = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  TextEditingController phoneController = TextEditingController();
  final maskFormatter = MaskTextInputFormatter(mask: '+92 ### ### ####');
  late FocusNode _phoneFocus;

  late String userId;
  late String phone;
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  late ScrollController con;

  var _dropdownValue;
  String selectRelation = " ";
  var defaultCode = "+92";

  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
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
    userId = widget.dependent["uid"];
    con = ScrollController();
    con.addListener(() {
      if (con.offset >= con.position.maxScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else if (con.offset <= con.position.minScrollExtent &&
          !con.position.outOfRange) {
        setState(() {});
      } else {
        setState(() {});
      }
    });

    _controller1 = TextEditingController(
      text: widget.dependent["depName"],
    );
    _controller2 = TextEditingController(
      text: widget.dependent["depCompName"],
    );
    _controller3 =
        TextEditingController(text: widget.dependent["depDescription"]);

    selectRelation = widget.dependent["relation"];
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
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                style: TextFieldTextStyle(),
                decoration: TextFieldDecoration('Namess'),
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
              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    border: Border.all(color: Colors.grey.shade300, width: 1)),
                child: DropdownButtonFormField<String>(
                  decoration: const InputDecoration(
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 10, vertical: 0),
                      border: OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(5),
                        ),
                      ),
                      labelText: "Role",
                      labelStyle: TextStyle(fontSize: 14, color: Colors.grey),
                      filled: true,
                      fillColor: Colors.white),
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
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                controller: _controller2,
                style: TextFieldTextStyle(),
                decoration: TextFieldDecoration('Company Name'),
              ),
              const SizedBox(height: 10),

              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                controller: phoneController,
                style: TextFieldTextStyle(),
                decoration: InputDecoration(
                  prefix: CountryCodePicker(
                      initialSelection: defaultCode,
                      padding: EdgeInsets.all(0),
                      onChanged: (CountryCode? selectedValue) {
                        defaultCode = selectedValue!.dialCode.toString();
                      },
                      hideSearch: false,
                      showCountryOnly: false,
                      showOnlyCountryWhenClosed: false,
                      alignLeft: false),
                  contentPadding:
                      EdgeInsets.only(bottom: 15, top: -5, left: 15),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey.shade300),
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(color: Colors.grey.shade300, width: 1),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                    borderSide:
                        BorderSide(width: 1, color: Colors.grey.shade300),
                  ),
                  labelText: 'Phone',
                  labelStyle: const TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                textCapitalization: TextCapitalization.sentences,
                controller: _controller3,
                style: TextFieldTextStyle(),
                maxLines: 4,
                decoration: TextFieldDecoration('Description'),
              ),
            ],
          ),
          //--------------------Save button---------------------
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              onPressed: () {
                // if (_controller1.text.isNotEmpty ||
                //     _controller2.text.isNotEmpty ||
                //     _controller3.text.isNotEmpty ||
                //     _dropdownValue != null) {
                // Navigator.of(context).pop();
                validateAndSave();
                // print("object:::::::::::::::::${_controller1.text}");
                //   }
                //  else {
                //   ScaffoldMessenger.of(context).showSnackBar(
                //     const SnackBar(
                //       content: Text('Complete the Form.'),
                //     ),
                //   );
                // }
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
        ],
      ),
    );
  }

//when user clicks on save button
  validateAndSave() async {
    final form = _formKey.currentState;
    int guest = 0;
    if (form!.validate()) {
      // ignore: prefer_const_constructors
      if (selectRelation == "Relation") {
        SnackBar(
            content: Text("Kindly Select Relation",
                style: TextStyle(
                    fontSize: 15,
                    color: Colors.white,
                    fontWeight: FontWeight.w500)));
      } else {
        showLoadingDialog(context);
        final user = FirebaseAuth.instance.currentUser!;
        await FirebaseFirestore.instance
            .collection("employees") //your collectionref
            .where('uid', isEqualTo: user.uid)
            .get()
            .then((value) {
          // var count = 0;
          guest = value.docs.length;
        });
        if (guest == 0) {
          DocumentReference addDepGuest =
              FirebaseFirestore.instance.collection("guests").doc(user.uid);
          addDepGuest.update({
            "depName": _controller1.text[0].toUpperCase() +
                _controller1.text.substring(1).toString(),
            "depCompName": _controller2.text[0].toUpperCase() +
                _controller2.text.substring(1).toString(),
            "Depdescription": _controller3.text[0].toUpperCase() +
                _controller3.text.substring(1).toString(),
            "depPhone": phoneController.text.isEmpty
                ? ''
                : defaultCode + " " + phoneController.text,
            "relation": selectRelation,
          }).whenComplete(() {
            Navigator.of(context).pop();

            Future.delayed(const Duration(milliseconds: 1050), () {
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "Dependent is added successfully");
            });
          });
        } else {
          DocumentReference addEmpDep =
              FirebaseFirestore.instance.collection("employees").doc(user.uid);
          addEmpDep.update({
            "depName": _controller1.text.isEmpty
                ? ''
                : _controller1.text[0].toUpperCase() +
                    _controller1.text.substring(1).toString(),
            "depCompName": _controller2.text.isEmpty
                ? ''
                : _controller2.text[0].toUpperCase() +
                    _controller2.text.substring(1).toString(),
            "depDescription": _controller3.text.isEmpty
                ? ''
                : _controller3.text[0].toUpperCase() +
                    _controller3.text.substring(1).toString(),
            "depPhone": phoneController.text.isEmpty
                ? ''
                : defaultCode + " " + phoneController.text,
            "relation": selectRelation,
          }).whenComplete(() {
            Navigator.of(context).pop();
            Future.delayed(const Duration(milliseconds: 1050), () {
              Navigator.of(context).pop();
              Fluttertoast.showToast(msg: "Dependent is added successfully");
            });
          });
        }
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

  String? validateName(String value) {
    if (value.isEmpty) {
      return "Name can't be empty";
    } else {
      return null;
    }
  }
}

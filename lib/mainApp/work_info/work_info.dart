// ignore_for_file: prefer_typing_uninitialized_variables, unnecessary_new, prefer_const_declarations, prefer_const_constructors

import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:hr_app/mainApp/work_info/utility/build_my_input_decoration.dart';
import 'package:hr_app/widgets/ExpansionPanel.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class MyWorkInfo extends StatefulWidget {
  const MyWorkInfo({Key? key}) : super(key: key);

  @override
  _MyWorkInfoState createState() => _MyWorkInfoState();
}

class _MyWorkInfoState extends State<MyWorkInfo> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      // appBar: buildMyAppBar(context, 'Work Info', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'Work Info', true),
            ],
            body: SingleChildScrollView(
              child: Column(
                children: [
                  // const SizedBox(height: 80),
                  //===============================================//
                  Center(
                    child: Stack(
                      //using stack to lap edit icon over Picture
                      children: const [
                        ClipRRect(
                          child: Image(
                            height: 100,
                            image: AssetImage('assets/user_image.png'),
                          ),
                        ),
                        Positioned(
                            bottom: 10,
                            right: 0,
                            child: Image(
                              image: AssetImage('assets/custom/Vector.png'),
                              width: 30,
                              fit: BoxFit.cover,
                            )),
                      ],
                    ),
                  ),
                  //===========================================//
                  const WorkForm(),
                  //===========================================//

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//========================================================//

class WorkForm extends StatefulWidget {
  const WorkForm({Key? key}) : super(key: key);

  @override
  _WorkFormState createState() => _WorkFormState();
}

class _WorkFormState extends State<WorkForm> {
  var dropCityValue;
  var dropGenderValue;
  var dropStatusValue;
  var dateOfBirth;

  TextEditingController controllerUserName = new TextEditingController();
  TextEditingController controllerFatherName = new TextEditingController();
  TextEditingController controllerEmail = new TextEditingController();
  TextEditingController controllerAddress = new TextEditingController();
  TextEditingController controllerPhone = new TextEditingController();
  TextEditingController controllerCNIC = new TextEditingController();

  final maskFormatter = MaskTextInputFormatter(mask: '+92 ### ### ####');
  final maskCNICFormatter = MaskTextInputFormatter(mask: '#####-#######-#');

  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<AppExpansionTileState> expansionTile = new GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile2 = new GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile3 = new GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile4 = new GlobalKey();
  final GlobalKey<AppExpansionTileState>? expansionTile5 = new GlobalKey();
  final GlobalKey<AppExpansionTileState>? expansionTile6 = new GlobalKey();
  final GlobalKey<AppExpansionTileState>? expansionTile7 = new GlobalKey();
  final GlobalKey<AppExpansionTileState>? expansionTile8 = new GlobalKey();
  final GlobalKey<AppExpansionTileState>? expansionTile9 = new GlobalKey();

  String selectReportingTo = "Reporting To";
  String? reportingToId;
  // String selectRole = "Role";
  String? selectLocation = "Location";
  String? locationId;
  String? selectDepartment = "Department";
  String? selectStatus = "Status";
  String? selectType = "Type";
  String? selectTitle = "Designation";
  String? selectShift = "Shift Schedule";
  String? selectLeave = "Leave Policy";
  String? shiftId;
  String? leaveId;
  String? depId;
  String? titleId;
  List? leaveList;

  String? role;
  String? department;
  String? reportingTo;
  List<String>? roles = [
    "COO",
    "CEO",
    "Team Lead",
    "Team Member",
    "Manager",
    "Director"
  ];

  List<String> types = [
    "Permanent",
    "On Contract",
    "Team Lead",
    "Temporary",
    "Trainee",
    "Inactive"
  ];
  List<String> empStatus = ["Active", "Terminated", "Deceased", "Resigned"];
  String? empRole;
  String? nickName;
  String? workPhone;
  String? userId;

  FocusNode _empRoleFocus = new FocusNode();
  FocusNode _nickNameFocus = new FocusNode();
  FocusNode _workPhoneFocus = new FocusNode();

  TextEditingController empRoleController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController workPhoneController = TextEditingController();

  ScrollController? con;
  var dobFormat;

  _selectDate(BuildContext context) {
    Picker(
        containerColor: isdarkmode.value ? Colors.transparent : Colors.white,
        backgroundColor: isdarkmode.value ? Colors.transparent : Colors.white,
        hideHeader: true,
        adapter: DateTimePickerAdapter(yearEnd: DateTime.now().year),
        title: Text(
          "Date of Joining",
          style: TextStyle(
            color: Color(0xFFBF2B38),
          ),
        ),
        selectedTextStyle: TextStyle(
          color: isdarkmode.value ? Colors.white : Color(0xFFBF2B38),
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            DateTime? dob = (picker.adapter as DateTimePickerAdapter).value;
            dobFormat = DateFormat('dd-MMM-yyyy').format(dob!);
          });
        }).showDialog(context);
  }

  var exitDateFormat;

  _selectExitDate(BuildContext context) {
    Picker(
        containerColor: isdarkmode.value ? Colors.transparent : Colors.white,
        backgroundColor: isdarkmode.value ? Colors.transparent : Colors.white,
        hideHeader: true,
        adapter: DateTimePickerAdapter(yearEnd: DateTime.now().year),
        title: Text(
          "Date of Exit",
          style: TextStyle(
            color: Color(0xFFBF2B38),
          ),
        ),
        selectedTextStyle: TextStyle(
          color: isdarkmode.value ? Colors.white : Color(0xFFBF2B38),
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            DateTime? dob = (picker.adapter as DateTimePickerAdapter).value;
            exitDateFormat = DateFormat('dd-MMM-yyyy').format(dob!);
          });
        }).showDialog(context);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Form(
        child: Column(
          children: [
            //=============Department==================//
            const SizedBox(height: 15),
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: TextFieldDecoration('Department'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
                final regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return null;
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter only Alphabets';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            //
            //=============Designation==================//
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: TextFieldDecoration('Designation'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
                final regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return null;
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter only Alphabets';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            //
            //=============Role=================//
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: TextFieldDecoration('Role'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
                final regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return null;
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter only Alphabets';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            //
            //=============Reporting to=================//
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: TextFieldDecoration('Reporting to'),
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                final pattern = ('[a-zA-Z]+([\s][a-zA-Z]+)*');
                final regExp = RegExp(pattern);
                if (value!.isEmpty) {
                  return null;
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter only Alphabets';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            //
            //=============Employment Status=================//
            SizedBox(
              height: 60,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300.withOpacity(0.8),
                    width: 2,
                  ),
                ),
                child: DropdownButtonFormField(
                  decoration: InputDecoration(
                      border: const OutlineInputBorder(
                        borderSide: BorderSide.none,
                        borderRadius: BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                      ),
                      hintText: "Employment Status",
                      fillColor: Theme.of(context).scaffoldBackgroundColor),
                  value: dropGenderValue,
                  items: <String>['Permanent', 'Temporary']
                      .map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      dropGenderValue = value;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 15),
            //
            //===========CNIC===============//
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              controller: controllerCNIC,
              decoration: TextFieldDecoration('CNIC No.'),
              keyboardType: TextInputType.number,
              inputFormatters: [maskCNICFormatter],
              validator: (value) {
                final regExp = RegExp('/^[0-9]{5}-[0-9]{7}-[0-9]{1}/g');
                if (value!.isEmpty) {
                  return null;
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter CINC';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            //
            //===========Joining Date===========//
            Container(
              height: 60,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: Colors.grey.shade300.withOpacity(0.8),
                    width: 2,
                  )),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    dateOfBirth == null
                        ? 'Joining Date'
                        : '${dateOfBirth!.day}/${dateOfBirth!.month}/${dateOfBirth!.year}'
                            .toString(),
                  ),
                  IconButton(
                      icon: Icon(Icons.today, color: Colors.grey),
                      onPressed: () {
                        showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2022))
                            .then((value) {
                          setState(() {
                            dateOfBirth = value;
                          });
                        });
                      })
                ],
              ),
            ),
            const SizedBox(height: 15),
            //===========Phone===============//
            TextFormField(
              textCapitalization: TextCapitalization.sentences,
              decoration: TextFieldDecoration('Phone'),
              keyboardType: TextInputType.number,
              inputFormatters: [maskFormatter],
              validator: (value) {
                final regExp = RegExp('/^[0-9]{5}-[0-9]{7}-[0-9]{1}/g');
                if (value!.isEmpty) {
                  return null;
                } else if (!regExp.hasMatch(value)) {
                  return 'Enter CINC';
                } else {
                  return null;
                }
              },
            ),
            const SizedBox(height: 15),
            //-------------------------------------------------//
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 60,
                    child: ElevatedButton(
                      child: const Text('SAVE'), //next button
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 10),
                        primary: Color(0xffC53B4B),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                      onPressed: () {
                        setState(() {});
                        // Navigator.pushReplacement(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (context) => SecondProfile()));
                        //
                        // // Navigator.of(context).pushAndRemoveUntil(
                        // //     MaterialPageRoute(
                        // //         builder: (context) => SecondProfile()),
                        // //     (Route<dynamic> route) => false);
                        //
                        // var getEmail = controllerEmail.text;
                        // var getUserName = controllerUserName.text;
                        // var getFatherName = controllerFatherName.text;
                        // var getPhone = controllerPhone.text;
                        // var getCnic = controllerCNIC.text;
                        // var getAddress = controllerAddress.text;
                        // var getCity = dropCityValue;
                        // var getGender = dropGenderValue;
                        // var getStatus = dropStatusValue;
                        // var getDate = dateOfBirth;
                        //
                        // UserSaveData.instance.setStringValue("email", getEmail);
                        // UserSaveData.instance
                        //     .setStringValue("username", getUserName);
                        // UserSaveData.instance
                        //     .setStringValue("fathername", getFatherName);
                        // UserSaveData.instance.setStringValue("phone", getPhone);
                        // UserSaveData.instance.setStringValue("cnic", getCnic);
                        // UserSaveData.instance.setStringValue("city", getCity);
                        // UserSaveData.instance
                        //     .setStringValue("gender", getGender);
                        // UserSaveData.instance
                        //     .setStringValue("status", getStatus);
                        // UserSaveData.instance
                        //     .setStringValue("date", getDate.toString());
                        // UserSaveData.instance
                        //     .setStringValue("address", getAddress);
                      },
                    ),
                  ),
                ),
              ],
            ),
            //=================================================//
          ],
        ),
      ),
    );
  }
}

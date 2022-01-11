import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/work_info/utility/build_my_input_decoration.dart';
import 'package:hr_app/widgets/ExpansionPanel.dart';

class AddWorkInfo extends StatefulWidget {
  final compId, data;
  const AddWorkInfo({Key? key, this.compId, this.data}) : super(key: key);

  @override
  _AddWorkInfoState createState() => _AddWorkInfoState();
}

class _AddWorkInfoState extends State<AddWorkInfo> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<AppExpansionTileState> expansionTile = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile2 = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile3 = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile4 = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile5 = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile6 = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile7 = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile8 = GlobalKey();
  final GlobalKey<AppExpansionTileState> expansionTile9 = GlobalKey();
  String selectReportingTo = "Reporting To";
  late String reportingToId;
  // String selectRole = "Role";
  String selectLocation = "Location";
  late String locationId;
  String selectDepartment = "Department";
  String selectStatus = "Status";
  String selectType = "Type";
  String selectTitle = "Designation";
  String selectShift = "Shift Schedule";
  String selectLeave = "Leave Policy";
  late String shiftId;
  late String leaveId;
  late String depId;
  late String titleId;
  late List leaveList;

  late String role;
  late String department;
  late String reportingTo;
  List<String> roles = [
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
  late String empRole;
  late String nickName;
  late String workPhone;
  late String userId;

  final FocusNode _empRoleFocus = FocusNode();
  final FocusNode _nickNameFocus = FocusNode();
  final FocusNode _workPhoneFocus = FocusNode();

  TextEditingController empRoleController = TextEditingController();
  TextEditingController nickNameController = TextEditingController();
  TextEditingController workPhoneController = TextEditingController();

  late ScrollController con;
  var dobFormat;

  _selectDate(BuildContext context) {
    Picker(
        containerColor: isdarkmode.value ? Colors.transparent : Colors.white,
        backgroundColor: isdarkmode.value ? Colors.transparent : Colors.white,
        hideHeader: true,
        adapter: DateTimePickerAdapter(yearEnd: DateTime.now().year),
        title: Container(
          child: const Text(
            "Date of Joining",
            style: TextStyle(
              color: Color(0xFFBF2B38),
            ),
          ),
        ),
        selectedTextStyle: TextStyle(
          color: isdarkmode.value ? Colors.white : Color(0xFFBF2B38),
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            DateTime? dob = (picker.adapter as DateTimePickerAdapter).value;
            // dobFormat = DateFormat('dd-MMM-yyyy').format(dob);
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
        title: const Text(
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
            // exitDateFormat = DateFormat('dd-MMM-yyyy').format(dob);
          });
        }).showDialog(context);
  }

  @override
  void initState() {
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

    userId = widget.data["uid"];
    selectDepartment = widget.data["department"] ?? "Department";
    depId = widget.data["depId"];
    selectStatus = widget.data["empStatus"] ?? "Status";
    selectReportingTo = widget.data["reportingTo"] ?? "Reporting To";
    selectLeave = widget.data["leave"] ?? "Leave Policy";
    selectShift = widget.data["shift"] ?? "Shift Schedule";
    selectType = widget.data["empType"] ?? "Type";
    selectTitle = widget.data["title"] ?? "Designation";
    titleId = widget.data["titleId"];
    empRoleController = TextEditingController(
      text: widget.data["role"],
    );
    workPhoneController = TextEditingController(
      text: widget.data["workPhone"],
    );
    nickNameController = TextEditingController(
      text: widget.data["nickName"],
    );
    dobFormat = widget.data["joiningDate"];
    exitDateFormat = widget.data["exitDate"];

    selectLocation = widget.data["location"] ?? "Location";

    locationId = widget.data["locationId"];

    reportingToId = widget.data["reportingToId"];
    leaveId = widget.data["leaveId"];
    shiftId = widget.data["shiftId"];
    leaveList = widget.data["leaveRecord"];
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
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFBF2B38),
          title: const Text(
            "Work Info",
            style: TextStyle(
                color: Colors.white,
                fontFamily: "Avenir",
                fontSize: 20,
                fontWeight: FontWeight.w500),
          ),
          leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: const Icon(
              Icons.close,
              color: Colors.white,
            ),
          ),
          automaticallyImplyLeading: false,
          actions: <Widget>[
            InkWell(
              onTap: () {
                validateAndSave();
              },
              child: Container(
                width: 90,
                padding: const EdgeInsets.only(right: 20, left: 20),
                alignment: Alignment.centerRight,
                child: const Text(
                  "Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Colors.grey[200],
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 15, top: 20),
                  child: Text(
                    "Department",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.normal),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("departments")
                        .where("companyId", isEqualTo: widget.compId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return _departments(snapshot);
                      } else {
                        return const Center();
                      }
                    }),
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 15, top: 20),
                  child: Text(
                    "Status",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.normal),
                  ),
                ),
                _status(),
                // selectRole == "CEO"
                //     ? Container()
                //     :
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("employees")
                        .where("companyId", isEqualTo: widget.compId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin: const EdgeInsets.only(
                                    left: 27, right: 15, top: 20),
                                child: Text(
                                  "Reporting To",
                                  style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 11,
                                      fontFamily: "Roboto",
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                              Container(
                                child: _reportTo(snapshot),
                              ),
                            ]);
                      }
                      return Center();
                    }),
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 15, top: 20),
                  child: Text(
                    "Employee Type",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.normal),
                  ),
                ),
                _type(),
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 15, top: 20),
                  child: Text(
                    "Designation",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.normal),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("designations")
                        .where("companyId", isEqualTo: widget.compId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return _designation(snapshot);
                      } else {
                        return const Center();
                      }
                    }),
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 15, top: 20),
                  child: Text(
                    "Shift Schedule",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.normal),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("shiftSchedule")
                        .where("companyId", isEqualTo: widget.compId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return _shiftSchedule(snapshot);
                      } else {
                        return const Center();
                      }
                    }),
                Container(
                  margin: const EdgeInsets.only(left: 27, right: 15, top: 20),
                  child: Text(
                    "Leave Policy",
                    style: TextStyle(
                        color: Colors.grey[500],
                        fontSize: 11,
                        fontFamily: "Roboto",
                        fontWeight: FontWeight.normal),
                  ),
                ),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("leavesPolicy")
                        .where("companyId", isEqualTo: widget.compId)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return const Center();
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return _leavePolicy(snapshot);
                      } else {
                        return const Center();
                      }
                    }),

                // Container(
                //   // height: 40,
                //   margin: const EdgeInsets.only(
                //       left: 15, right: 15, bottom: 10, top: 10),
                //   width: MediaQuery.of(context).size.width - 10,
                //   child: TextFormField(textCapitalization: TextCapitalization.sentences,
                //       controller: empRoleController,
                //       textInputAction: TextInputAction.next,
                //       focusNode: _empRoleFocus,
                //       onSaved: (String? value) async => empRole = value!,
                //       onFieldSubmitted: (term) {
                //         _empRoleFocus.unfocus();
                //         FocusScope.of(context).requestFocus(_workPhoneFocus);
                //       },
                //       // validator: validateEmpRole,
                //       decoration: TextFieldDecoration( "Role")
                //       // new InputDecoration(
                //       //   fillColor: Colors.black,
                //       //   prefixIcon: Icon(
                //       //     Icons.assignment,
                //       //     color: Color(0xFFBF2B38),
                //       //   ),
                //       //   hintText: 'Role',
                //       //   hintStyle: TextStyle(
                //       //       color: Color(0xFFA2A2A2),
                //       //       fontSize: 14,
                //       //       fontFamily: "Roboto",
                //       //       fontWeight: FontWeight.normal),
                //       // ),
                //       ),
                // ),
                // // Container(
                // //   margin: EdgeInsets.only(left: 27, right: 15),
                // //   child: Text(
                // //     "Work Phone",
                // //     style: TextStyle(
                // //         color: Colors.grey[500],
                // //         fontSize: 11,
                // //         fontFamily: "Roboto",
                // //         fontWeight: FontWeight.normal),
                // //   ),
                // // ),
                // Container(
                //   // height: 40,
                //   margin: const EdgeInsets.only(left: 15, right: 15),
                //   width: MediaQuery.of(context).size.width - 10,
                //   child: TextFormField(textCapitalization: TextCapitalization.sentences,
                //     controller: workPhoneController,
                //     textInputAction: TextInputAction.done,
                //     focusNode: _workPhoneFocus,
                //     onSaved: (String? value) => workPhone = value!,
                //     onFieldSubmitted: (term) {
                //       _workPhoneFocus.unfocus();
                //       FocusScope.of(context).requestFocus(_nickNameFocus);
                //     },
                //     inputFormatters: <TextInputFormatter>[
                //       WhitelistingTextInputFormatter.digitsOnly
                //     ],
                //     // validator: validateWorkPhone,
                //     keyboardType: TextInputType.phone,
                //     maxLength: 11,
                //     decoration: TextFieldDecoration( "Work Phone"),
                //   ),
                // ),
                // // Container(
                // //   margin: EdgeInsets.only(left: 27, right: 15),
                // //   child: Text(
                // //     "Date of Joining",
                //         style: TextStyle(
                // //         color: Colors.grey[500],
                // //         fontSize: 11,
                // //         fontFamily: "Roboto",
                // //         fontWeight: FontWeight.normal),
                // //   ),
                // // ),
                // InkWell(
                //   onTap: () {
                //     _selectDate(context);
                //   },
                //   child: Container(
                //     width: MediaQuery.of(context).size.width,
                //     height: 60,
                //     margin: const EdgeInsets.only(left: 15, right: 15, top: 10),
                //     decoration: BoxDecoration(
                //         borderRadius: BorderRadius.circular(8),
                //         border: Border.all(
                //             color: Colors.grey.withOpacity(0.4), width: 1)),
                //     child: Container(
                //         margin: const EdgeInsets.only(left: 25, right: 5),
                //         alignment: Alignment.centerLeft,
                //         child: Text(
                //           dobFormat ?? "Date of Joining",
                //           style: TextStyle(
                //               color: dobFormat == null
                //                   ? Colors.black
                //                   : Colors.black,
                //               fontSize: 14,
                //               fontWeight: FontWeight.w400),
                //         )),
                //   ),
                // ),

                // // Container(
                // //   margin: EdgeInsets.only(left: 27, right: 15),
                // //   child: Text(
                // //     "Date of Exit",
                // //     style: TextStyle(
                // //         color: Colors.grey[500],
                // //         fontSize: 11,
                // //         fontFamily: "Roboto",
                // //         fontWeight: FontWeight.normal),
                // //   ),
                // // ),
                // InkWell(
                //   onTap: () {
                //     _selectExitDate(context);
                //   },
                //   child: Container(
                //     height: 60,
                //     // margin: EdgeInsets.only(left: 27, right: 15, top: 10),
                //     margin: const EdgeInsets.only(
                //         left: 15, right: 15, top: 10, bottom: 10),
                //     decoration: BoxDecoration(
                //       borderRadius: BorderRadius.circular(8),
                //       border: Border.all(
                //           color: Colors.grey.withOpacity(0.4), width: 1),
                //     ),
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.start,
                //       children: <Widget>[
                //         Container(
                //             margin: const EdgeInsets.only(left: 25, right: 5),
                //             alignment: Alignment.centerLeft,
                //             child: Text(
                //               exitDateFormat ?? "Date of Exit",
                //               style: TextStyle(
                //                   color: exitDateFormat == null
                //                       ? Colors.black87
                //                       : Colors.black,
                //                   fontSize: 14,
                //                   // fontFamily: "Roboto",
                //                   fontWeight: FontWeight.w400),
                //             )),
                //       ],
                //     ),
                //   ),
                // ),

                // StreamBuilder(
                //     stream: FirebaseFirestore.instance
                //         .collection("locations")
                //         .where("companyId", isEqualTo: widget.compId)
                //         .snapshots(),
                //     builder: (context, AsyncSnapshot snapshot) {
                //       if (!snapshot.hasData) {
                //         return const Center();
                //       } else if (snapshot.hasError) {
                //         return const Center(
                //           child: Text("ERROR"),
                //         );
                //       } else if (snapshot.hasData) {
                //         return _location(snapshot);
                //       } else {
                //         return const Center();
                //       }
                //     }),

                // Container(
                //   height: 60,
                //   margin: const EdgeInsets.only(
                //       left: 15, right: 15, top: 10, bottom: 10),
                //   width: MediaQuery.of(context).size.width - 10,
                //   child: TextFormField(textCapitalization: TextCapitalization.sentences,
                //     controller: nickNameController,
                //     textInputAction: TextInputAction.done,
                //     focusNode: _nickNameFocus,
                //     onSaved: (String? value) => nickName = value!,
                //     onFieldSubmitted: (term) {
                //       _nickNameFocus.unfocus();
                //     },
                //     // validator: validateNickName,
                //     decoration: TextFieldDecoration( "Nick Name"),
                //   ),
                // ),

                // // Container(
                // //   margin: EdgeInsets.only(left: 27, right: 15),
                // //   child: Text(
                // //     "Role*",
                // //     style: TextStyle(
                // //         color: Colors.grey[500],
                // //         fontSize: 11,
                // //         fontFamily: "Roboto",
                // //         fontWeight: FontWeight.normal),
                // //   ),
                // ),
                // Container(
                // //   child: _role(),
                // // ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _location(snapshot) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          // padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile4,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(selectLocation,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: snapshot.data.documents.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              setState(() {
                                selectLocation =
                                    snapshot.data.documents[index].data["name"];
                                locationId = snapshot
                                    .data.documents[index].data["docId"];
                                expansionTile4.currentState!.collapse();
                              });
                            },
                            title: Text(
                              snapshot.data.documents[index].data["name"],
                              style: TextStyle(
                                  fontWeight: selectLocation ==
                                          snapshot.data.documents[index]
                                              .data["name"]
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ));
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _departments(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          // padding: EdgeInsets.only(left: 10, right: 10),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile3,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(
                        selectDepartment,
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              setState(() {
                                selectDepartment = snapshot
                                    .data!.docs[index]["depName"]
                                    .toString();
                                depId = snapshot.data!.docs[index]["docId"];
                                expansionTile3.currentState!.collapse();
                              });
                            },
                            title: Text(
                              snapshot.data!.docs[index]["depName"].toString(),
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: selectDepartment ==
                                          snapshot.data!.docs[index]["depName"]
                                              .toString()
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ));
                      })
                ],
              )
            ],
          ),
        ),
        // Container(
        //   margin: EdgeInsets.only(left: 14, right: 13),
        //   height: 1,
        //   color: Colors.grey,
        // ),
      ],
    );
  }

  Widget _reportTo(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          // padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(selectReportingTo,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return snapshot.data!.docs[index]["uid"] == userId
                            ? Container()
                            : ListTile(
                                onTap: () {
                                  setState(() {
                                    selectReportingTo = snapshot
                                        .data!.docs[index]["name"]
                                        .toString();
                                    reportingToId =
                                        snapshot.data!.docs[index]["uid"];
                                    expansionTile.currentState!.collapse();
                                  });
                                },
                                title: Text(
                                  snapshot.data!.docs[index]["name"].toString(),
                                  style: TextStyle(
                                      fontWeight: selectReportingTo ==
                                              snapshot.data!.docs[index]["name"]
                                                  .toString()
                                          ? FontWeight.w700
                                          : FontWeight.w400),
                                ));
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _designation(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: Colors.grey.withOpacity(0.4), width: 1)),

          // padding:
          //EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile7,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(selectTitle,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              setState(() {
                                selectTitle = snapshot
                                    .data!.docs[index]["desigName"]
                                    .toString();
                                titleId = snapshot.data!.docs[index]["docId"];
                                expansionTile7.currentState!.collapse();
                              });
                            },
                            title: Text(
                              snapshot.data!.docs[index]["desigName"]
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: selectTitle ==
                                          snapshot
                                              .data!.docs[index]["desigName"]
                                              .toString()
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ));
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _shiftSchedule(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: Colors.grey.withOpacity(0.4), width: 1)),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile8,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(selectShift,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              setState(() {
                                selectShift = snapshot
                                    .data!.docs[index]["shiftName"]
                                    .toString();
                                shiftId = snapshot.data!.docs[index]["docId"];
                                expansionTile8.currentState!.collapse();
                              });
                            },
                            title: Text(
                              snapshot.data!.docs[index]["shiftName"]
                                  .toString(),
                              style: TextStyle(
                                  fontWeight: selectShift ==
                                          snapshot
                                              .data!.docs[index]["shiftName"]
                                              .toString()
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ));
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _leavePolicy(AsyncSnapshot<QuerySnapshot> snapshot) {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border:
                  Border.all(color: Colors.grey.withOpacity(0.4), width: 1)),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile9,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(selectLeave,
                          style: const TextStyle(fontSize: 12),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              setState(() {
                                if (leaveId !=
                                    snapshot.data!.docs[index]["docId"]) {
                                  leaveId = snapshot.data!.docs[index]["docId"];
                                  leaveList =
                                      snapshot.data!.docs[index]["leaves"];
                                } else {
                                  leaveId = widget.data["leaveId"];
                                  leaveList = widget.data["leaveRecord"];
                                }
                                selectLeave = snapshot.data!.docs[index]["name"]
                                    .toString();

                                // ignore: avoid_print
                                print(leaveList);
                                expansionTile9.currentState!.collapse();
                              });
                            },
                            title: Text(
                              snapshot.data!.docs[index]["name"].toString(),
                              style: TextStyle(
                                  fontWeight: selectLeave ==
                                          snapshot.data!.docs[index]["name"]
                                              .toString()
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ));
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _status() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          // padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile5,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(selectStatus,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: empStatus.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              setState(() {
                                selectStatus = empStatus[index].toString();
                                expansionTile5.currentState!.collapse();
                              });
                            },
                            title: Text(
                              empStatus[index],
                              style: TextStyle(
                                  fontWeight: selectStatus == empStatus[index]
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ));
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _type() {
    return Column(
      children: <Widget>[
        Container(
          margin: const EdgeInsets.only(left: 15, right: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          // padding: EdgeInsets.only(left: 10, right: 10),
          child: ListView(
            shrinkWrap: true,
            controller: con,
            children: <Widget>[
              AppExpansionTile(
                key: expansionTile6,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: MediaQuery.of(context).size.width / 1.8,
                      margin: const EdgeInsets.only(left: 13),
                      child: Text(selectType,
                          style: const TextStyle(fontSize: 13),
                          overflow: TextOverflow.ellipsis),
                    ),
                  ],
                ),
                backgroundColor:
                    Theme.of(context).accentColor.withOpacity(0.025),
                children: <Widget>[
                  ListView.builder(
                      itemCount: types.length,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                            onTap: () {
                              setState(() {
                                selectType = types[index].toString();
                                expansionTile6.currentState!.collapse();
                              });
                            },
                            title: Text(
                              types[index],
                              style: TextStyle(
                                  fontWeight: selectType == types[index]
                                      ? FontWeight.w700
                                      : FontWeight.w400),
                            ));
                      })
                ],
              )
            ],
          ),
        ),
      ],
    );
  }

  // Widget _buildPanel(snapshot) {
  //   return Column(
  //     children: <Widget>[
  //       Container(
  //         padding: EdgeInsets.only(left: 10, right: 10),
  //         child: ListView(
  //           shrinkWrap: true,
  //           controller: con,
  //           children: <Widget>[
  //             new AppExpansionTile(
  //               key: expansionTile,
  //               leading: Icon(
  //                 Icons.assignment_ind,
  //                 color: Color(0xFFBF2B38),
  //               ),
  //               title: Text(selectReportingTo),
  //               backgroundColor:
  //                   Theme.of(context).accentColor.withOpacity(0.025),
  //               children: <Widget>[
  //                 ListView.builder(
  //                     itemCount: snapshot.data.documents.length,
  //                     shrinkWrap: true,
  //                     physics: NeverScrollableScrollPhysics(),
  //                     itemBuilder: (BuildContext context, int index) {
  //                       return selectRole == "COO"
  //                           ? snapshot.data.documents[index].data["role"] ==
  //                                   "CEO"
  //                               ? ListTile(
  //                                   onTap: () {
  //                                     setState(() {
  //                                       selectReportingTo = snapshot.data
  //                                           .documents[index].data["firstName"]
  //                                           .toString();
  //                                       expansionTile.currentState.collapse();
  //                                       selectReportingToID = snapshot
  //                                           .data.documents[index].documentID;
  //                                     });
  //                                   },
  //                                   title: Text(
  //                                     // 'Annual Leave',
  //                                     snapshot.data.documents[index]
  //                                         .data["firstName"]
  //                                         .toString(),
  //                                     style: TextStyle(
  //                                         fontWeight: selectReportingTo ==
  //                                                 snapshot.data.documents[index]
  //                                                     .data["firstName"]
  //                                             ? FontWeight.w700
  //                                             : FontWeight.w400),
  //                                   ))
  //                               : Container()
  //                           : selectRole == "Director"
  //                               ? snapshot.data.documents[index].data["role"] == "CEO" ||
  //                                       snapshot.data.documents[index].data["role"] ==
  //                                           "COO"
  //                                   ? ListTile(
  //                                       onTap: () {
  //                                         setState(() {
  //                                           selectReportingTo = snapshot
  //                                               .data
  //                                               .documents[index]
  //                                               .data["firstName"]
  //                                               .toString();
  //                                           expansionTile.currentState
  //                                               .collapse();
  //                                           selectReportingToID = snapshot.data
  //                                               .documents[index].documentID;
  //                                         });
  //                                       },
  //                                       title: Text(
  //                                         // 'Annual Leave',
  //                                         snapshot.data.documents[index]
  //                                             .data["firstName"]
  //                                             .toString(),
  //                                         style: TextStyle(
  //                                             fontWeight: selectReportingTo ==
  //                                                     snapshot
  //                                                         .data
  //                                                         .documents[index]
  //                                                         .data["firstName"]
  //                                                 ? FontWeight.w700
  //                                                 : FontWeight.w400),
  //                                       ))
  //                                   : Container()
  //                               : selectRole == "Manager"
  //                                   ? snapshot.data.documents[index].data["role"] == "CEO" ||
  //                                           snapshot.data.documents[index].data["role"] ==
  //                                               "COO" ||
  //                                           snapshot.data.documents[index].data["role"] ==
  //                                               "Director"
  //                                       ? ListTile(
  //                                           onTap: () {
  //                                             setState(() {
  //                                               selectReportingTo = snapshot
  //                                                   .data
  //                                                   .documents[index]
  //                                                   .data["firstName"]
  //                                                   .toString();
  //                                               expansionTile.currentState
  //                                                   .collapse();
  //                                               selectReportingToID = snapshot
  //                                                   .data
  //                                                   .documents[index]
  //                                                   .documentID;
  //                                             });
  //                                           },
  //                                           title: Text(
  //                                             // 'Annual Leave',
  //                                             snapshot.data.documents[index]
  //                                                 .data["firstName"]
  //                                                 .toString(),
  //                                             style: TextStyle(
  //                                                 fontWeight:
  //                                                     selectReportingTo ==
  //                                                             snapshot
  //                                                                     .data
  //                                                                     .documents[
  //                                                                         index]
  //                                                                     .data[
  //                                                                 "firstName"]
  //                                                         ? FontWeight.w700
  //                                                         : FontWeight.w400),
  //                                           ))
  //                                       : Container()
  //                                   : selectRole == "Team Lead"
  //                                       ? snapshot.data.documents[index].data["role"] == "CEO" ||
  //                                               snapshot.data.documents[index].data["role"] ==
  //                                                   "COO" ||
  //                                               snapshot.data.documents[index].data["role"] ==
  //                                                   "Director" ||
  //                                               snapshot.data.documents[index]
  //                                                       .data["role"] ==
  //                                                   "Manager"
  //                                           ? ListTile(
  //                                               onTap: () {
  //                                                 setState(() {
  //                                                   selectReportingTo = snapshot
  //                                                       .data
  //                                                       .documents[index]
  //                                                       .data["firstName"]
  //                                                       .toString();
  //                                                   expansionTile.currentState
  //                                                       .collapse();
  //                                                   selectReportingToID =
  //                                                       snapshot
  //                                                           .data
  //                                                           .documents[index]
  //                                                           .documentID;
  //                                                 });
  //                                               },
  //                                               title: Text(
  //                                                 // 'Annual Leave',
  //                                                 snapshot.data.documents[index]
  //                                                     .data["firstName"]
  //                                                     .toString(),
  //                                                 style: TextStyle(
  //                                                     fontWeight: selectReportingTo ==
  //                                                             snapshot
  //                                                                     .data
  //                                                                     .documents[
  //                                                                         index]
  //                                                                     .data[
  //                                                                 "firstName"]
  //                                                         ? FontWeight.w700
  //                                                         : FontWeight.w400),
  //                                               ))
  //                                           : Container()
  //                                       : selectRole == "Team Member"
  //                                           ? snapshot.data.documents[index].data["role"] == "CEO" ||
  //                                                   snapshot
  //                                                           .data
  //                                                           .documents[index]
  //                                                           .data["role"] ==
  //                                                       "COO" ||
  //                                                   snapshot
  //                                                           .data
  //                                                           .documents[index]
  //                                                           .data["role"] ==
  //                                                       "Director" ||
  //                                                   snapshot.data.documents[index].data["role"] == "Manager" ||
  //                                                   snapshot.data.documents[index].data["role"] == "Team Lead"
  //                                               ? ListTile(
  //                                                   onTap: () {
  //                                                     setState(() {
  //                                                       selectReportingTo =
  //                                                           snapshot
  //                                                               .data
  //                                                               .documents[
  //                                                                   index]
  //                                                               .data[
  //                                                                   "firstName"]
  //                                                               .toString();
  //                                                       expansionTile
  //                                                           .currentState
  //                                                           .collapse();
  //                                                       selectReportingToID =
  //                                                           snapshot
  //                                                               .data
  //                                                               .documents[
  //                                                                   index]
  //                                                               .documentID;
  //                                                     });
  //                                                   },
  //                                                   title: Text(
  //                                                     // 'Annual Leave',
  //                                                     snapshot
  //                                                         .data
  //                                                         .documents[index]
  //                                                         .data["firstName"]
  //                                                         .toString(),
  //                                                     style: TextStyle(
  //                                                         fontWeight: selectReportingTo ==
  //                                                                 snapshot
  //                                                                     .data
  //                                                                     .documents[
  //                                                                         index]
  //                                                                     .data["firstName"]
  //                                                             ? FontWeight.w700
  //                                                             : FontWeight.w400),
  //                                                   ))
  //                                               : Container()
  //                                           : Container();
  //                     })
  //               ],
  //             )
  //           ],
  //         ),
  //       ),
  //       Container(
  //         margin: EdgeInsets.only(left: 14, right: 13),
  //         height: 1,
  //         color: Colors.grey,
  //       ),
  //     ],
  //   );
  // }

  validateAndSave() {
    final form = _formKey.currentState;
    if (form!.validate()) {
      // if (selectDepartment == "Department") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Department",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (selectStatus == "Status") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Status",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (selectReportingTo == "Reporting To") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Reporting To",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (selectType == "Type") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Type",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (selectTitle == "Title") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Title",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (selectShift == "Shift Schedule") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Shift Schedule",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (selectLeave == "Leave Policy") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Leave policy",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (dobFormat == "Date of Joining" || dobFormat == null) {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Joining Date",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else if (selectLocation == "Location") {
      //   Flushbar(
      //     messageText: Text(
      //       "Kindly Select Location",
      //       style: TextStyle(
      //           fontSize: 15, color: Colors.white, fontWeight: FontWeight.w500),
      //     ),
      //     duration: Duration(seconds: 3),
      //     isDismissible: true,
      //     icon: Image.asset(
      //       "assets/images/cancel.png",
      //       // scale: 1.0,
      //       height: 30,
      //       width: 30,
      //     ),
      //     backgroundColor: Color(0xFFBF2B38),
      //     margin: EdgeInsets.all(8),
      //     borderRadius: 8,
      //   )..show(context);
      // } else {
      showLoadingDialog(context);
      DocumentReference reference =
          FirebaseFirestore.instance.collection("employees").doc(userId);
      reference.update({
        "department":
            selectDepartment == "Department" ? null : selectDepartment,
        "depId": depId == "" ? null : depId,
        "empStatus": selectStatus == "Status" ? null : selectStatus,
        "title": selectTitle == "Title" ? null : selectTitle,
        "titleId": titleId == "" ? null : titleId,
        "leave": selectLeave == "Leave Policy" ? null : selectLeave,
        "leaveId": leaveId == "" ? null : leaveId,
        "shift": selectShift == "Shift Schedule" ? null : selectShift,
        "shiftId": shiftId == "" ? null : shiftId,
        "reportingTo":
            selectReportingTo == "Reporting To" ? null : selectReportingTo,
        "reportingToId": reportingToId == "" ? null : reportingToId,
        "empType": selectType == "Type" ? null : selectType,
        "role": empRoleController.text == "" ? null : empRoleController.text,
        "workPhone":
            workPhoneController.text == "" ? null : workPhoneController.text,
        "joiningDate": dobFormat,
        "exitDate": exitDateFormat,
        "location": selectLocation == "Location" ? null : selectLocation,
        "locationId": locationId == "" ? null : locationId,
        "nickName":
            nickNameController.text == "" ? null : nickNameController.text,
        "leaveRecord": leaveList
      });

      Future.delayed(const Duration(milliseconds: 1050), () {
        Navigator.of(context).pop();

        Fluttertoast.showToast(msg: "Work info is updated successfully");
      });
      Future.delayed(const Duration(milliseconds: 1150), () {
        Navigator.of(context).pop();
      });
    } else {
      // ignore: avoid_print
      print('form is invalid');
    }
  }

  String? validateEmpRole(String value) {
    if (value.isEmpty) {
      return "Employee Role can't be empty";
    } else {
      return null;
    }
  }

  String? validateTitle(String value) {
    if (value.isEmpty) {
      return "Title can't be empty";
    } else {
      return null;
    }
  }

  String? validatedepartment(String value) {
    if (value.length < 3) {
      return 'Department must be more than 2 charater';
    } else {
      return null;
    }
  }

  String? validateWorkPhone(String value) {
    final RegExp phoneExp = RegExp(r'^\d\d\d\d\d\d\d\d\d\d\d$');

    if (value.isEmpty) {
      return "Phone number can't be empty";
    } else if (value[0] != "0") {
      return "Phone number is not valid";
    } else if (value[1] != "3") {
      return "Phone number is not valid";
    } else if (value[2] == "5") {
      return "Phone number is not valid";
    } else if (value[2] == "6") {
      return "Phone number is not valid";
    } else if (value[2] == "7") {
      return "Phone number is not valid";
    } else if (value[2] == "8") {
      return "Phone number is not valid";
    } else if (value[2] == "9") {
      return "Phone number is not valid";
    } else if (!phoneExp.hasMatch(value)) {
      return "Phone number is not correct";
    }
    return null;
  }

  String? validateDepartment(String value) {
    if (value.length < 3) {
      return 'Department must be more than 2 charater';
    } else {
      return null;
    }
  }

  String? validateRole(String value) {
    if (value.isEmpty) {
      return "Role can't be empty";
    } else {
      return null;
    }
  }

  String? validateReportingTo(String value) {
    if (value.isEmpty) {
      return "Reporting To can't be empty";
    } else {
      return null;
    }
  }

  String? validateNickName(String value) {
    if (value.isEmpty) {
      return "Nick Name can't be empty";
    } else {
      return null;
    }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }
}

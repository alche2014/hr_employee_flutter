import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter/services.dart';
import 'package:flutter_offline/flutter_offline.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/Dailog/loading_dailog.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/constants.dart';
import 'package:hr_app/services/helper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

import '../../colors.dart';

enum Gender { male, female }

// employee add his/her personal information in this screen
class ContactInfo extends StatefulWidget {
  final data;
  ContactInfo({Key? key, this.data}) : super(key: key);
  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  late Connectivity connectivity;
  late StreamSubscription<ConnectivityResult> subscription;
  // bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  GlobalKey<FormState> locationFormKey = GlobalKey<FormState>();
  late double locationLatitude;
  late double locationLongitude;
  List locationData = [];
  var maritaldropValue;
  var locationAddress;
  late String locationVal;
  var gender;
  late String address;
  late String phone;
  late String email;
  late String cnic;
  late String age;
  //  Asset  ? image;
  late String name;
  late String bankNumber;
  late String cnicAddress;
  late String emergencyPhone;
  late String bloodGroup;
  bool checkedValue = false;

  // late File _image;
  late bool assetImage;
  late bool netImage;
  late String userId;

  List finals = [];
  List perfect = [];
  var cnicNum;
  late String cityName;

  TextEditingController addressController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController bankNumberController = TextEditingController();
  TextEditingController bloodGroupController = TextEditingController();
  TextEditingController emergencyPhoneController = TextEditingController();
  TextEditingController cnicAddressController = TextEditingController();
  var cnicController = MaskedTextController(mask: '00000-0000000-0');
  final maskFormatter = MaskTextInputFormatter(mask: '+92 ### ### ####');

  var dobFormat;
  int agex = 0;
  late DateTime dob;
  String birthDate = "";
  var camera;

  _selectDate(BuildContext context) {
    Picker(
        containerColor: isdarkmode.value ? Colors.transparent : Colors.white,
        backgroundColor: isdarkmode.value ? Colors.transparent : Colors.white,
        hideHeader: true,
        adapter: DateTimePickerAdapter(yearEnd: DateTime.now().year),
        title: const Text(
          "Date of Birth",
          style: TextStyle(
            color: Color(0xFFBF2B38),
          ),
        ),
        selectedTextStyle: TextStyle(
          color: isdarkmode.value ? Colors.white : Color(0xFFBF2B38),
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            dob = (picker.adapter as DateTimePickerAdapter).value!;
            dobFormat = DateFormat('dd-MMM-yyyy').format(dob);
            calculateAge(dob);
          });
        }).showDialog(context);
  }

  calculateAge(DateTime dob) {
    DateTime currentDate = DateTime.now();
    var year = DateFormat('yyyy').format(dob);
    var month = DateFormat('MM').format(dob);
    var day = DateFormat('dd').format(dob);
    var syear = int.parse(year);
    var smonth = int.parse(month);
    var sday = int.parse(day);
    agex = currentDate.year - syear;

    int month1 = currentDate.month;
    int month2 = smonth;
    if (month2 > month1) {
      agex--;
    } else if (month1 == month2) {
      int day1 = currentDate.day;
      int day2 = sday;
      if (day2 > day1) {
        agex--;
      }
    }
    return agex;
  }

  late String _extension;
  late FileType _pickType;
  bool _multiPick = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  String? path;
  String? fileName;
  String profilePicUrl = '';
  File? _image;
  File? images;
  String? imagePath;
  final ImagePicker _imagePicker = ImagePicker();
  var defaultCode = "+92";
  var defaultCode2 = "+92";
  int selectedMaritalTile = 1;
  setSelectedMaritalTile(int val) {
    setState(() {
      selectedMaritalTile = val;
    });
  }

  static Reference storage = FirebaseStorage.instance.ref();

  static Future<String> uploadUserImageToFireStorage(
      image, String userID) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    var downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  Future<void> retrieveLostData() async {
    final LostData? response = await _imagePicker.getLostData();
    if (response == null) {
      return;
    }
    if (response.file != null) {
      setState(() {
        _image = File(response.file!.path);
      });
    }
  }

  _onCameraClick() {
    final action = CupertinoActionSheet(
      message: const Text(
        "Add profile picture",
        style: TextStyle(fontSize: 15.0),
      ),
      actions: <Widget>[
        CupertinoActionSheetAction(
          child: const Text("Choose from gallery"),
          isDefaultAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile? image =
                await _imagePicker.getImage(source: ImageSource.gallery);
            imagePath = null;
            if (image != null) {
              setState(() {
                _image = File(image.path);
              });
            }
          },
        ),
        CupertinoActionSheetAction(
          child: const Text("Take a picture"),
          isDestructiveAction: false,
          onPressed: () async {
            Navigator.pop(context);
            PickedFile? image =
                await _imagePicker.getImage(source: ImageSource.camera);
            imagePath = null;
            if (image != null) {
              setState(() {
                _image = File(image.path);
              });
            }
          },
        )
      ],
      cancelButton: CupertinoActionSheetAction(
        child: const Text("Cancel"),
        onPressed: () {
          Navigator.pop(context);
        },
      ),
    );
    showCupertinoModalPopup(context: context, builder: (context) => action);
  }

  Future pickImage() async {
    try {
      final image = await ImagePicker().pickImage(source: ImageSource.gallery);
      // if (image != null) {
      // await updateProgress('Uploading image, Please wait...');
      profilePicUrl = await uploadUserImageToFireStorage(fileName, userId);
      if (image == null) return;
      setState(() {
        imagePath = image.path;
      });
    } on PlatformException catch (e) {}
  }

  ScrollController? con;

  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.none) {
        setState(() {});
      } else if (result == ConnectivityResult.mobile ||
          result == ConnectivityResult.wifi) {
        setState(() {});
      }
    });
    userId = widget.data["uid"];
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
    maritaldropValue = widget.data["maritalStatus"] == null ||
            widget.data['maritalStatus'] == ""
        ? maritaldropValue
        : widget.data["maritalStatus"];
    agex = (widget.data["age"] == null || widget.data["age"] == ""
        ? 0
        : int.parse(widget.data["age"]));
    cityController = TextEditingController(
        text: widget.data["cityName"] == null || widget.data["cityName"] == ""
            ? ""
            : widget.data["cityName"]);
    nameController = TextEditingController(
        text: widget.data["displayName"] == null ||
                widget.data["displayName"] == ""
            ? ""
            : widget.data["displayName"]);
    bloodGroupController = TextEditingController(
        text:
            widget.data["bloodGroup"] == null || widget.data["bloodGroup"] == ""
                ? ""
                : widget.data["bloodGroup"]);

    defaultCode2 = widget.data["emergencyPhone"] == null ||
            widget.data["emergencyPhone"] == ""
        ? "+92"
        : widget.data["emergencyPhone"].split(" ")[0];

    emergencyPhoneController = TextEditingController(
        text: widget.data["emergencyPhone"] == null ||
                widget.data["emergencyPhone"] == ""
            ? ""
            : widget.data["emergencyPhone"].split(" ")[1]);

    addressController = TextEditingController(
        text: widget.data["address"] == null || widget.data["address"] == ''
            ? ""
            : widget.data["address"]);
    cnicController = MaskedTextController(
        text: widget.data["cnic"], mask: '00000-0000000-0');
    cnicAddressController =
        TextEditingController(text: widget.data["cnicAddress"]);

    dobFormat = widget.data["dob"] == null || widget.data["dob"] == ""
        ? null
        : widget.data["dob"];
    imagePath = widget.data['imagePath'];
    gender = widget.data['gender'] == "Female"
        ? widget.data['gender'] == null
            ? ''
            : Gender.female
        : Gender.male;
    fileName = widget.data['fileName'] == null || widget.data['fileName'] == ""
        ? ""
        : widget.data['fileName'];
    checkedValue = widget.data['covidCheck'] == false ? false : true;
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
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Scaffold(
            extendBodyBehindAppBar: true,
            appBar: buildMyAppBar(context, 'Personal Information', true),
            key: _scaffoldKey,
            body: Stack(children: [
              const BackgroundCircle(),
              Container(
                margin: const EdgeInsets.only(
                    left: 15, right: 15, bottom: 30, top: 120),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                        child: Stack(
                          alignment: Alignment.bottomCenter,
                          children: <Widget>[
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.grey.shade400,
                              child: ClipOval(
                                  child: SizedBox(
                                      width: 140,
                                      height: 140,
                                      child: profilePicUrl == ''
                                          ? imagePath == null
                                              ? _image == null
                                                  ? Image.asset(
                                                      'assets/user_image.png',
                                                      fit: BoxFit.cover,
                                                    )
                                                  : Image.file(
                                                      _image!,
                                                      fit: BoxFit.cover,
                                                    )
                                              : Image.network(imagePath!,
                                                  fit: BoxFit.cover)
                                          : Image.file(
                                              _image!,
                                              fit: BoxFit.cover,
                                            ))),
                            ),
                            Positioned(
                              left: 80,
                              right: 0,
                              child: FloatingActionButton(
                                  backgroundColor: darkRed,
                                  child: const Icon(
                                    Icons.camera_alt,
                                    color: Colors.white,
                                    size: 20,
                                  ),
                                  mini: true,
                                  onPressed: _onCameraClick),
                            )
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: nameController,
                        style: TextFieldTextStyle(),
                        decoration: TextFieldDecoration('Name'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        controller: phoneController,
                        style: TextFieldTextStyle(),
                        decoration: InputDecoration(
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
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: cityController,
                        style: TextFieldTextStyle(),
                        decoration: TextFieldDecoration('City'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        validator: validateName,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
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
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: addressController,
                        style: TextFieldTextStyle(),
                        decoration: TextFieldDecoration('Permanent Address'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: cnicAddressController,
                        decoration: TextFieldDecoration('Address as per CNIC'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        textInputAction: TextInputAction.next,
                        style: TextFieldTextStyle(),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        keyboardType: TextInputType.number,
                        controller: emergencyPhoneController,
                        style: TextFieldTextStyle(),
                        decoration: InputDecoration(
                          prefix: CountryCodePicker(
                              initialSelection: defaultCode2,
                              padding: const EdgeInsets.all(0),
                              onChanged: (CountryCode? selectedValue) {
                                defaultCode2 =
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
                          labelText: 'Emergency Contact',
                          labelStyle: const TextStyle(color: Colors.grey),
                        ),
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: cnicController,
                        textInputAction: TextInputAction.next,
                        style: TextFieldTextStyle(),
                        decoration: TextFieldDecoration('CNIC Number'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        onSaved: (String? value) => cnicNum = value!,
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 10),
                      TextFormField(
                        textCapitalization: TextCapitalization.sentences,
                        controller: bloodGroupController,
                        decoration: TextFieldDecoration('Blood Group'),
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        style: TextFieldTextStyle(),
                        textInputAction: TextInputAction.next,
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          _selectDate(context);
                          setState(() {});
                        },
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: isdarkmode.value
                                      ? Colors.white
                                      : Colors.black,
                                  width: 1)),
                          padding: const EdgeInsets.only(left: 15, right: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: <Widget>[
                              Text(dobFormat == null ? "" : "DOB: "),
                              Text(
                                dobFormat ?? "Date of Birth",
                                style: TextStyle(
                                    color: dobFormat == null
                                        ? Colors.grey.shade700
                                        : isdarkmode.value
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.w400),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: isdarkmode.value
                                    ? Colors.white
                                    : Colors.black,
                                width: 1)),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 15, right: 15),
                              child: Text(
                                "Age: " + agex.toString(),
                                style: TextStyle(
                                    color: dobFormat == null
                                        ? Colors.grey.shade700
                                        : isdarkmode.value
                                            ? Colors.white
                                            : Colors.black,
                                    fontSize: 14,
                                    fontFamily: "Roboto",
                                    fontWeight: FontWeight.normal),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          border: Border.all(
                              color: isdarkmode.value
                                  ? Colors.white
                                  : Colors.black,
                              width: 1),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: DropdownButton<String>(
                              value: maritaldropValue,
                              icon: const Icon(Icons.keyboard_arrow_down),
                              elevation: 0,
                              isExpanded: true,
                              hint: Text('  Marital status',
                                  style: TextStyle(
                                    color: Colors.grey.shade700,
                                    fontSize: 14,
                                  )),
                              onChanged: (String? newValue) {
                                setState(() {
                                  maritaldropValue = newValue;
                                });
                              },
                              items: <String>[
                                'Single',
                                'Married'
                              ].map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(value),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Row(
                            children: [
                              Radio<Gender>(
                                activeColor: darkRed,
                                value: Gender.male,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                              const Text('Male'),
                            ],
                          ),
                          Row(
                            children: [
                              Radio<Gender>(
                                activeColor: darkRed,
                                value: Gender.female,
                                groupValue: gender,
                                onChanged: (Gender? value) {
                                  setState(() {
                                    gender = value;
                                  });
                                },
                              ),
                              const Text('Female'),
                            ],
                          ),
                        ],
                      ),
                      Row(children: [
                        Checkbox(
                          value: checkedValue,
                          activeColor: darkRed,
                          onChanged: (newValue) {
                            setState(() {
                              checkedValue = newValue!;
                            });
                          },
                        ),
                        const Text('Vaccinated against COVID'),
                      ]),
                      const SizedBox(height: 15),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            margin: const EdgeInsets.only(left: 15, bottom: 10),
                            child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: checkedValue == false
                                        ? Colors.grey
                                        : kPrimaryRed),
                                onPressed: () async {
                                  await FilePicker.platform.pickFiles(
                                    type: FileType.custom,
                                    allowedExtensions: ['pdf', 'jpg'],
                                  ).then((value) {
                                    if (value != null) {
                                      setState(() {
                                        path = value.toString();
                                      });
                                    }
                                  });
                                  File file = File(path!);
                                  fileName = file.path.split('/').last;
                                },
                                child: const Text('BROWSE')),
                          ),
                          const SizedBox(width: 25),
                          checkedValue != false
                              ? SizedBox(
                                  height: 30,
                                  child: InkWell(
                                      child: const Text("JPG Attachment",
                                          style: TextStyle(
                                              decoration:
                                                  TextDecoration.underline,
                                              color: Colors.blue)),
                                      onTap: () async {
                                        await FilePicker.platform.pickFiles(
                                          type: FileType.custom,
                                          allowedExtensions: ['jpg'],
                                        ).then((value) {
                                          if (value != null) {
                                            setState(() {
                                              path = value.toString();
                                            });
                                          }
                                        });
                                        File file = File(path!);
                                        fileName = file.path.split('/').last;
                                      }),
                                )
                              : const SizedBox(),
                        ],
                      ),
                      if (path != null)
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              margin:
                                  const EdgeInsets.only(left: 20, bottom: 10),
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width * 0.4,
                                child: Text(fileName!,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    softWrap: false,
                                    style: const TextStyle()),
                              ),
                            ),
                            IconButton(
                                onPressed: () {
                                  setState(() {
                                    path = null;
                                    FilePicker.platform
                                        .clearTemporaryFiles()
                                        .then((result) {});
                                  });
                                },
                                icon: const Icon(Icons.close)),
                          ],
                        ),
                      if (path == null) const SizedBox(),
                      const SizedBox(height: 10),
                      SizedBox(
                        height: 55,
                        width: MediaQuery.of(context).size.width,
                        child: ElevatedButton(
                          child: const Text('SAVE'),
                          style: ElevatedButton.styleFrom(
                            primary: darkRed,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(5)),
                          ),
                          onPressed: () {
                            validateAndSave();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ])));
  }

  validateAndSave() async {
    final form = _formKey.currentState;
    int guest = 0;

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
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference guestPersonalInfoAdd =
            FirebaseFirestore.instance.collection("guests").doc(user.uid);
        profilePicUrl = await uploadUserImageToFireStorage(_image, user.uid);
        await guestPersonalInfoAdd.update({
          // ignore: unnecessary_null_in_if_null_operators
          "phone": phoneController.text.isEmpty
              ? null
              : defaultCode + " " + phoneController.text,
          "otherEmail": emailController.text,
          "cityName": cityController.text == "" ? null : cityController.text,
          "bloodGroup": bloodGroupController.text == ""
              ? null
              : bloodGroupController.text,
          "cnic": cnicController.text,
          "maritalStatus": maritaldropValue,
          "age": agex.toString(),
          "cnicAddress": cnicAddressController.text == ""
              ? null
              : cnicAddressController.text,
          "emergencyPhone": emergencyPhoneController.text.isEmpty
              ? null
              : defaultCode2 + " " + emergencyPhoneController.text,

          "dob": dobFormat,
          "address":
              addressController.text == "" ? null : addressController.text,
          "imagePath": profilePicUrl == '' ? imagePath : profilePicUrl,
          "fileName": fileName,
          "covidCheck": checkedValue,
          "gender": gender == Gender.female ? "Female" : "Male",
        });
      }).whenComplete(() {
        Fluttertoast.showToast(msg: "Personal info is updated successfully");
        Navigator.pop(context);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e);

        print('======Error====$e==== ');
      });
    } else {
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference empPersonalInfoAdd =
            FirebaseFirestore.instance.collection("employees").doc(user.uid);
        // profilePicUrl=='' || profilePicUrl==null?

        // profilePicUrl=imagePath!:
        imagePath == null
            ? profilePicUrl =
                await uploadUserImageToFireStorage(_image, user.uid)
            : imagePath;
        await empPersonalInfoAdd.update({
          // ignore: unnecessary_null_in_if_null_operators
          "displayName": nameController.text,
          "phone": phoneController.text.isEmpty
              ? null
              : defaultCode + " " + phoneController.text,
          "otherEmail": emailController.text,
          "cityName": cityController.text == "" ? null : cityController.text,
          // "bankNumber": bankNumberController.text == ""
          //     ? null
          //     : bankNumberController.text,
          "bloodGroup": bloodGroupController.text == ""
              ? null
              : bloodGroupController.text,
          "cnic": cnicController.text,
          "maritalStatus": maritaldropValue,

          "age": agex.toString(),
          "cnicAddress": cnicAddressController.text == ""
              ? null
              : cnicAddressController.text,
          "emergencyPhone": emergencyPhoneController.text.isEmpty
              ? null
              : defaultCode2 + " " + emergencyPhoneController.text,
          "dob": dobFormat,
          "address":
              addressController.text == "" ? null : addressController.text,
          "imagePath": profilePicUrl == "" || profilePicUrl == null
              ? imagePath
              : profilePicUrl,
          "fileName": fileName,
          "covidCheck": checkedValue,

          "gender": gender.toString() == "Gender.female" ? "Female" : "Male",
        });
      }).whenComplete(() {
        Navigator.pop(context);

        Fluttertoast.showToast(msg: "Personal info is updated successfully");
        Navigator.pop(context);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e);

        print('======Error====$e==== ');
      });

      // }

      // }
    }
    // else {
    //   return ('form is invalid');
    // }
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => LoadingDialog()));
  }
}

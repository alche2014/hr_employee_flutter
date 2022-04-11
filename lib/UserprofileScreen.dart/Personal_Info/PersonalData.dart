import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_masked_text/flutter_masked_text.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/loadingDailog.dart';

import 'package:hr_app/UserprofileScreen.dart/appbar.dart';

import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/main.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

// employee add his/her personal information in this screen
enum Gender { male, female }

class PeroanlDetail extends StatefulWidget {
  final data;
  const PeroanlDetail({Key? key, this.data}) : super(key: key);
  @override
  _PeroanlDetailState createState() => _PeroanlDetailState();
}

class _PeroanlDetailState extends State<PeroanlDetail> {
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  // bool isNetwork = true;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool checkedValue = false;
  var gender;
  String? imagePath;

  String? path;
  var fileName;
  String profilePicUrl = '';
  var defaultCode = "+92";
  var defaultCode2 = "+92";
  final ImagePicker _imagePicker = ImagePicker();

  var image;
  bool? assetImage;
  bool? netImage;
  String? userId;

  var cnicNum;

  late String name;
  final FocusNode cityFocus = FocusNode();

  TextEditingController nameController = TextEditingController();
  TextEditingController fatherNameController = TextEditingController();
  TextEditingController cnicAddressController = TextEditingController();
  var cnicController = MaskedTextController(mask: '00000-0000000-0');
  static var downloadUrl;

  var dobFormat;
  int agex = 0;
  File? _image;
  DateTime? dob;
  String? birthDate = "";
  var maritaldropValue;

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
      profilePicUrl = await uploadUserImageToFireStorage(fileName, userId!);
      if (image == null) return;
      setState(() {
        imagePath = image.path;
      });
    } on PlatformException catch (e) {}
  }

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
            color: purpleDark,
          ),
        ),
        selectedTextStyle: TextStyle(
          color: isdarkmode.value ? Colors.white : purpleDark,
        ),
        onConfirm: (Picker picker, List value) {
          setState(() {
            dob = (picker.adapter as DateTimePickerAdapter).value;
            dobFormat = DateFormat('dd-MMM-yyyy').format(dob!);
            calcuAge(dob!);
          });
        }).showDialog(context);
  }

  calcuAge(DateTime dob) {
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

  FileType? _pickType;
  var _paths;
  bool _multiPick = true;
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  int selectedMaritalTile = 1;

  setSelectedMaritalTile(int? val) {
    setState(() {
      selectedMaritalTile = val!;
    });
  }

  static Reference storage = FirebaseStorage.instance.ref();

  static Future<String> uploadUserImageToFireStorage(
      image, String userID) async {
    Reference upload = storage.child("images/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    downloadUrl =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl.toString();
  }

  static var downloadUrl2;
  static Future<String> uploadVaccinationImage(image, userID) async {
    Reference upload = storage.child("Vacination/$userID.png");
    UploadTask uploadTask = upload.putFile(image);
    downloadUrl2 =
        await (await uploadTask.whenComplete(() {})).ref.getDownloadURL();
    return downloadUrl2.toString();
  }

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
    defaultCode = widget.data["phone"] == null || widget.data["phone"] == ""
        ? "+92"
        : widget.data["phone"].split(" ")[0];

    maritaldropValue = widget.data["maritalStatus"] == null ||
            widget.data['maritalStatus'] == ""
        ? maritaldropValue
        : widget.data["maritalStatus"];
    agex = (widget.data["age"] == null || widget.data["age"] == ""
        ? 0
        : int.parse(widget.data["age"]));

    nameController = TextEditingController(
        text: widget.data["displayName"] == null ||
                widget.data["displayName"] == ""
            ? ""
            : widget.data["displayName"]);
    fatherNameController = TextEditingController(
        text:
            widget.data["fatherName"] == null || widget.data["fatherName"] == ""
                ? ""
                : widget.data["fatherName"]);
    defaultCode2 = widget.data["emergencyPhone"] == null ||
            widget.data["emergencyPhone"] == ""
        ? "+92"
        : widget.data["emergencyPhone"].split(" ")[0];

    cnicController = MaskedTextController(
        text: widget.data["cnic"], mask: '00000-0000000-0');
    cnicAddressController =
        TextEditingController(text: widget.data["cnicAddress"]);

    dobFormat = widget.data["dob"] == null || widget.data["dob"] == ""
        ? ""
        : widget.data["dob"];
    imagePath = widget.data['imagePath'];
    gender = widget.data['gender'] == null
        ? null
        : widget.data['gender'] == "Female"
            ? Gender.female
            : Gender.male;

    fileName = widget.data['fileName'] == null || widget.data['fileName'] == ""
        ? ""
        : widget.data['fileName'];
    checkedValue =
        widget.data['covidCheck'] == null ? false : widget.data['covidCheck'];

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
        appBar: buildMyAppBar(context, 'Peroanl Details', true),
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
                                                ? Image.network(
                                                    'https://via.placeholder.com/150')
                                                : Image.file(_image!,
                                                    fit: BoxFit.cover)
                                            : Image.network(imagePath!,
                                                fit: BoxFit.cover)
                                        : Image.file(_image!,
                                            fit: BoxFit.cover))),
                          ),
                          Positioned(
                            left: 80,
                            right: 0,
                            child: FloatingActionButton(
                                backgroundColor: purpleDark,
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
                    Text("  Name", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: nameController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Name'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Text("  Father's Name", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: fatherNameController,
                      decoration: TextFieldDecoration("Father's Name"),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      style: TextFieldTextStyle(),
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Text("  Address as per CNIC",
                        style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: cnicAddressController,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('Address as per CNIC'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(height: 15),
                    Text("  CNIC", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    TextFormField(
                      textCapitalization: TextCapitalization.sentences,
                      controller: cnicController,
                      textInputAction: TextInputAction.next,
                      style: TextFieldTextStyle(),
                      decoration: TextFieldDecoration('CNIC'),
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      onSaved: (String? value) => cnicNum = value!,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 15),
                    Text("  Date of Birth", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        _selectDate(context);
                        setState(() {});
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        alignment: Alignment.centerLeft,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            border: Border.all(
                                color: Colors.transparent, width: 0)),
                        padding: const EdgeInsets.only(left: 15, right: 15),
                        child: Text(
                          dobFormat == null || dobFormat == ""
                              ? "Date of Birth"
                              : dobFormat,
                          style: TextStyle(
                              color: dobFormat == null || dobFormat == ""
                                  ? Color(0xFF737373)
                                  : isdarkmode.value
                                      ? Colors.white
                                      : Colors.black,
                              fontWeight: FontWeight.w500,
                              fontSize: 13,
                              fontFamily: "Poppins"),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text("  Age", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: Colors.white,
                          border:
                              Border.all(color: Colors.transparent, width: 0)),
                      child: Text(
                        dobFormat == null || dobFormat == ""
                            ? "Age"
                            : agex.toString(),
                        style: TextStyle(
                            color: dobFormat == null || dobFormat == ""
                                ? Color(0xFF737373)
                                : isdarkmode.value
                                    ? Colors.white
                                    : Colors.black,
                            fontWeight: FontWeight.w500,
                            fontSize: 13,
                            fontFamily: "Poppins"),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text("  Marital status", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white, width: 0),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: DropdownButton<String>(
                            value: maritaldropValue,
                            icon: const Icon(Icons.keyboard_arrow_down),
                            elevation: 0,
                            isExpanded: true,
                            hint: const Text('  Marital status',
                                style: TextStyle(
                                    color: Color(0xFF737373),
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13,
                                    fontFamily: "Poppins")),
                            onChanged: (String? newValue) {
                              setState(() {
                                maritaldropValue = newValue;
                              });
                            },
                            items: <String>['Single', 'Married']
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text("  Gender", style: TextFieldHeadingStyle()),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Row(
                          children: [
                            Radio<Gender>(
                              activeColor: purpleDark,
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
                              activeColor: purpleDark,
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
                        activeColor: purpleDark,
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
                                      : purpleLight),
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
                            margin: const EdgeInsets.only(left: 20, bottom: 10),
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
                    const SizedBox(height: 15),
                    saveButton(context, onpress)
                  ],
                ),
              ),
            )));
  }

  onpress() {
    if (nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.white,
          content: Text('Name is empty', style: TextStyle(color: Colors.black)),
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
      imagePath == null
          ? profilePicUrl = await uploadUserImageToFireStorage(_image, user.uid)
          : imagePath;
      FirebaseFirestore.instance
          .runTransaction((Transaction transaction) async {
        DocumentReference reference = guest == 0
            ? FirebaseFirestore.instance.collection("guests").doc(userId)
            : FirebaseFirestore.instance.collection("employees").doc(userId);
        await reference.update({
          "displayName": nameController.text,
          "fatherName": fatherNameController.text == ""
              ? null
              : fatherNameController.text,
          "cnic": cnicController.text,
          "maritalStatus": maritaldropValue,
          "age": agex.toString(),
          "dob": dobFormat,
          "cnicAddress": cnicAddressController.text == ""
              ? null
              : cnicAddressController.text,
          "imagePath": profilePicUrl == "" || profilePicUrl == null
              ? imagePath
              : downloadUrl,
          "fileName":
              fileName == "" || fileName == null ? fileName : downloadUrl2,
          "covidCheck": checkedValue,
          "gender": gender.toString() == "Gender.female" ? "Female" : "Male",
        });
      }).whenComplete(() {
        Navigator.pop(context);

        Fluttertoast.showToast(msg: "Personal Detail is added successfully");
        Navigator.pop(context);
      }).catchError((e) {
        Fluttertoast.showToast(msg: e);
      });
    }
  }
}

import 'dart:io';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:dio/dio.dart';
import 'package:ext_storage/ext_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:hr_app/Constants/constants.dart';
import 'package:hr_app/Constants/loadingDailog.dart';
import 'package:hr_app/MainApp/CheckIn/check_in_card.dart';
import 'package:hr_app/main.dart';
import 'package:intl/intl.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

class CheckinHistory extends StatefulWidget {
  final memId;
  const CheckinHistory({Key? key, this.memId}) : super(key: key);

  @override
  State<CheckinHistory> createState() => _CheckinHistoryState();
}

class _CheckinHistoryState extends State<CheckinHistory> {
  int a = 0;
  DateTime now = DateTime.now();
  int days = 0;
  var weekendDefi;
  bool _multiPick = false;
  String? url;
  FileType? _pickType;
  List<UploadTask> _tasks = <UploadTask>[];
  String? exportUrlDesign;

  bool downloading = false;
  static final Random random = Random();
  String dropdownValue =
      '${DateFormat('MMMM yyyy').format(DateTime.now()).toString()}';
  @override
  void initState() {
    days = DateTime(now.year, now.month + 1, now.day).day;
    _getShiftSchedule();

    var userQuery = FirebaseFirestore.instance
        .collection('attendance')
        .where('companyId', isEqualTo: companyId)
        .where("empId", isEqualTo: widget.memId)
        .where("month", isEqualTo: dropdownValue)
        .limit(1);
    userQuery.get().then((data) {
      if (data.docs.isNotEmpty) {
        setState(() {
          exportUrlDesign = data.docs[0].data()['url'];
        });
      }
    });
    loadNullCheckout();
    super.initState();
  }

  //Get all the user's of specific company who haven't checkout
  loadNullCheckout() async {
    var userQuery = FirebaseFirestore.instance
        .collection('attendance')
        .where('companyId', isEqualTo: companyId)
        .where("checkout", isNull: true)
        .where("month",
            isEqualTo:
                DateFormat('MMMM yyyy').format(DateTime.now()).toString());

    userQuery.get().then((data) {
      if (data.docs.isNotEmpty) {
        setState(() {});
      }
    });
  }

  void showLoadingDialog(BuildContext context) {
    // flutter defined function
    Navigator.of(context).push(PageRouteBuilder(
        opaque: false,
        pageBuilder: (BuildContext context, _, __) => const LoadingDialog()));
  }

  _getShiftSchedule() {
    FirebaseFirestore.instance
        .collection('shiftSchedule')
        .doc(shiftId)
        .snapshots()
        .listen((onValue) {
      setState(() {
        weekendDefi = onValue.data()!["weekendDef"];
      });
    });
  }

  var progress = "";

  String? fullPath;

  void showDownloadProgress(received, total) {
    if (total != -1) {
      setState(() {
        progress = ((received / total) * 100).toStringAsFixed(0) + "%";
      });

      print((received / total * 100).toStringAsFixed(0) + "%");
    }
  }

  String? exportUrl;
  var dio = Dio();
  String? _path;
  String? _extension;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 120),
                StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection("attendance")
                        .where("empId", isEqualTo: widget.memId)
                        .where("month", isEqualTo: dropdownValue)
                        .orderBy("checkin", descending: false)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      a = 0;

                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      } else if (snapshot.hasError) {
                        return const Center(
                          child: Text("ERROR"),
                        );
                      } else if (snapshot.hasData) {
                        return snapshot.data!.docs.isEmpty
                            ? Center(
                                child: Container(
                                  height:
                                      MediaQuery.of(context).size.height - 450,
                                  margin: const EdgeInsets.only(
                                      bottom: 20, top: 50),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      const Icon(
                                        Icons.calendar_today,
                                        color: purpleDark,
                                        size: 100,
                                      ),
                                      const Text(
                                        "It's empty here.",
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 16,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w600),
                                      ),
                                      Text(
                                        "No records found.",
                                        style: TextStyle(
                                            color: Colors.grey[400],
                                            fontSize: 12,
                                            fontFamily: "Roboto",
                                            fontWeight: FontWeight.w400),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  ListView.builder(
                                      padding: const EdgeInsets.all(0),
                                      shrinkWrap: true,
                                      physics:
                                          const NeverScrollableScrollPhysics(),
                                      itemCount: days,
                                      reverse: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return
                                            // snapshot.data!.docs[index]['late'] ==
                                            //         "-"
                                            //     ? Column(children: [
                                            //         Row(
                                            //           children: [
                                            //             Expanded(
                                            //               flex: 2,
                                            //               child: Center(
                                            //                 child: Container(
                                            //                   width: 43,
                                            //                   padding:
                                            //                       const EdgeInsets.all(
                                            //                           5.0),
                                            //                   decoration: BoxDecoration(
                                            //                       color: Colors.white,
                                            //                       borderRadius:
                                            //                           BorderRadius
                                            //                               .circular(5),
                                            //                       border: Border.all(
                                            //                           color: Colors
                                            //                               .grey.shade300,
                                            //                           width: 1)),
                                            //                   child: Column(children: [
                                            //                     Text(
                                            //                         DateFormat('dd').format(DateFormat(
                                            //                                 'MMMM dd yyyy')
                                            //                             .parse(snapshot
                                            //                                         .data!
                                            //                                         .docs[
                                            //                                     index]
                                            //                                 ['date'])),
                                            //                         style: const TextStyle(
                                            //                             fontWeight:
                                            //                                 FontWeight
                                            //                                     .bold,
                                            //                             fontSize: 17)),
                                            //                     const SizedBox(height: 2),
                                            //                     Text(
                                            //                         DateFormat(
                                            //                                 'EEE')
                                            //                             .format(DateFormat(
                                            //                                     'MMMM dd yyyy')
                                            //                                 .parse(snapshot
                                            //                                         .data!
                                            //                                         .docs[index]
                                            //                                     ['date']))
                                            //                             .toUpperCase(),
                                            //                         style: TextStyle(
                                            //                             fontWeight:
                                            //                                 FontWeight
                                            //                                     .bold,
                                            //                             fontSize: 12,
                                            //                             color: Colors.grey
                                            //                                 .shade700)),
                                            //                   ]),
                                            //                 ),
                                            //               ),
                                            //             ),
                                            //             Expanded(
                                            //                 flex: 9,
                                            //                 child: Center(
                                            //                   child: Text(
                                            //                     snapshot.data!.docs[index]
                                            //                         ['leave'],
                                            //                     style: const TextStyle(
                                            //                         color: Colors.red),
                                            //                   ),
                                            //                 )),
                                            //           ],
                                            //         ),
                                            //         Container(
                                            //           margin: const EdgeInsets.only(
                                            //               top: 5,
                                            //               bottom: 5,
                                            //               left: 75,
                                            //               right: 10),
                                            //           height: 1,
                                            //           color: Colors.grey.shade300,
                                            //         )
                                            //       ])
                                            //     :

                                            checkinCard(snapshot.data!.docs,
                                                index, dropdownValue);
                                      }),
                                ],
                              );
                      } else {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    }),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                color: Colors.white,
                height: 60,
                child: ListTile(
                  leading: InkWell(
                      onTap: () {
                        setState(() {
                          a = 0;

                          now = DateTime(now.year, now.month - 1);
                          dropdownValue =
                              '${DateFormat('MMMM yyyy').format(now).toString()}';
                          days = DateTime(now.year, now.month + 1, 0).day;
                        });
                      },
                      child: Container(
                          padding: EdgeInsets.all(10),
                          child: Icon(Icons.arrow_back_ios_new, size: 18))),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.calendar_today_outlined,
                          color: purpleDark, size: 20),
                      Text(" ${DateFormat('MMMM yyyy').format(now)}",
                          style: const TextStyle(
                              fontSize: 16,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: purpleDark)),
                    ],
                  ),
                  trailing: InkWell(
                      onTap: () {
                        if (now.year == DateTime.now().year &&
                            now.month == DateTime.now().month) {
                          Fluttertoast.showToast(msg: "No more records");
                        } else if (now.month + 1 == DateTime.now().month) {
                          setState(() {
                            a = 0;
                            now = DateTime(now.year, now.month + 1);

                            dropdownValue =
                                '${DateFormat('MMMM yyyy').format(now).toString()}';
                            days = DateTime(
                                    now.year, now.month + 1, DateTime.now().day)
                                .day;
                          });
                        } else {
                          setState(() {
                            a = 0;
                            now = DateTime(now.year, now.month + 1);

                            dropdownValue =
                                DateFormat('MMMM yyyy').format(now).toString();
                            days = DateTime(now.year, now.month + 1, 0).day;
                            print(now.toString() +
                                "============" +
                                days.toString());
                          });
                        }
                      },
                      child: Container(
                          padding: const EdgeInsets.all(10),
                          child:
                              const Icon(Icons.arrow_forward_ios, size: 18))),
                ),
              ),
              Container(height: 1, color: Colors.grey.shade400),
              Container(
                height: 50,
                color: Colors.grey.shade100,
                child: Row(children: const [
                  Expanded(
                      flex: 2,
                      child: Text("Date",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Clock in",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Clock out",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade))),
                  Expanded(
                      flex: 3,
                      child: Text("Working Hrs",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w500,
                              color: greyShade)))
                ]),
              )
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var callable = FirebaseFunctions.instance
              .httpsCallable('csvExportFileAttendece');
          try {
            // showLoadingDialog(context);
            final HttpsCallableResult result =
                await callable.call(<String?, dynamic>{
              "companyId": companyId,
              "collection": "attendance",
              "empId": widget.memId,
              "month": dropdownValue
            }).whenComplete(() async {
              var randid = random.nextInt(10000);
              // final path = await getApplicationDocumentsDirectory();

              // fullPath = "$path/" + "attendance" + randid.toString() + ".csv";
              // print('full path ${fullPath.toString()}');
              // setState(() {
              //   downloading = true;
              //   fullPath = "$path/" + "attendance" + randid.toString() + ".csv";
              // });

              final output = await getTemporaryDirectory();
              fullPath = "${output.path}/'attendance'.csv";
              final file = File(fullPath!);
              print("============path==============$fullPath");
              // await file.writeAsBytes(byteList);
              await OpenFile.open(fullPath);
              download2(dio, exportUrlDesign!, fullPath!)
                  .whenComplete(() async {
                await Future.delayed(const Duration(milliseconds: 0), () async {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text(
                    "attendance" +
                        randid.toString() +
                        ".csv" +
                        "  Successfully Save to Downloads",
                  )));

                  // Navigator.push(
                  //     context,
                  //     MaterialPageRoute(
                  //         builder: (context) => ExportFileDesign(
                  //             url:
                  //                 'https://storage.googleapis.com/alche-hr-app.appspot.com//tmp/attendance255306.csv?GoogleAccessId=firebase-adminsdk-o1nok%40alche-hr-app.iam.gserviceaccount.com&Expires=16447017600&Signature=OSIYUXbr0OEYPK9us3HM67XPTZg6h5%2F5shraTFidmGdYhX7gZ4pi9Jph3Di6U8MW94uG2nkMfC1nEKA6rJ3yhRWmtUGzJq7nXM0rJdUWX0gCvve5T5Oe2u6xVjKs%2BWFj5nMgtIhpk4w2%2FrVUJCgv%2BTFvRxtJIcw8tgSxOfYTNHnuIApO5Aok%2FXJq3NnP45d%2FAOlLeMP6an%2FSIm5WvuEnpRgGMNtYZJIvof3hME1yRZuV9695aTSP0wZSOIxlk9HQF9yrvj75qaD6aoZv1hxlQT90C2vnfHWpvA9WE0NgE8n4jK5oHd%2FKvfg0Duv0ylcPhP1NbaD%2FCEomnUtBk5SEFQ%3D%3D')));
                });
              });
            });

            print(result.data);
          } on FirebaseFunctionsException catch (e) {
            print('caught firebase functions exception');
            print(e.code);
            print(e.message);
            print(e.details);
          } catch (e) {
            print('caught generic exception');
            print(e);
          }
          //   await  Future.delayed(Duration(milliseconds: 1000), () {
          // Navigator.of(context).pop();

          //      Navigator.push(
          //       context,
          //       MaterialPageRoute(
          //           builder: (context) => ExportFileDesign(
          //                  url:exportUrlDesign
          //               )));

          // });

          //   var callable =
          //       FirebaseFunctions.instance.httpsCallable('csvExportFile');
          //   try {
          //     showLoadingDialog(context);
          //     final HttpsCallableResult result =
          //         await callable.call(<String?, dynamic>{
          //       "companyId": companyId,
          //       "collection": "attendance",
          //       "month": dropdownValue,
          //       "empId": empId,
          //     }).whenComplete(() async {
          //       var randid = random.nextInt(10000);
          //       String? path = await ExtStorage.getExternalStoragePublicDirectory(
          //           ExtStorage.DIRECTORY_DOWNLOADS);
          //       fullPath = "$path/" + "attendance" + randid.toString() + ".csv";
          //       print('full path ${fullPath.toString()}');
          //       setState(() {
          //         downloading = true;
          //         fullPath = "$path/" + "attendance" + randid.toString() + ".csv";
          //       });
          //       download2(
          //               dio,
          //               'https://firebasestorage.googleapis.com/v0/b/alche-hr-app.appspot.com/o/Employees3042.csv?alt=media&token=0d3bb712-c5b4-44f1-bfc3-4856ab55f243',
          //               fullPath!)
          //           .whenComplete(() async {
          //         await Future.delayed(Duration(milliseconds: 0), () async {
          //           Navigator.of(context).pop();
          //           ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          //               content: Text(
          //             "attendance" +
          //                 randid.toString() +
          //                 ".csv" +
          //                 "  Successfully Save to Downloads",
          //           )));

          //           //  Navigator.push(
          //           //   context,
          //           //   MaterialPageRoute(
          //           //       builder: (context) => ExportFileDesign(
          //           //              url:exportUrl
          //           //           )));
          //         });
          //       });
          //     });

          //     print(result.data);
          //   } on FirebaseFunctionsException catch (e) {
          //     print('caught firebase functions exception');
          //     print(e.code);
          //     print(e.message);
          //     print(e.details);
          //   } catch (e) {
          //     print('caught generic exception');
          //     print(e);
          //   }
          //   //   await  Future.delayed(Duration(milliseconds: 1000), () {
          //   // Navigator.of(context).pop();

          //   //      Navigator.push(
          //   //       context,
          //   //       MaterialPageRoute(
          //   //           builder: (context) => ExportFileDesign(
          //   //                  url:exportUrlDesign
          //   //               )));

          // });
        },
        child: const Icon(
          Icons.download,
          color: Colors.white,
        ),
        backgroundColor: purpleDark,
      ),
    );
  }

  Widget getFAB() {
    return SpeedDial(
      animatedIcon: AnimatedIcons.add_event,
      animatedIconTheme: const IconThemeData(size: 29),
      backgroundColor: const Color(0xFFBF2B38),
      visible: true,
      curve: Curves.bounceIn,
      children: [
        SpeedDialChild(
            child: const Icon(
              Icons.import_export,
              color: Colors.white,
            ),
            backgroundColor: const Color(0xFFBF2B38),
            label: 'Export',
            labelStyle: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontSize: 16.0),
            labelBackgroundColor: const Color(0xFFBF2B38)),
      ],
    );
  }

  void openFileExplorer() async {
    try {
      _path = null;
      if (!_multiPick) {
        _path = await FilePicker.platform.saveFile(type: _pickType!);
      }
      uploadToFirebase();
    } on PlatformException catch (e) {
      print("Unsupported operation" + e.toString());
    }
    if (!mounted) return;
  }

  uploadToFirebase() {
    if (!_multiPick) {
      String fileName = _path!.split('/').last;
      String filePath = _path!;
      upload(fileName, filePath);
    }
  }

  upload(fileName, filePath) async {
    _extension = fileName.toString().split('.').last;
    Reference storageRef = FirebaseStorage.instance.ref().child(fileName);
    final UploadTask uploadTask = storageRef.putFile(
      File(filePath),
      SettableMetadata(
        contentType: '$_pickType/$_extension',
      ),
    );
    url = await (await uploadTask).ref.getDownloadURL();
    var callable =
        FirebaseFunctions.instance.httpsCallable('csvExportFileAttendece');
    try {
      showLoadingDialog(context);
      final HttpsCallableResult result = await callable.call(<String?, dynamic>{
        "companyId": companyId,
        "collection": "attendance",
        "month": dropdownValue,
        "empId": empId,
      });
      print(result.data);
    } on FirebaseFunctionsException catch (e) {
      print('caught firebase functions exception');
      print(e.code);
      print(e.message);
      print(e.details);
    } catch (e) {
      print('caught generic exception');
      print(e);
    }
    await Future.delayed(Duration(seconds: 30), () {
      Fluttertoast.showToast(msg: "Monthly Report Download Successfully");
      Navigator.of(context).pop();
    });
    setState(() {
      _tasks.add(uploadTask);
    });
  }

  Future download2(Dio dio, String url, String savePath) async {
    try {
      Response response = await dio.get(
        url,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      print(response.headers);
      File file = File(savePath);
      var raf = file.openSync(mode: FileMode.write);
      // response.data is List<int> type
      raf.writeFromSync(response.data);
      await raf.close();
    } catch (e) {
      print(e);
    }
    setState(() {
      downloading = false;
      progress = "Download Completed.";
    });
  }

  Widget checkinCard(timeStatus, index, day) {
    if (weekendDefi.contains(
            "${DateFormat('EEE').format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))}${(DateFormat('dd MMMM yyyy').parse("${index + 1} $day").day / 8).toInt() + 1}") &&
        weekendDefi.contains(
            "${DateFormat('EEE').format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))}0"))

    // DateFormat('EEE')
    //           .format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))
    //           .toUpperCase() ==
    //       "SAT" ||
    //   DateFormat('EEE')
    //           .format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))
    //           .toUpperCase() ==
    //       "SUN")
    {
      a++;
    } else if (index - a == timeStatus.length) {
      a++;
    } else if (timeStatus[index - a]['date'].toString() !=
        DateFormat('MMMM dd yyyy')
            .format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))) {
      index == 0 ? a : a++;
    }
    return Stack(
      children: [
        (weekendDefi.contains(
                    "${DateFormat('EEE').format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))}${(DateFormat('dd MMMM yyyy').parse("${index + 1} $day").day / 8).toInt() + 1}") ||
                weekendDefi.contains(
                    "${DateFormat('EEE').format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day"))}0"))
            ? Container(
                height: 45,
                margin: const EdgeInsets.only(
                    left: 12, right: 12, top: 5, bottom: 5),
                color: Colors.grey.shade200,
                child: Center(
                  child: Text(
                    "Weekend: ${index + 1} ${DateFormat('EEE').format(DateFormat('dd MMMM yyyy').parse("${index + 1} $day")).toUpperCase()}",
                    style: const TextStyle(color: Colors.black),
                  ),
                ),
              )
            : Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: Center(
                      child: Container(
                        width: 43,
                        padding: const EdgeInsets.all(5.0),
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                                color: Colors.grey.shade300, width: 1)),
                        child: Column(children: [
                          Text("${index + 1}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 17)),
                          const SizedBox(height: 2),
                          Text(
                              DateFormat('EEE')
                                  .format(DateFormat('dd MMMM yyyy')
                                      .parse("${index + 1} $day"))
                                  .toUpperCase(),
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                  color: Colors.grey.shade700)),
                        ]),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 9,
                      child: Center(
                          child: index - a == timeStatus.length
                              ? const Text(
                                  "Absent",
                                  style: TextStyle(color: Colors.red),
                                )
                              : timeStatus[index - a]['date'].toString() !=
                                      DateFormat('MMMM dd yyyy').format(
                                          DateFormat('dd MMMM yyyy')
                                              .parse("${index + 1} $day"))
                                  ? const Text(
                                      "Absent",
                                      style: TextStyle(color: Colors.red),
                                    )
                                  : CheckInCard(timeStatus[index - a]))),
                ],
              ),
        Container(
          margin: const EdgeInsets.only(top: 5, bottom: 5, left: 75, right: 10),
          height: 1,
          color: Colors.grey.shade300,
        ),
      ],
    );
  }
}

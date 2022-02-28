import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/appbar.dart';

import 'package:hr_app/Constants/colors.dart';
import 'package:intl/intl.dart';

/* ShowAnnoucementScreen appears when users press on notifation dialog 
   then dialog navigate to this screen and show th information  which 
 notifation dialog conatins. */

class ShowAnnouncementScreen extends StatefulWidget {
  // ignore: prefer_typing_uninitialized_variables
  final docId;
  const ShowAnnouncementScreen({Key? key, this.docId}) : super(key: key);
  @override
  _ShowAnnouncementScreenState createState() => _ShowAnnouncementScreenState();
}

class _ShowAnnouncementScreenState extends State<ShowAnnouncementScreen> {
  String? title;
  String? description;
  Timestamp? time;
  List employees = [];
  Connectivity? connectivity;
  StreamSubscription<ConnectivityResult>? subscription;
  bool isNetwork = true;
  int myMaxLines = 3;
  bool isExpaneded = false;
  bool loading = true;
  @override
  void initState() {
    super.initState();
    //check internet connection
    connectivity = Connectivity();
    subscription =
        connectivity!.onConnectivityChanged.listen((ConnectivityResult result) {
      // ignore: avoid_print
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

    setState(() {
      loadAnnouncementInfo();
    });
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        loading = false;
      });
    });
  }

  loadAnnouncementInfo() {
    FirebaseFirestore.instance
        .collection("announcements")
        .doc("${widget.docId}")
        .snapshots()
        .listen((onData) {
      title = onData.data()!["announcementTitle"];
      description = onData.data()!["announcementDes"];
      time = onData.data()!["timeStamp"];
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
        extendBodyBehindAppBar: true,
        body: Stack(children: [
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'Announcement', true),
            ],
            body: loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: isExpaneded == true
                          ? null
                          : description!.length > 140
                              ? 225
                              : 165,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 15, vertical: 20),
                      decoration: BoxDecoration(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10),
                        ),
                        border: Border.all(
                            color: Colors.grey.withOpacity(0.1), width: 2),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            title!,
                            style: const TextStyle(
                              color: purpleDark, //color red
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                          const SizedBox(height: 20),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (isExpaneded != true)
                                Text(
                                  description!,
                                  maxLines: myMaxLines,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                  ),
                                ),
                              if (isExpaneded == true)
                                Text(
                                  description!,
                                  style: const TextStyle(
                                    height: 1.5,
                                    fontSize: 15,
                                  ),
                                ),
                              if (description!.length > 140)
                                Padding(
                                  padding: const EdgeInsets.only(top: 15),
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        isExpaneded = !isExpaneded;
                                      });
                                    },
                                    child: Text(
                                      isExpaneded != true
                                          ? 'Readmore!'
                                          : 'Readless!',
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: purpleLight),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          Text(
                            DateFormat.jm().add_yMd().format(
                                DateTime.parse(time!.toDate().toString())),
                            style: const TextStyle(
                              fontSize: 10,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )),
          )
        ]));
  }
}

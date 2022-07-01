import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/Constants/colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class LeaveHistoryCard extends StatefulWidget {
  final bodyContent, team;

  const LeaveHistoryCard(this.bodyContent, this.team, {Key? key})
      : super(key: key);

  @override
  State<LeaveHistoryCard> createState() => _LeaveHistoryCardState();
}

class _LeaveHistoryCardState extends State<LeaveHistoryCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                flex: 7,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    widget.team
                        ? StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('employees')
                                .doc(widget.bodyContent['empId'])
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<DocumentSnapshot> snapshot) {
                              return Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  snapshot.hasData
                                      ? CircleAvatar(
                                          backgroundColor: Colors.transparent,
                                          radius: 20,
                                          child: ClipRRect(
                                            clipBehavior: Clip.antiAlias,
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            child: snapshot.data![
                                                            "imagePath"] ==
                                                        null ||
                                                    snapshot.data![
                                                            "imagePath"] ==
                                                        ''
                                                ? Image.asset(
                                                    'assets/placeholder.png',
                                                    fit: BoxFit.cover,
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: snapshot
                                                        .data!["imagePath"]!,
                                                    fit: BoxFit.cover,
                                                    height: 40,
                                                    width: 40,
                                                    progressIndicatorBuilder: (context,
                                                            url,
                                                            downloadProgress) =>
                                                        CircularProgressIndicator(
                                                      value: downloadProgress
                                                          .progress,
                                                      color: Colors.white,
                                                    ),
                                                    errorWidget: (context, url,
                                                            error) =>
                                                        const Icon(Icons.error),
                                                  ),
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person,
                                          color: Colors.grey,
                                        ),
                                  const SizedBox(width: 15),
                                  Text(
                                    snapshot.hasData
                                        ? snapshot.data!["displayName"]!
                                        : "",
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: purpleDark,
                                    ),
                                  ),
                                ],
                              );
                            })
                        : Container(),
                    SizedBox(height: widget.team ? 5 : 0),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      height: 30,
                      child: RichText(
                        text: TextSpan(
                          text: widget.bodyContent["leaveType"],
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                          children: <TextSpan>[
                            TextSpan(
                                text: " Applied from " +
                                    widget.bodyContent["from-to-date"]
                                        .replaceAll("-", "to"),
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.normal,
                                )),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      margin: const EdgeInsets.only(left: 10, right: 10),
                      child: Text(
                        DateFormat.jm()
                            .add_yMd()
                            .format(DateTime.parse(widget
                                .bodyContent["timeStamp"]
                                .toDate()
                                .toString()))
                            .toString(),
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey.shade700),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 3,
                child: Container(
                    decoration: BoxDecoration(
                        color: widget.bodyContent['leaveStatus'] == 'approved'
                            ? Colors.green
                            : widget.bodyContent['leaveStatus'] == 'rejected'
                                ? Colors.red
                                : widget.bodyContent['leaveStatus'] == 'pending'
                                    ? Colors.yellow.shade700
                                    : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          width: 1.0,
                          color: widget.bodyContent['leaveStatus'] == 'approved'
                              ? Colors.green
                              : widget.bodyContent['leaveStatus'] == 'rejected'
                                  ? Colors.red
                                  : widget.bodyContent['leaveStatus'] ==
                                          'pending'
                                      ? Colors.yellow.shade700
                                      : Colors.grey.shade300,
                        )),
                    child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.bodyContent['leaveStatus'].toUpperCase(),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: widget.bodyContent['leaveStatus'] ==
                                      'approved'
                                  ? Colors.white
                                  : widget.bodyContent['leaveStatus'] ==
                                          'rejected'
                                      ? Colors.white
                                      : widget.bodyContent['leaveStatus'] ==
                                              'pending'
                                          ? Colors.white
                                          : Colors.grey,
                              fontSize: 12),
                        ))),
              ),
            ],
          ),
          SizedBox(height: widget.bodyContent['reason'] == "" ? 1 : 15.0),
          Container(
            margin: const EdgeInsets.only(left: 10, right: 10),
            child: Text(
              widget.bodyContent['reason'],
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 1,
            margin: const EdgeInsets.only(left: 10, right: 10),
            color: Colors.grey.shade300,
          )
        ],
      ),
    );
  }
}

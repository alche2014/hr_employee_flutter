import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/Components/model.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class AnnouncementCard extends StatelessWidget {
  AnnouncementCard({Key? key, required this.model, required this.fulltext})
      : super(key: key);
  MyAnnouncement model;
  bool fulltext;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Container(
        // margin: EdgeInsets.symmetric(vertical: 10),
        width: MediaQuery.of(context).size.width * 0.9,

        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(width: 1, color: Colors.grey)),
        //-----------------text in card-----------------
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              model.text1!,
              style: TextStyle(
                color: Colors.red[800],
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Text(
                    model.text2!,
                    maxLines: fulltext == false ? 4 : null,
                    style: const TextStyle(
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 50),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  DateFormat.jm()
                      .add_yMd()
                      .format(DateTime.parse(model.date!.toDate().toString()))
                      .toString(),
                  // model.date.toString(),
                  style: const TextStyle(
                    fontSize: 10,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

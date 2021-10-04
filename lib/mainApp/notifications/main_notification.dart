import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';

//---------------Notification----------------//

// ignore: must_be_immutable
class MainNotification extends StatelessWidget {
  String date = '16:04  20-10-2021';
  String note1 = 'Your leave request is approved';
  String note2 = 'Your leave request is rejected';
  String note3 = 'Lorem Added on Announcement';
  IconData icon1 = Icons.check_box;
  IconData icon2 = Icons.cancel;
  IconData icon3 = Icons.campaign;

  MainNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Notification', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('New Notification'),
                      ],
                    ),
                  ),
                  NotificationCard(note1, date, icon1),
                  NotificationCard(note2, date, icon2),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: const [
                        Text('Early'),
                      ],
                    ),
                  ),
                  NotificationCard(note1, date, icon1),
                  NotificationCard(note2, date, icon2),
                  NotificationCard(note3, date, icon3),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
//----------------function--------------------//

// ignore: must_be_immutable
class NotificationCard extends StatelessWidget {
  String text1;
  String text2;
  final IconData next;

  NotificationCard(this.text1, this.text2, this.next, {Key? key})
      : super(key: key) {
    // this.text1 = text1;
    // this.text2 = text2;
    // this.next;
  }
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(
            Radius.circular(10),
          ),
          border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
        ),
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: [
                Icon(
                  next,
                  size: 50,
                  color: Colors.green,
                ),
                const SizedBox(width: 20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Text('Your leave request is approved'),
                    // Text('16:04  20-10-2021',
                    Text(text1), //<==
                    Text(
                      text2,
                      style: const TextStyle(color: Colors.grey),
                    ), //<==
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

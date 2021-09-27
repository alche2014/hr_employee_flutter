import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';

class MainNotificationPage extends StatelessWidget {
  const MainNotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Notification', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              children: const [
                NotificationSwitch(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

bool isSwitched = false;

class NotificationSwitch extends StatefulWidget {
  const NotificationSwitch({Key? key}) : super(key: key);

  @override
  State<NotificationSwitch> createState() => _NotificationSwitchState();
}

class _NotificationSwitchState extends State<NotificationSwitch> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: const [
                  Text(
                    'Notification',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
                //=================================//
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                    });
                  },
                  activeTrackColor: Colors.lightGreenAccent,
                  activeColor: Colors.green,
                ),
              ]),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

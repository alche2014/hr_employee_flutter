import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class Schedular extends StatefulWidget {
  @override
  _SchedularState createState() => _SchedularState();
}

class _SchedularState extends State<Schedular> {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  Future<dynamic> onSelectNotification(String payload) => showDialog(
      context: context,
      builder: (_) => AlertDialog(
          title: const Text("ALERT"), content: Text("CONTENT: $payload")));

  showNotification() async {
    var android =
        const AndroidNotificationDetails('channel id', 'channel name');
    var iOS = const IOSNotificationDetails();
    var platform = NotificationDetails(android: android, iOS: iOS);
    var scheduledNotificationDateTime =
        DateTime.now().add(const Duration(seconds: 10));
    await flutterLocalNotificationsPlugin.schedule(
        0, 'Title ', 'Body', scheduledNotificationDateTime, platform);
  }

  @override
  void initState() {
    super.initState();
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    var android = const AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOS = const IOSInitializationSettings();
    var initSettings = InitializationSettings(android: android, iOS: iOS);
    flutterLocalNotificationsPlugin.initialize(
      initSettings,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Demo"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: showNotification,
        child: const Icon(Icons.notifications),
      ),
    );
  }
}

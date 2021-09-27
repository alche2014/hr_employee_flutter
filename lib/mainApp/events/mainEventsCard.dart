import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';

import 'Model/event_card_data.dart';

class MainEventsCard extends StatelessWidget {
  const MainEventsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMyAppBar(context, 'Event', true),
      body: ListView.builder(
        itemCount: myevents.length,
        itemBuilder: (_, index) {
          return Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
              child: myevents[index]);
        },
      ),
    );
  }
}

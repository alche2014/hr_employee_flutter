// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';

import 'Model/event_card_data.dart';

class MainEventsCard extends StatelessWidget {
  const MainEventsCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: true,
      body: Stack(
        children: [
          const BackgroundCircle(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'My Team', true),
            ],
            body: ListView.builder(
              itemCount: myevents.length,
              itemBuilder: (_, index) {
                return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: myevents[index]);
              },
            ),
          ),
        ],
      ),
    );
  }
}

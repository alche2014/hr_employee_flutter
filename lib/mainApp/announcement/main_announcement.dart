import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/announcement/utility/ann_card.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/content/list_of_data.dart';

class MainAnnouncement extends StatelessWidget {
  const MainAnnouncement({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          const BackgroundCircle(),
          NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) => [
              buildMyNewAppBar(context, 'Announcement', true),
            ],
            body: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: ListView.builder(
                  itemCount: mainAnnCardData.length,
                  itemBuilder: (context, index) {
                    return AnnCard(mainAnnCardData[index]);
                  }),
            ),
          ),
        ],
      ),
    );
  }
}


// const BackgroundCircle(),
// appBar: 

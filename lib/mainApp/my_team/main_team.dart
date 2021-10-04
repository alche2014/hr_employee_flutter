import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/my_team/utility/list_of_team.dart';

class MyTeam extends StatelessWidget {
  const MyTeam({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'My Team', false),
      body: Stack(
        children: const [
          BackgroundCircle(),
          TeamAllView(),
        ],
      ),
    );
  }
}

class TeamAllView extends StatelessWidget {
  const TeamAllView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        // scrollDirection: Axis.horizontal,
        itemCount: teamCardData.length,
        itemBuilder: (context, index) => teamCardData[index]);
  }
}

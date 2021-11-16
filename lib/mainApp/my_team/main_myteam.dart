// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers
import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/mainApp/main_home_profile/main_home_profile.dart';

class MyTeamProfile extends StatelessWidget {
  const MyTeamProfile({Key? key}) : super(key: key);

  // final keyProfile = GlobalKey<_MainHomeProfileState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'My Team', true),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ignore: sized_box_for_whitespace
            UpperPortion(),
            //================================//
            ProfileCard(
                headTitle: 'Personal Information',
                press: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MainHomeProfile()));
                }),
            ProfileCard(headTitle: 'Attendence', press: () {}),
            ProfileCard(headTitle: 'Requests', press: () {}),
            SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}

//===============================================//
class UpperPortion extends StatelessWidget {
  const UpperPortion({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.40,
      child: Stack(
        children: [
          //--------------backimage-----------------//
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 300,
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage('assets/foggy.jpg'),
                fit: BoxFit.cover,
              )),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  // crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          ProfilePic(),
                          IconButton(
                              onPressed: () {},
                              icon: Icon(Icons.edit_outlined,
                                  size: 30, color: Colors.white)),
                        ]),
                  ],
                ),
              ),
            ),
          ),
          //--------------backimage-end-----------------//

          //--------------mainWhite-Back-of-CenterCard---------------//
          Positioned(
            top: MediaQuery.of(context).size.height * 0.35,
            left: 0,
            right: 0,
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                color: Theme.of(context).scaffoldBackgroundColor,
              ),
            ),
          ),
          //-------------mainWhite--end-Back-of-CenterCard----------//
        ],
      ),
    );
  }
}

//====================================================//

class ProfilePic extends StatelessWidget {
  const ProfilePic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        child: Row(children: [
          SizedBox(width: 10),
          CircleAvatar(
            radius: (40),
            backgroundColor: Colors.transparent,
            child: ClipRRect(
              clipBehavior: Clip.antiAlias,
              borderRadius: BorderRadius.circular(100),
              child: Image.asset("assets/user_image.png"),
            ),
          ),
          SizedBox(width: 20),
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Text('Name Here',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Colors.white)),
            SizedBox(height: 10),
            Text('Front-End UI', style: TextStyle(color: Colors.white)),
          ]),
        ]),
      ),
    );
  }
}

//=========================================================================//

// ignore: must_be_immutable
class ProfileCard extends StatelessWidget {
  //reused card
  String? headTitle;
  final VoidCallback? press;

  ProfileCard({
    this.headTitle,
    this.press,
  });
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        onTap: press,
        borderRadius: BorderRadius.circular(10),
        child: Container(
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            //============================================//
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                //=========================================//
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Color(0xffF8E7E9),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(100),
                      child: Image.asset('assets/custom/person.png'),
                    ),
                  ),
                  SizedBox(width: 10),
                  Text('$headTitle',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                ]),
                //===============================================//
                CircleAvatar(
                  radius: 15,
                  backgroundColor: Color(0xffF8E7E9),
                  child: IconButton(
                    onPressed: () {},
                    icon: Icon(Icons.arrow_forward_ios,
                        size: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/check_in_history/main_check_in.dart';

import '../mainEventsCard.dart';

final darkRed = Color(0xffbf2634);
final lightPink = Color(0xffF8E7E9);
final lightGreen = Color(0xffD6FBE0);

class StackedPics extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //.................images in row + butons.....................
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Row(
              children: [
                Container(
                  height: 50,
                  width: 140,
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        left: 80,
                        // right: 0,
                        // bottom: 0,
                        child: Container(
                          // width: 50,
                          // height: 50,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset('assets/user.png'),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 40,
                        child: Container(
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset('assets/user.png'),
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        top: 0,
                        left: 0,
                        // right: 0,
                        // bottom: 0,
                        child: Container(
                          // width: 50,
                          // height: 50,
                          padding: EdgeInsets.all(5),
                          decoration: BoxDecoration(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              borderRadius: BorderRadius.circular(100)),
                          child: CircleAvatar(
                            radius: 20,
                            backgroundColor: Colors.white,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.asset('assets/user.png'),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (contex) => MainCheckIn()));
                  },
                  child: Text(
                    'SHOW',
                    style: TextStyle(color: darkRed),
                  ),
                ),
              ],
            ),
          ),
          // SizedBox(width: 70),
          SizedBox(
            width: 100,
            // height: 50,
            child: ElevatedButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) => const MainEventsCard()),
                );
              },
              child: Text(
                'Join',
                style: TextStyle(color: Colors.white),
              ),
              style: ElevatedButton.styleFrom(primary: darkRed),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:hr_app/MainApp/HomeScreen.dart';
import 'package:hr_app/MainApp/settings.dart';
import 'package:hr_app/UserprofileScreen.dart/my_profile_edit.dart';
import 'package:hr_app/mainApp/LeaveManagement/leave_history.dart';

import 'main_home_profile/homeScreen.dart';

int? count;
String? user;

class NavBar extends StatefulWidget {
  NavBar(int a, {Key? key}) : super(key: key) {
    count = a;
  }
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentindex = count!;

  final tabs = [
    // Assigning Tabs for bottom bar position Icon
    const Center(child: HrDashboard()),
    const Center(child: LeaveHistory(value: false)),
    const Center(child: MyProfileEdit()),
    const Center(child: SettingsScreen()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[_currentindex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentindex,
            type: BottomNavigationBarType.fixed,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: [
              BottomNavigationBarItem(
                  icon: Image.asset("assets/Home.png", height: 20),
                  activeIcon: Image.asset("assets/homeActive.png", height: 35),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/leavesInactive.png", height: 25),
                  activeIcon:
                      Image.asset("assets/leavesActive.png", height: 35),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/historyInactive.png", height: 25),
                  activeIcon:
                      Image.asset("assets/historyActive.png", height: 35),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/settingsInactive.png", height: 25),
                  activeIcon:
                      Image.asset("assets/settingsActive.png", height: 35),
                  label: ""),
            ],
            onTap: (index) async {
              setState(() {
                _currentindex = index;
              });
            }));
  }
}

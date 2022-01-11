import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/forms/form_2.dart';
import 'package:hr_app/mainApp/leave_management/leave_management.dart';
import 'package:hr_app/mainApp/mainProfile/Announcemets/screen_announcement.dart';
import 'package:hr_app/mainApp/mainProfile/my_profile_edit.dart';
import 'package:hr_app/mainApp/main_home_profile/main_home_profile.dart';
import 'package:hr_app/models/user.dart';
import 'package:hr_app/settings.dart';

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
    const Center(child: MainHomeProfile()),
    const Center(child: LeaveManagement()),
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
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.note_alt_outlined), label: ""),
              BottomNavigationBarItem(icon: Icon(Icons.person), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.more_horiz_outlined), label: ""),
            ],
            onTap: (index) {
              setState(() {
                _currentindex = index;
              });
            }));
  }
}

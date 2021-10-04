import 'package:flutter/material.dart';
import 'package:hr_app/mainApp/Announcement/main_announcement.dart';
import 'package:hr_app/mainApp/Personal_Info/main_personal_info.dart';
import 'package:hr_app/mainApp/leave_management/leave_management.dart';
import 'package:hr_app/mainApp/mainProfile/my_profile_edit.dart';

int? count;

class NavBar extends StatefulWidget {
  NavBar(int a, {Key? key}) : super(key: key) {
    //Intializing Globle variable for indexing nav position
    count = a;
  }
  @override
  _NavBarState createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  int _currentindex = count!;

  final tabs = [
    //Assigning Tabs for bottom bar position Icon
    const Center(child: MyProfileEdit()),
    const Center(child: MainAnnouncement()),
    const Center(child: LeaveManagement()),
    const Center(child: MainPersonal_Info()),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: tabs[_currentindex],
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: _currentindex,
            type: BottomNavigationBarType.fixed,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_add_alt_1), label: ""),
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

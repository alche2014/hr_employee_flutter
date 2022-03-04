import 'package:flutter/material.dart';
import 'package:hr_app/MainApp/CheckIn/main_check_in.dart';
import 'package:hr_app/MainApp/HomeScreen.dart';
import 'package:hr_app/MainApp/settings.dart';
import 'package:hr_app/mainApp/LeaveManagement/leave_history.dart';

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
    const Center(child: MainCheckIn()),
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
                      Image.asset("assets/historyActive.png", height: 30),
                  label: ""),
              BottomNavigationBarItem(
                  icon: Image.asset("assets/settingsInactive.png", height: 25),
                  activeIcon:
                      Image.asset("assets/settingsActive.png", height: 30),
                  label: ""),
            ],
            onTap: (index) async {
              setState(() {
                _currentindex = index;
              });
            }));
  }
}

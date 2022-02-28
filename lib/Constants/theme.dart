import 'package:flutter/material.dart';
import 'package:hr_app/Constants/constants.dart';

ThemeData lightThemeData(BuildContext context) {
  return ThemeData.light().copyWith(
    primaryColor: kPrimaryColor,
    // secondaryHeaderColor: Colors.black,
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: appBarTheme,
    iconTheme: const IconThemeData(color: kContentColorLightTheme),
    // textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: kContentColorLightTheme),
    colorScheme: const ColorScheme.light(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: Colors.white,
      selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
      unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
      selectedIconTheme: IconThemeData(color: kPrimaryColor),
    ),
    tabBarTheme: tabBarTheme,
  );
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
    primaryColor: kPrimaryColor,
    scaffoldBackgroundColor: kContentColorLightTheme,
    appBarTheme: appBarThemedark,
    iconTheme: const IconThemeData(color: kContentColorDarkTheme),
    // textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
    //     .apply(bodyColor: kContentColorDarkTheme),
    colorScheme: const ColorScheme.dark().copyWith(
      primary: kPrimaryColor,
      secondary: kSecondaryColor,
      error: kErrorColor,
    ),
    bottomNavigationBarTheme: BottomNavigationBarThemeData(
      backgroundColor: kContentColorLightTheme,
      selectedItemColor: Colors.white70,
      unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
      selectedIconTheme: const IconThemeData(color: kPrimaryColor),
      // selectedLabelStyle: TextStylecolor: kPrimaryColor),
    ),
    tabBarTheme: tabBarThemedark,
  );
}

final appBarTheme = AppBarTheme(centerTitle: false, elevation: 0);

final appBarThemedark = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  // backgroundColor: kPrimaryColor,
);
final tabBarTheme = TabBarTheme(
    labelColor: Colors.black, unselectedLabelColor: Colors.grey[800]);
final tabBarThemedark = TabBarTheme(labelColor: Colors.white);

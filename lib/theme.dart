// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'colors.dart';
import 'style.dart';


ThemeData lightTheme(BuildContext context) {
  return ThemeData.light().copyWith(
      primaryColor: kPrimaryRed,
      scaffoldBackgroundColor: Colors.white,
      appBarTheme: const AppBarTheme(),
      iconTheme: const IconThemeData(color: kContentColorLightTheme),
      textTheme: TextTheme(
        headline1: TilteTextStyle,
        headline2: TilteTextStyle,
        headline3: TilteTextStyle,
        headline4: TilteTextStyle,
        headline5: TilteTextStyle,
        headline6: TilteTextStyle,
        subtitle1: TilteTextStyle,
        subtitle2: TilteTextStyle,
        bodyText1: TilteTextStyle,
        bodyText2: TilteTextStyle,
        button: TilteTextStyle,
      ),
      // textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme)
      //     .apply(bodyColor: kContentColorLightTheme),
      colorScheme: const ColorScheme.light(
        primary: kPrimaryRed,
        secondary: kSecondaryDarkYellow,
        error: kErrorRedColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: Colors.white,
        selectedItemColor: kContentColorLightTheme.withOpacity(0.7),
        unselectedItemColor: kContentColorLightTheme.withOpacity(0.32),
        selectedIconTheme: const IconThemeData(color: kPrimaryRed),
      ));
}

ThemeData darkThemeData(BuildContext context) {
  return ThemeData.dark().copyWith(
      primaryColor: kPrimaryRed,
      scaffoldBackgroundColor: kContentColorLightTheme,
      appBarTheme: appBarTheme,
      iconTheme: const IconThemeData(color: kContentColorDarkTheme),
      textTheme: TextTheme(
        headline1: TilteDarkTextStyle,
        headline2: TilteDarkTextStyle,
        headline3: TilteDarkTextStyle,
        headline4: TilteDarkTextStyle,
        headline5: TilteDarkTextStyle,
        headline6: TilteDarkTextStyle,
        subtitle1: TilteDarkTextStyle,
        subtitle2: TilteDarkTextStyle,
        bodyText1: TilteDarkTextStyle,
        bodyText2: TilteDarkTextStyle,
        button: TilteDarkTextStyle,
      ),
      // GoogleFonts.interTextTheme(Theme.of(context).textTheme)
      //     .apply(bodyColor: Colors.grey),
      colorScheme: const ColorScheme.dark().copyWith(
        primary: kPrimaryRed,
        secondary: kSecondaryDarkYellow,
        error: kErrorRedColor,
      ),
      bottomNavigationBarTheme: BottomNavigationBarThemeData(
        backgroundColor: kContentColorLightTheme,
        selectedItemColor: Colors.white70,
        unselectedItemColor: kContentColorDarkTheme.withOpacity(0.32),
        selectedIconTheme: const IconThemeData(color: kPrimaryRed),
      ));
}

const appBarTheme = AppBarTheme(
  centerTitle: false,
  elevation: 0,
  toolbarTextStyle: AppBarTextStyle,
  );
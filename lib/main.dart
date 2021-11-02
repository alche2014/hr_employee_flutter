import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hr_app/Log%20Screen/sign_in.dart';
import 'theme.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: lightTheme(context),
      darkTheme: darkThemeData(context),
      home: const SignIn(),
    );
  }
}

// home: const MainTesting(),
// home: const SignIn(),
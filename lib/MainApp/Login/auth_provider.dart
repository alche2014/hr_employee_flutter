import 'package:flutter/material.dart';
import 'package:hr_app/MainApp/Login/auth.dart';

// import 'auth.dart';

class AuthProvider extends InheritedWidget {
  const AuthProvider({Key? key, required Widget child, required this.auth})
      : super(key: key, child: child);
  final AuthService auth;

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  // static AuthProvider of(BuildContext context) {
  //   return context.dependOnInheritedWidgetOfExactType<AuthProvider>();
  // }
}

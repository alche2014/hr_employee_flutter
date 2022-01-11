// import 'package:flutter/material.dart';
// import 'package:flutter_facebook_login/flutter_facebook_login.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert' as JSON;

// class FbLoginScreen extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     // TODO: implement createState
//     return _FbLoginScreenState();
//   }
// }

// class _FbLoginScreenState extends State<FbLoginScreen> {
//   bool _isLoggedIn = false;
//   Map userProfile;
//   final facebookLogin = FacebookLogin();

//   _loginWithFB() async {
//     final result = await facebookLogin.logInWithReadPermissions(['email']);

//     switch (result.status) {
//       case FacebookLoginStatus.loggedIn:
//         final token = result.accessToken.token;
//         final graphResponse = await http.get(
//             'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email,picture&access_token=${token}');
//         final profile = JSON.jsonDecode(graphResponse.body);
//         print(profile);
//         setState(() {
//           userProfile = profile;
//           _isLoggedIn = true;
//         });
//         break;

//       case FacebookLoginStatus.cancelledByUser:
//         setState(() => _isLoggedIn = false);
//         break;
//       case FacebookLoginStatus.error:
//         setState(() => _isLoggedIn = false);
//         break;
//     }
//   }

//   _logout() {
//     facebookLogin.logOut();
//     setState(() {
//       _isLoggedIn = false;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     // TODO: implement build
//     return Scaffold(
//       body: Center(
//           child: _isLoggedIn
//               ? Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: <Widget>[
//                     Image.network(
//                       userProfile["picture"]["data"]["url"],
//                       height: 50.0,
//                       width: 50.0,
//                     ),
//                     Text(userProfile["name"]),
//                     Text(userProfile["first_name"]),
//                     Text(userProfile["last_name"]),
//                     Text(userProfile["email"]),
//                     OutlineButton(
//                       child: Text("Logout"),
//                       onPressed: () {
//                         _logout();
//                       },
//                     )
//                   ],
//                 )
//               : Center(
//                   child: OutlineButton(
//                     child: Text("Login with Facebook"),
//                     onPressed: () {
//                       _loginWithFB();
//                     },
//                   ),
//                 )),
//     );
//   }
// }

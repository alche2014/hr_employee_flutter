// import 'package:flutter/material.dart';
// import 'package:linkedin_login/linkedin_login.dart';

// // void main() => runApp(MyApp());

// // @TODO IMPORTANT - you need to change variable values below
// // You need to add your own data from LinkedIn application
// // From: https://www.linkedin.com/developers/
// // Please read step 1 from this link https://developer.linkedin.com/docs/oauth2
// final String redirectUrl = 'https://app.carde.de';
// final String clientId = '776rnw4e4izlvg';
// final String clientSecret = 'rQEgboUHMLcQi59v';

// class LinkedInProfileExamplePage extends StatefulWidget {
//   @override
//   State createState() => _LinkedInProfileExamplePageState();
// }

// class _LinkedInProfileExamplePageState
//     extends State<LinkedInProfileExamplePage> {
//   UserObject user;
//   bool logoutUser = false;

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//           mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisSize: MainAxisSize.max,
//           children: <Widget>[
//             LinkedInButtonStandardWidget(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (BuildContext context) => LinkedInUserWidget(
//                       appBar: AppBar(
//                         title: Text('OAuth User'),
//                       ),
//                       destroySession: logoutUser,
//                       redirectUrl: redirectUrl,
//                       clientId: clientId,
//                       clientSecret: clientSecret,
//                       onGetUserProfile: (LinkedInUserModel linkedInUser) {
//                         print('Access token ${linkedInUser.token.accessToken}');

//                         print(
//                             'User id: ${linkedInUser.profilePicture.toString()}');

//                         user = UserObject(
//                             firstName: linkedInUser.firstName.localized.label,
//                             lastName: linkedInUser.lastName.localized.label,
//                             email: linkedInUser
//                                 .email.elements[0].handleDeep.emailAddress,
//                             photo: linkedInUser.profilePicture.displayImage);
//                         setState(() {
//                           logoutUser = false;
//                         });

//                         Navigator.pop(context);
//                       },
//                       catchError: (LinkedInErrorObject error) {
//                         print('Error description: ${error.description},'
//                             ' Error code: ${error.statusCode.toString()}');
//                         Navigator.pop(context);
//                       },
//                     ),
//                     fullscreenDialog: true,
//                   ),
//                 );
//               },
//             ),
//             LinkedInButtonStandardWidget(
//               onTap: () {
//                 setState(() {
//                   user = null;
//                   logoutUser = true;
//                 });
//               },
//               buttonText: 'Logout',
//             ),
//             Container(
//               child: Column(
//                 mainAxisSize: MainAxisSize.max,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Text('First: ${user?.firstName} '),
//                   Text('Last: ${user?.lastName} '),
//                   Image.network(
//                     "${user?.photo}",
//                     height: 50.0,
//                     width: 50.0,
//                   ),
//                   Text('Email: ${user?.email}'),
//                 ],
//               ),
//             ),
//           ]),
//     );
//   }
// }

// class UserObject {
//   String firstName, lastName, email, photo;

//   UserObject({this.firstName, this.lastName, this.email, this.photo});
// }

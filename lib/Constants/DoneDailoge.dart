// import 'package:flutter/material.dart';

// class TestPage extends StatefulWidget {
//   @override
//   State<StatefulWidget> createState() {
//     return TestState();
//   }
// }

// class TestState extends State<TestPage> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           btn1(context),
//           btn2(context),
//           btn3(context),
//           btn4(context),
//         ],
//       ),
//     );
//   }

//   Widget btn1(BuildContext context) {
//     return MaterialButton(
//       color: Colors.grey[300],
//       minWidth: 300,
//       onPressed: () => Dialogs.materialDialog(
//           msg: 'Are you sure ? you can\'t undo this',
//           title: "Delete",
//           color: Colors.white,
//           context: context,
//           actions: [
//             IconsOutlineButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               text: 'Cancel',
//               iconData: Icons.cancel_outlined,
//               textStyle: TextStyle(color: Colors.grey),
//               iconColor: Colors.grey,
//             ),
//             IconsButton(
//               onPressed: () {},
//               text: "Delete",
//               iconData: Icons.delete,
//               color: Colors.red,
//               textStyle: TextStyle(color: Colors.white),
//               iconColor: Colors.white,
//             ),
//           ]),
//       child: Text("Show Material Dialog"),
//     );
//   }

//   Widget btn2(BuildContext context) {
//     return MaterialButton(
//       minWidth: 300,
//       color: Colors.grey[300],
//       onPressed: () => Dialogs.bottomMaterialDialog(
//           msg: 'Are you sure? you can\'t undo this action',
//           title: 'Delete',
//           context: context,
//           actions: [
//             IconsOutlineButton(
//               onPressed: () {
//                 Navigator.of(context).pop();
//               },
//               text: 'Cancel',
//               iconData: Icons.cancel_outlined,
//               textStyle: TextStyle(color: Colors.grey),
//               iconColor: Colors.grey,
//             ),
//             IconsButton(
//               onPressed: () {},
//               text: 'Delete',
//               iconData: Icons.delete,
//               color: Colors.red,
//               textStyle: TextStyle(color: Colors.white),
//               iconColor: Colors.white,
//             ),
//           ]),
//       child: Text("Show Bottom Material Dialog"),
//     );
//   }

//   Widget btn3(BuildContext context) {
//     return MaterialButton(
//       minWidth: 300,
//       color: Colors.grey[300],
//       onPressed: () => Dialogs.materialDialog(
//         color: Colors.white,
//         msg: 'Congratulations, you won 500 points',
//         title: 'Congratulations',
//         lottieBuilder: Lottie.asset(
//           'assets/cong_example.json',
//           fit: BoxFit.contain,
//         ),
//         context: context,
//         actions: [
//           IconsButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             text: 'Claim',
//             iconData: Icons.done,
//             color: Colors.blue,
//             textStyle: TextStyle(color: Colors.white),
//             iconColor: Colors.white,
//           ),
//         ],
//       ),
//       child: Text("Show animations Material Dialog"),
//     );
//   }

//   Widget btn4(BuildContext context) {
//     return MaterialButton(
//       color: Colors.grey[300],
//       minWidth: 300,
//       onPressed: () => Dialogs.bottomMaterialDialog(
//         msg: 'Congratulations, you won 500 points',
//         title: 'Congratulations',
//         color: Colors.white,
//         lottieBuilder: Lottie.asset(
//           'assets/cong_example.json',
//           fit: BoxFit.contain,
//         ),
//         context: context,
//         actions: [
//           IconsButton(
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//             text: 'Claim',
//             iconData: Icons.done,
//             color: Colors.blue,
//             textStyle: TextStyle(color: Colors.white),
//             iconColor: Colors.white,
//           ),
//         ],
//       ),
//       child: Text("Show animations Bottom Dialog"),
//     );
//   }
// }

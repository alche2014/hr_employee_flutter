import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:hr_app/Constants/appbar.dart';

class AboutApp extends StatefulWidget {
  const AboutApp({Key? key}) : super(key: key);

  @override
  State<AboutApp> createState() => _AboutAppState();
}

class _AboutAppState extends State<AboutApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: buildMyAppBar(context, 'About', true),
        body: Stack(children: [
          Container(
            padding: Platform.isIOS
                ? const EdgeInsets.only(bottom: 50, top: 120)
                : const EdgeInsets.only(bottom: 15, top: 15),
            child: StreamBuilder<DocumentSnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('aboutPrivacy')
                    .doc("aboutAdmin")
                    .snapshots(),
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (snapshot.hasError) {
                    return const Center(child: Text("Error"));
                  } else if (snapshot.hasData) {
                    return SingleChildScrollView(
                      child: Column(children: [
                        const SizedBox(height: 20),
                        Center(
                            child: Image.asset('assets/aboutimage.png',
                                height: 198)),
                        const SizedBox(height: 20),
                        //-----------------------------------------------------------//
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(snapshot.data!["header"],
                                    style: const TextStyle(
                                        fontSize: 18,
                                        color: Color(0XFFC53B4B))),
                                const SizedBox(height: 20),
                                Text(snapshot.data!["body"],
                                    style: const TextStyle(
                                        height: 1.5,
                                        fontSize: 13,
                                        color: Color(0XFF5B5B5B))),
                                const SizedBox(height: 40),
                              ]),
                        ),
                        //-----------------------------------------------------------//
                      ]),
                    );
                  } else {
                    return SpinKitCircle(
                      itemBuilder: (_, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven ? Colors.black : Colors.white,
                          ),
                        );
                      },
                      size: 30.0,
                    );
                  }
                }),
          )
        ]));
  }
}
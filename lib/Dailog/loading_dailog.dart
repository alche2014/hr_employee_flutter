import 'package:flutter/material.dart';
import 'package:hr_app/main.dart';

//loading screens apears  press on tabs
class LoadingDialog extends StatefulWidget {
  LoadingDialog({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LoadingDialogState();
}

class LoadingDialogState extends State<LoadingDialog>
    with SingleTickerProviderStateMixin {
  AnimationController? controller;
  Animation<double>? scaleAnimation;

  @override
  void initState() {
    super.initState();
    // popScreen();
    controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 540));
    scaleAnimation =
        CurvedAnimation(parent: controller!, curve: Curves.elasticInOut);

    controller!.addListener(() {
      setState(() {});
    });

    controller!.forward();
  }

  popScreen() async {
    await Future.delayed(Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: _willPopCallback,
        child: Scaffold(
          backgroundColor: Colors.black.withOpacity(0.45),
          body: Center(
            heightFactor: MediaQuery.of(context).size.width - 30,
            //  widthFactor: MediaQuery.of(context).size.width-30,
            child: Material(
              color: Colors.transparent,
              child: ScaleTransition(
                  scale: scaleAnimation!,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: EdgeInsets.all(20.0),
                    padding: EdgeInsets.all(15.0),
                    decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(4.0))),
                    height: 80,
                    // color: Colors.white,
                    // width: MediaQuery.of(context).size.width,
                    child: ListTile(
                        leading: Container(
                          width: 30,
                          height: 30,
                          child: CircularProgressIndicator(
                            strokeWidth: 2.5,
                          ),
                        ),
                        title: Text("Loading",
                            style: TextStyle(color: Colors.black))),
                  )),
            ),
          ),
        ));
  }

  String validatePhone(String value) {
    // final RegExp phoneExp = RegExp(r'^\d\d\d\d\d\d\d\d\d\d\d$');

    if (value.length == 0) {
      return "Code can't be empty";
    } else if (value.length < 4 && value.length > 6) {
      return "Code is not correct";
    }
    return "null";
  }
}

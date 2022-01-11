import 'package:flutter/material.dart';

//loading screens apears  press on tabs
class LoadingDialog2 extends StatefulWidget {
  final String? value;
  const LoadingDialog2({Key? key, this.value}) : super(key: key);
  @override
  State<StatefulWidget> createState() => LoadingDialog2State();
}

class LoadingDialog2State extends State<LoadingDialog2>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();
    // popScreen();
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 540));
    scaleAnimation =
        CurvedAnimation(parent: controller, curve: Curves.elasticInOut);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  popScreen() async {
    await Future.delayed(const Duration(seconds: 2), () {
      Navigator.of(context).pop();
    });
  }

  Future<bool> _willPopCallback() async {
    return false; // return true if the route to be popped
  }

  @override
  void dispose() {
    controller.dispose();
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
                  scale: scaleAnimation,
                  child: Container(
                    width: MediaQuery.of(context).size.width - 50,
                    margin: const EdgeInsets.all(20.0),
                    padding: const EdgeInsets.all(15.0),
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
                        child: const CircularProgressIndicator(
                          strokeWidth: 2.5,
                        ),
                      ),
                      title: Text("${widget.value}"),
                    ),
                  )),
            ),
          ),
        ));
  }
}

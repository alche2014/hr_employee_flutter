import 'package:flutter/material.dart';

import '../../../colors.dart';

class TeamCard extends StatelessWidget {
  final String imageName;
  final String status;
  // final VoidCallback? press;
  TeamCard(this.imageName, this.status, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {},
        child: Container(
          width: MediaQuery.of(context).size.width,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(
              Radius.circular(10),
            ),
            border: Border.all(color: Colors.grey.withOpacity(0.1), width: 2),
            //========================================//
            // color: MediaQuery.of(context).platformBrightness == Brightness.light
            //     ? Colors.white
            //     : const Color(0xff34354A),
          ),
          child:
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              CircleAvatar(
                radius: (35),
                backgroundColor: Colors.transparent,
                child: ClipRRect(
                  // borderRadius: BorderRadius.circular(50),
                  child: Image.asset("assets/$imageName.png"),
                ),
              ),
              //======================================//
              const SizedBox(width: 20),
              Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text('Lee Williamson',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    SizedBox(height: 15),
                    Text('Designation', style: TextStyle(color: Colors.grey)),
                  ]),
            ]),
            //===============================================//
            if (status == '') const SizedBox(),
            if (status != '')
              Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: status == 'on Time' ? lightGreen : lightPink,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: status == 'on Time'
                        ? const Text('on Time', textAlign: TextAlign.center)
                        : const Text('Late', textAlign: TextAlign.center),
                  )),
          ]),
        ),
      ),
    );
  }
}

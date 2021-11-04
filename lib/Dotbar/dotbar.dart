import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DotLineBar extends StatelessWidget {
  DotLineBar(this.counter, {Key? key}) : super(key: key);
  final List<int> steps = [1, 2, 3, 4, 5];
  int counter;

  @override
  Widget build(BuildContext context) {
    // ignore: avoid_unnecessary_containers
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          //-------------Main Container in which bar added---------//
          // ignore: avoid_unnecessary_containers
          Container(
            child: FractionallySizedBox(
              widthFactor: 0.8,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // ignore: avoid_unnecessary_containers
                  Container(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 1,
                    ),
                  ),
                  //---------------Row for vertical Angel bar---------------//
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      for (var step in steps)
                        //-------------Container for customize into Dot-------------//
                        Container(
                          height: 10,
                          width: 10,
                          decoration: BoxDecoration(
                              border: step <= counter
                                  ? Border.all(
                                      width: 1.8,
                                      color: const Color(0xffC53B4B))
                                  : Border.all(
                                      width: 2, color: const Color(0xffEEB8B8)),
                              borderRadius: BorderRadius.circular(20),
                              color: step <= counter
                                  ? const Color(0xffC53B4B)
                                  : const Color(0xFFF5F5F7)),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

//------------------Ignore-------------------//

class OutlineCircle extends StatelessWidget {
  const OutlineCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        // ignore: sized_box_for_whitespace
        child: Container(
          width: 150,
          child: Row(
            children: [
              Icon(Icons.panorama_fish_eye, color: Colors.red[300], size: 15.0),
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 2,
                ),
              ),
              Icon(Icons.panorama_fish_eye, color: Colors.red[300], size: 15.0),
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 2,
                ),
              ),
              Icon(Icons.panorama_fish_eye, color: Colors.red[300], size: 15.0),
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 2,
                ),
              ),
              Icon(Icons.panorama_fish_eye, color: Colors.red[300], size: 15.0),
              Expanded(
                child: Divider(
                  color: Colors.grey[400],
                  thickness: 2,
                ),
              ),
              Icon(Icons.panorama_fish_eye, color: Colors.red[300], size: 15.0),
              //-------------------------------//
              Container(
                height: 10,
                width: 10,
                decoration: BoxDecoration(
                  border:
                      Border.all(width: 1.8, color: const Color(0xffEEB8B8)),
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.transparent,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

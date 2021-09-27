import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';

class BackgroundCircle extends StatelessWidget {
  const BackgroundCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 0,
      child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.only(bottomRight: Radius.circular(100)),
                color: MediaQuery.of(context).platformBrightness == Brightness.light
          ? kCircleColor.withOpacity(0.8)
          : darkRed.withOpacity(0.5),
              ),
            ),
    );
  }
}
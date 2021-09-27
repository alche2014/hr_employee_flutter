import 'package:flutter/material.dart';
import 'package:hr_app/colors.dart';

class CustomCheckbox extends StatefulWidget {
  final String? name;
  final bool? isChecked;
  final double? size;
  final double? iconSize;
  final Color? selectedColor;
  final Color? selectedIconColor;

  // ignore: use_key_in_widget_constructors
  const CustomCheckbox(
      {this.isChecked,
      this.name,
      this.size,
      this.iconSize,
      this.selectedColor,
      this.selectedIconColor});

  @override
  _CustomCheckboxState createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  bool _isSelected = false;

  @override
  void initState() {
    _isSelected = widget.isChecked ?? false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        //============================//
        GestureDetector(
          onTap: () {
              setState(() {
                _isSelected = !_isSelected;
              });
            },
          child: Container(
            height: 20,
            width: 20,
            padding: const EdgeInsets.all(3),
            decoration: BoxDecoration(
              border: Border.all(
                  color: _isSelected
                      ? widget.selectedColor ?? darkRed
                      : Colors.grey.withOpacity(0.4),
                  width: 2),
              borderRadius: BorderRadius.circular(100),
            ),
            //=============================================//
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.fastLinearToSlowEaseIn,
              //====================================//
              decoration: BoxDecoration(
                  color: _isSelected
                      ? widget.selectedColor ?? darkRed
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(100),
                  border: _isSelected
                      ? null
                      : Border.all(
                          color: Colors.transparent,
                          width: 2.0,
                        )),
              width: widget.size ?? 25,
              height: widget.size ?? 25,
              // child: _isSelected ? Icon(
              //   Icons.check,
              //   color: widget.selectedIconColor ?? Colors.white,
              //   size: widget.iconSize ?? 20,
              // ) : null,
            ),
          ),
        ),
        //============================//
        const SizedBox(width: 10),
        const Text('name'),
      ],
    );
  }
}

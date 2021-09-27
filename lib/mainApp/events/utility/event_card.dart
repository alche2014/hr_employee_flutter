import 'package:flutter/material.dart';
import '../../../colors.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class EventCard extends StatelessWidget {
  EventCard({Key? key, this.text, this.date, this.image}) : super(key: key);
  String? text;
  String? image;
  // ignore: prefer_typing_uninitialized_variables
  var date;

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      elevation: 3,
      color: MediaQuery.of(context).platformBrightness == Brightness.light
          ? Colors.white
          : kContentColorLightTheme.withOpacity(0.1),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: () {
          // Navigator.push(
          //     context, MaterialPageRoute(builder: (context) => Events2()));
        },
        child: Container(
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              //--------------image block----------------------
              Container(
                height: MediaQuery.of(context).size.height * 0.18,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(image!),
                    // height: MediaQuery.of(context).size.height *0.17,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              //---------text below picture---------------
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
                child: Row(
                  children: [
                    Column(
                      children: [
                        Text(
                          date.day.toString(),
                          style: TextStyle(fontSize: 38),
                        ),
                        Text(DateFormat.MMM().format(date).toString(),
                            style: TextStyle(
                                color: Colors.red[800], fontSize: 15)),
                      ],
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          text.toString(),
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.red[800],
                          ),
                        ),
                        SizedBox(height: 6),
                        Text(
                            '${date!.hour}:${date!.minute} ${date!.day}/${date!.month}/${date!.year}', //'16:04 20/10/2021',
                            style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/check_in_history/main_check_in.dart';
import 'package:hr_app/mainApp/leave_management/utility/leave_history_card.dart';

import '../../../colors.dart';

String leave = 'Leave Type';
String approved = 'apd';
String no = 'no';

String body =
    'Hello guys we have discussed about post-corona vacation plan and our decision is to go to bali';

class LeaveHistory extends StatelessWidget {
  const LeaveHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Leave History', true),
      body: Stack(children: [
        const BackgroundCircle(),
        Padding(
          padding: const EdgeInsets.only(top: 70),
          child: SingleChildScrollView(
            child: Column(children: [
              const CreateButton(),
              LeaveHistoryCard(leave, body, approved),
              LeaveHistoryCard(leave, '', no),
              LeaveHistoryCard(leave, body, approved),
            ]),
          ),
        ),
      ]),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: FittedBox(
        child: InkWell(
            onTap: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (context) => MainCheckIn()));
            },
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                  height: 20, child: Image.asset('assets/custom/filter.png')),
            )),
      ),
    );
  }
}

class CreateButton extends StatelessWidget {
  const CreateButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        children: [
          OutlinedButton(
            child: const Text("+Create Request"),
            style: OutlinedButton.styleFrom(
                primary: darkRed,
                backgroundColor: Colors.transparent,
                onSurface: Colors.orangeAccent,
                side: const BorderSide(color: darkRed, width: 1)),
            onPressed: () {
              //                             Navigator.of(context)
              // .push(MaterialPageRoute(builder: (context) => Screen25()));
            },
          ),
          const SizedBox(width: 150),
          GestureDetector(
            onTap: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MainCheckIn()));
            },
            child: Container(
                child: Row(
              children: const [
                Text('Filter',
                    style: TextStyle(
                        color: Colors.grey, fontWeight: FontWeight.bold)),
                SizedBox(width: 2),
                Icon(Icons.tune),
              ],
            )),
          ),
        ],
      ),
    );
  }
}

// Container(
//     height: 280,
//     child: ListView.builder(
//         scrollDirection: Axis.horizontal,
//         itemCount: annCardData.length,
//         itemBuilder: (context, index) => annCardData[index]),
//   ),

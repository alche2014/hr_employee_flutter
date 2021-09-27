import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/mainApp/leave_management/Utility/leave_card.dart';

import '../../../colors.dart';


String leave = 'Leave Type';
String approved = 'apd';
String no = 'no';
String body =
    'Hello guys we have discussed about post-corona vacation plan and our decision is to go to bali';

class LeaveHistoryHeader extends StatelessWidget {
  const LeaveHistoryHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildMyAppBar(context, 'Leave History', false),
      body: Container(
        child: SingleChildScrollView(
          child: Column(
            children: [
              HeaderCard(),
              FilterButton(),
              MyCustomCard(header: leave, body: body, status: false,statusToggle: true),
              MyCustomCard(header: leave, body: body, picOrName: false ,status: false,statusToggle: true, buttonToggle: true),
              MyCustomCard(header: leave, body: body, status: true,statusToggle: true),
            ],
          ),
        ),
      ),
    );
  }
}

class HeaderCard extends StatelessWidget {
  const HeaderCard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20,vertical: 20),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Colors.grey.withOpacity(0.2),
                  width: 2,
                ),
              ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            HeaderIconCard('Anual', '20'),
            HeaderIconCard('Casual', '20'),
            HeaderIconCard('Sick', '20'),
          ],
        ),
      ),
    );
  }
}

//=============================================================//

class HeaderIconCard extends StatelessWidget {
  final String leaveHeader;
  final String leaveCount;

  HeaderIconCard(this.leaveHeader, this.leaveCount);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
                radius: 30,
                backgroundColor: lightPink,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(100),
                  child: Image(
                    image: AssetImage('assets/icons/roundpink.png'),
                  ),
                )),
            SizedBox(
              height: 10,
            ),
            Text(
              '$leaveHeader Leave',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text(
              '$leaveCount Pending',
              style: TextStyle(color: Colors.grey),
            ),
          ]),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({ Key? key }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: FittedBox(
        child: InkWell(
            onTap: (){},
            borderRadius: BorderRadius.circular(10),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                  height: 20, child: Image.asset('assets/icons/filter.png')),
            )),
      ),
    );
  }
}
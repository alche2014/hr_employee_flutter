import 'package:flutter/material.dart';
import 'Utility/cards/teamCard.dart';
import 'Utility/content/list_of_data.dart';

final darkRed = Color(0xffbf2634);

class MainHomeProfile extends StatefulWidget {
  @override
  _MainHomeProfileState createState() => _MainHomeProfileState();
}

class _MainHomeProfileState extends State<MainHomeProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.52,
              child: Stack(
                children: [
                  //--------------backimage-----------------//
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage('assets/images/foggy.jpg'),
                        fit: BoxFit.cover,
                      )),
                      child: Column(
                        // crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Icon(Icons.notifications,
                                      color: MediaQuery.of(context)
                                                  .platformBrightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : Colors.grey)
                                ]),
                          ),
                          CircleAvatar(
                            backgroundImage:
                                AssetImage('assets/images/ben.jpg'),
                            maxRadius: 40,
                          ),
                          SizedBox(height: 10),
                          Text('Name Here',
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          SizedBox(height: 5),
                          Text('Front-End & UI',
                              style: TextStyle(color: Colors.grey)),
                          SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ),
                  //--------------backimage-end-----------------//

                  //--------------mainWhite-Back-of-CenterCard---------------//
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.36,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: MediaQuery.of(context).platformBrightness ==
                                Brightness.light
                            ? Colors.white
                            : Color(0xFF1D1D35),
                      ),
                    ),
                  ),
                  //-------------mainWhite--end-Back-of-CenterCard----------//

                  //-------------center-card-----------------//
                  Positioned(
                    top: MediaQuery.of(context).size.height * 0.29,
                    left: 0,
                    right: 0,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 25),
                      child: ClipRRect(
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(10),
                          topRight: Radius.circular(10),
                        ),
                        child: Container(
                          height: 140,
                          // margin: EdgeInsets.symmetric(horizontal: 25),
                          decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: darkRed, width: 3)),
                            color: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? Colors.white
                                : Color(0xff34354A),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Check In',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold)),
                                    SizedBox(height: 5),
                                    Text('You Haven,t chock in yet',
                                        style: TextStyle(color: Colors.grey)),
                                    SizedBox(height: 5),
                                    Text('00 : 00 : 00 HRS',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 18)),
                                    //----------------------//
                                    TextButton(
                                        onPressed: () {
                                          // Navigator.of(context).push(
                                          //     MaterialPageRoute(
                                          //         builder: (context) => Screen3()));
                                        },
                                        child: Text('View History')),
                                  ],
                                ),
                                Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                          padding: EdgeInsets.all(5),
                                          height: 100,
                                          width: 100,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: darkRed, width: 3),
                                            borderRadius:
                                                BorderRadius.circular(100),
                                            color: MediaQuery.of(context)
                                                        .platformBrightness ==
                                                    Brightness.light
                                                ? Colors.grey[100]
                                                : Color(0xff34354A),
                                          ),
                                          child: ElevatedButton(
                                            onPressed: () {},
                                            child: Text('Check In',
                                                style: TextStyle(fontSize: 11)),
                                            style: ElevatedButton.styleFrom(
                                              shape: CircleBorder(),
                                              // padding: EdgeInsets.all(14),
                                            ),
                                          ))
                                    ])
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                  //------------------card-end-----------------//
                ],
              ),
            ),
            SizedBox(height: 10),
            //--------------------ALL--Widgets------------------//
            headViewList('Announcements', 'orange'),
            Container(
              height: 260,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: annCardData.length,
                  itemBuilder: (context, index) => annCardData[index]),
            ),
            //--------------------------------------//
            headViewList('Birthday', 'lightgreen'),
            Container(
              height: 120,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: birthCardData.length,
                  itemBuilder: (context, index) => birthCardData[index]),
            ),
            //---------------------------------------------//
            headViewList('Leave Management', 'green'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.white
                        : Color(0xff34354A),
                  ),
                  child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 240,
                            child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: leaveCardData.length,
                                itemBuilder: (context, index) =>
                                    leaveCardData[index]),
                          ),
                          ElevatedButton(
                              onPressed: () {},
                              child: const Text('Apply Leave',
                                  style: TextStyle(color: Colors.white))),
                          SizedBox(height: 10),
                        ]),
                  ),
                ),
              ),
            ),
            //--------------------------------------------------------//
            headViewList('Team Member', 'green'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(height: 200, child: TeamCard()),
            ),
            //---------------------------------------------------------//
            headViewList('Events', 'blue'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: SizedBox(
                  height: 210,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: eventCardData.length,
                      itemBuilder: (context, index) => eventCardData[index])),
            ),
            //---------------------------------------------------------//
            headViewList('Upcoming Holidays', 'lightblue'),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Material(
                elevation: 3,
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(
                      Radius.circular(15),
                    ),
                    color: MediaQuery.of(context).platformBrightness ==
                            Brightness.light
                        ? Colors.white
                        : Color(0xff34354A),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 250,
                            child: ListView.builder(
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: holidayCardData.length,
                                itemBuilder: (context, index) =>
                                    holidayCardData[index]),
                          ),
                        ]),
                  ),
                ),
              ),
            ),
            SizedBox(height: 50),
          ],
        ),
      ),
    );
  }
  //-----------------------UI--ended--------------------------------//

  //-----------------HeadView-Extracted-below----------------------//
  Padding headViewList(String head, String icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: ListTile(
        leading: Image(
            image: AssetImage('assets/icons/custom/$icon.png'), height: 40),
        title: Text('$head', style: TextStyle(fontWeight: FontWeight.bold)),
        trailing: TextButton(
            onPressed: () {},
            child:
                Text('View all', style: TextStyle(color: Color(0xffbf2634)))),
      ),
    );
  }
}

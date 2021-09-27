import 'package:flutter/material.dart';

import 'Utility/stacked_pics.dart';

class MainEvents extends StatelessWidget {
  const MainEvents({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 250,
              child: Stack(
                children: [
                  //-----------------------image portion------------------------
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage('assets/event_pic.png'),
                          fit: BoxFit.cover,
                        ),
                      ),
                      height: 250,
                    ),
                  ),
                  //............notification icon in picture portion..........
                  Positioned(
                    top: 30,
                    left: 0,
                    right: 320,
                    child: IconButton(
                        icon: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                  //...........back arrow in picture portion..........
                  Positioned(
                    top: 30,
                    left: 320,
                    right: 0,
                    child: IconButton(
                      icon: Icon(
                        Icons.notifications,
                        color: Colors.white,
                      ),
                      onPressed: () {
                        // Navigator.of(context).push(MaterialPageRoute(
                        //     builder: (context) => Page16()));
                      },
                    ),
                  ),
                ],
              ),
            ),
            ListTile(
              title: Text('This super league Lorem 2017',
                  style: TextStyle(color: darkRed)),
              subtitle: Text('Thu Oct 19, 2021 at 3:00pm',
                  style: TextStyle(color: Colors.grey[400])),
              trailing: Text(
                'admin',
                style: TextStyle(color: Colors.grey[400]),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              child: Text('30 Members are going'),
            ),
            StackedPics(), // Stacked pic with join button
            const Divider(
              indent: 20,
              endIndent: 20,
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Text(
                'Event Detail',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
            ),
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 10, 20, 20),
              child: Text(
                  'Hello guys, we have discussed about past-corono vacation plan and our decision is to go to Bali. We will have a very big party after this corona ends!Hello guys, we have discussed about past-corono vacation plan and our decision is to go to Bali. We will  have a very big party after this corona ends!'),
            ),
//------------Map--------------
            Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage('assets/GoogleMap.jpg'),
                      fit: BoxFit.cover)),
              height: 200,
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/events/main_events.dart';
import 'package:hr_app/mainApp/notifications/notification_button.dart';

class MainSettings extends StatelessWidget {
  const MainSettings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Settings', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(children: const [
                  ProfilePicSetting(),
                  //=============================//
                  DarkModeSwitch(),
                  SCardNotification(),
                  SCardPrivacy(),
                  SCardAbout(),
                ]),
                //=============================//
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: const [
                        Icon(Icons.logout),
                        SizedBox(width: 20),
                        Text('Log Out'),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ProfilePicSetting extends StatelessWidget {
  const ProfilePicSetting({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          const SizedBox(height: 15),
          Row(children: [
            SizedBox(height: 60, child: Image.asset('assets/belly.png')),
            const SizedBox(width: 20),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'User Name',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text("Trust your feelings,\n be a good human beings"),
                ]),
          ]),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}

bool isSwitched = false;

class DarkModeSwitch extends StatelessWidget {
  const DarkModeSwitch({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          child: Column(
            children: [
              const SizedBox(height: 5),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(children: [
                  SizedBox(
                      height: 20,
                      child: Image.asset('assets/custom/Frame.png')),
                  const SizedBox(width: 20),
                  const Text(
                    'Dark mode',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ]),
                //=================================//
                Switch(
                  onChanged: (bool newValue) {
                    setState(() {
                      isSwitched = newValue;
                    });
                  },
                  value: isSwitched,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.lightBlueAccent,
                  inactiveThumbColor: Colors.grey,
                  inactiveTrackColor: Colors.grey[300],
                ),
              ]),
              const SizedBox(height: 5),
            ],
          ),
        ),
      ),
    );
  }
}

class SCardNotification extends StatelessWidget {
  const SCardNotification({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => const MainNotificationPage()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SizedBox(
                            height: 20,
                            child: Image.asset('assets/custom/bellicon.png')),
                        const SizedBox(width: 20),
                        const Text(
                          'Notification',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                      //=================================//
                      const Icon(Icons.arrow_forward_ios_sharp),
                    ]),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SCardPrivacy extends StatelessWidget {
  const SCardPrivacy({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MainEvents()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(children: [
                        SizedBox(
                            height: 20,
                            child: Image.asset('assets/custom/lockicon.png')),
                        const SizedBox(width: 20),
                        const Text(
                          'Privacy and security',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ]),
                      //=================================//
                      const Icon(Icons.arrow_forward_ios_sharp),
                    ]),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SCardAbout extends StatelessWidget {
  const SCardAbout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          // Navigator.of(context).push(
          //     MaterialPageRoute(builder: (context) => const AddExperience()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              children: [
                const SizedBox(height: 15),
                Row(mainAxisAlignment: MainAxisAlignment.start, children: [
                  Row(children: [
                    SizedBox(
                        height: 20,
                        child: Image.asset('assets/custom/Iicon.png')),
                    const SizedBox(width: 20),
                    const Text(
                      'About',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ]),
                  //=================================//
                  // const Icon(Icons.arrow_forward_ios_sharp),
                ]),
                const SizedBox(height: 15),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void setState(Null Function() param0) {
  // setState(() {
  //   isSwitched = true;
  // });
}

import 'package:flutter/material.dart';
import 'package:hr_app/AppBar/appbar.dart';
import 'package:hr_app/background/background.dart';
import 'package:hr_app/mainApp/education/main_education.dart';
import 'package:hr_app/mainApp/experiences/add_experiences.dart';

class MainExperiences extends StatelessWidget {
  const MainExperiences({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: buildMyAppBar(context, 'Experiences', true),
      body: Stack(
        children: [
          const BackgroundCircle(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 80),
            child: Column(
              children: const [
                CardOne(),
                CardTwo(),
                CardThree(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class CardOne extends StatelessWidget {
  const CardOne({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const AddExperience()));
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
                Row(children: [
                  SizedBox(height: 40, child: Image.asset('assets/Logo.png')),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'UI UX Designer',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 3),
                        Text('Alchemative - Full time'),
                        SizedBox(height: 3),
                        Text('Mar 2020 - Present 1yr 7 mos'),
                      ]),
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

class CardTwo extends StatelessWidget {
  const CardTwo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const MainEducation()));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: Colors.grey.withOpacity(0.4), width: 1),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: Row(children: [
              SizedBox(height: 40, child: Image.asset('assets/picBack.png')),
              const SizedBox(width: 20),
              Expanded(
                flex: 1,
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Web UI & UX Designer at Technology Wisdom',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 3),
                      Text('Technology Wisdom - Full time'),
                      SizedBox(height: 3),
                      Text('Feb 2018 – Feb 2020 2 yrs 1 mos'),
                    ]),
              ),
            ]),
          ),
        ),
      ),
    );
  }
}

class CardThree extends StatelessWidget {
  const CardThree({Key? key}) : super(key: key);

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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Row(children: [
            SizedBox(height: 40, child: Image.asset('assets/picBack.png')),
            const SizedBox(width: 20),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Graphic Web Designer',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 3),
                  Text('Computer Xperts - Full time'),
                  SizedBox(height: 3),
                  Text('Mar 2016 – Feb 20182 yrs'),
                ]),
          ]),
        ),
      ),
    );
  }
}

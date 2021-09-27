import 'package:hr_app/mainApp/announcement/utility/ann_card.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/cards/birthCard.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/cards/home_event_card.dart';
import 'package:hr_app/mainApp/main_home_profile/utility/cards/leaveCard.dart';

List<AnnCard> annCardData = [
  AnnCard(
      'This super Leogue lorem 2017',
      'Hello guys, we have discussed about post-corona vacation plan and out decision is to go to bali. We have have a very big party after this corona ends!',
      '14:01 20/10/2020'),
  AnnCard(
      'This super Leogue lorem 2017',
      'Hello guys, we have discussed about post-corona vacation plan and out decision is to go to bali. We have have a very big party after this corona ends!',
      '14:01 20/10/2020'),
  AnnCard(
      'This super Leogue lorem 2017',
      'Hello guys, we have discussed about post-corona vacation plan and out decision is to go to bali. We have have a very big party after this corona ends!',
      '14:01 20/10/2020'),
];

// 2nd final BirthdayCard Data
List<BirthDayCard> birthCardData = [
  BirthDayCard('Hamza Ali', '20 May, 2020', '3 Day'),
  BirthDayCard('Muhammad Ali', '2 Jan, 2019', '8 Day'),
];

// 3nd final LeaveCard Data
List<LeaveCard> leaveCardData = [
  LeaveCard('Anual Leave', '20 anual leaves pending'),
  LeaveCard('Casual Leave', '20 anual leaves pending'),
  LeaveCard('Sick Leave', '20 anual leaves pending')
];

// 4nd final EventCard Data
List<HomeEventCard> eventCardData = [
  HomeEventCard('31', 'Jun', 'This super Leogue lorem 2017', '16:04 20/10/2021',
      'back_2'),
  HomeEventCard('30', 'Jul', 'This super Leogue lorem 2017', '16:04 20/10/2021',
      'back_1'),
  HomeEventCard('29', 'Aug', 'This super Leogue lorem 2017', '16:04 20/10/2021',
      'back_2'),
];

// 5th final Holidays
List<LeaveCard> holidayCardData = [
  LeaveCard('Iqbal Day', '20/10/2021'),
  LeaveCard('Pakistan Independance Day', '20/20/2021'),
  LeaveCard('Labour', '20/10/2021')
];

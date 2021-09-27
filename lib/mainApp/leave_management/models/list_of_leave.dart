// ignore_for_file: file_names

import 'package:hr_app/mainApp/leave_management/leave_history/leave_history.dart';

class Leaves {
  String? name;
  String? approval = 'apd';

  String? body =
      'Hello guys we have discussed about post-corona vacation plan and our decision is to go to bali';

  Leaves({this.name, this.body, this.approval});
}

List<Leaves> demoLeaves = [
  Leaves(name: 'Leave Type', body: body, approval: approved),
  Leaves(name: 'Leave Type', body: '', approval: 'no'),
  Leaves(name: 'Leave Type', body: body, approval: approved),
  Leaves(name: 'Leave Type', body: body, approval: approved),
];

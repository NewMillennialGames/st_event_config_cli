import 'package:flutter/material.dart';
//
import 'services/web_quest_presenter.dart';
import 'dialog/all.dart';
/*


*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  //

  final wqp = WebQuestionPresenter();
  final dRunner = DialogRunner(wqp);
  // now pass dRunner into your app
  // I would use a RP Provider
  runApp(Text('example!'));
}

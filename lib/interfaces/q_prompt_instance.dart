import '../questions/all.dart';
// import '../util/all.dart';

abstract class QPromptIfc {
  //
  String get userPrompt;
  bool get hasChoices;
  List<ResponseAnswerOption> get questsAndChoices;
  void collectResponse(String s);
}

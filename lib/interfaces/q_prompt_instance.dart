import '../r_and_d/all.dart';

typedef SubmitUserResponseFunc = void Function(String);

abstract class QPromptIfc {
  //
  String get userPrompt;
  bool get hasChoices;
  List<ResponseAnswerOption> get questsAndChoices;
  void collectResponse(String s);
}

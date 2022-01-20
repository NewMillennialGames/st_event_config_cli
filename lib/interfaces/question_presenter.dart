import '../input_models/all.dart';
import '../dialog_cli/all.dart';

abstract class QuestionPresenter {
  /*
  this is the class passed to DialogRunner
  that is responsible for rendering UI for the questions

  you should implement a new one for the Web/Flutter UI
  */

  bool askSectionQuestionAndWaitForUserResponse(
    DialogRunner dialoger,
    DialogSectionCfg sectionCfg,
  );

  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    Question quest,
  );
}

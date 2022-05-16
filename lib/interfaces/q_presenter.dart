// import '../questions/all.dart';
import '../dialog/all.dart';
import '../r_and_d/all.dart';

abstract class QuestionPresenter {
  /*
  interface for the class passed to DialogRunner
  that is responsible for rendering UI for the Quest2s

  CLI app uses:
    lib/services/cli_quest_presenter.dart

  you should implement a new one for the Web/Flutter UI
  in:  lib/services/web_quest_presenter.dart
  */

  // bool askSectionQuest2AndWaitForUserResponse(
  //   DialogRunner dialoger,
  //   DialogSectionCfg sectionCfg,
  // );

  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  );

  void informUiThatDialogIsComplete();
}

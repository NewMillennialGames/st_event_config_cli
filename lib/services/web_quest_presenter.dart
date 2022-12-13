import "dart:async";
//
import '../interfaces/q_presenter.dart';
// import '../questions/all.dart';
import '../dialog/all.dart';
import '../questions/all.dart';

class WebQuestionPresenter implements QuestionPresenterIfc {
  // to render widget views of the Quest2
  // move this class to the parent flutter project

  final StreamController<QuestBase> questDispatcher;
  final Stream<String> answerStream;
  DialogRunner? dRunner;
  late QuestBase _quest;

  WebQuestionPresenter(
    this.questDispatcher,
    this.answerStream,
  ) {
    answerStream.listen(_receiveAnswer);
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    QuestBase quest,
  ) {
    if (dRunner == null) {
      this.dRunner = dialoger;
    }
    _quest = quest;
    // should pump a widget to some provider
    // to redraw the whole screen
    questDispatcher.add(quest);

    // user answer might generate new questions
    dialoger.generateNewQuestionsFromUserRuleCfgResponse(quest);
  }

  void _receiveAnswer(String answer) {
    // _quest.convertAndStoreUserResponse(answer);
    dRunner!.advanceToNextQuestionFromGui();
  }

  @override
  void showErrorAndRePresentQuestion(String errTxt, String questHelpMsg) {
    //
  }

  void informUiThatDialogIsComplete() {
    questDispatcher.close();
    // need to save generated file to user desktop
  }
}

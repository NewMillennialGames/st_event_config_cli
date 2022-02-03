import "dart:async";
//
import '../interfaces/question_presenter.dart';
import '../input_models/all.dart';
import '../dialog/all.dart';

class WebQuestionPresenter implements QuestionPresenter {
  // to render widget views of the question
  // move this class to the parent flutter project

  final StreamController<Question> questDispatcher;
  final Stream<String> answerStream;
  DialogRunner? dRunner;
  late Question _quest;

  WebQuestionPresenter(
    this.questDispatcher,
    this.answerStream,
  ) {
    answerStream.listen(_receiveAnswer);
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    Question quest,
  ) {
    if (dRunner == null) {
      this.dRunner = dialoger;
    }
    _quest = quest;
    // should pump a widget to some provider
    // to redraw the whole screen
    questDispatcher.add(quest);
  }

  void _receiveAnswer(String answer) {
    _quest.convertAndStoreUserResponse(answer);
    dRunner!.advanceToNextQuestion();
  }

  void informUiWeAreDone() {
    questDispatcher.close();
    // need to save generated file to user desktop
  }
}

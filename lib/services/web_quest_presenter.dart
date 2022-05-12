import "dart:async";
//
import '../interfaces/q_presenter.dart';
import '../questions/all.dart';
import '../dialog/all.dart';
import '../r_and_d/all.dart';

class WebQuest2Presenter implements Quest2Presenter {
  // to render widget views of the Quest2
  // move this class to the parent flutter project

  final StreamController<Quest2> questDispatcher;
  final Stream<String> answerStream;
  DialogRunner? dRunner;
  late Quest2 _quest;

  WebQuest2Presenter(
    this.questDispatcher,
    this.answerStream,
  ) {
    answerStream.listen(_receiveAnswer);
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    Quest2 quest,
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
    dRunner!.advanceToNextQuest2();
  }

  void informUiThatDialogIsComplete() {
    questDispatcher.close();
    // need to save generated file to user desktop
  }
}

// import "dart:io";
// import 'package:collection/collection.dart';
// import 'package:eventconfig/interfaces/question_presenter.dart';
//
import 'package:eventconfig/interfaces/question_presenter.dart';

import '../input_models/all.dart';
import '../dialog/all.dart';
import '../app_entity_enums/all.dart';
// import '../enums/all.dart';

class WebQuestionPresenter implements QuestionPresenter {
  // to render widget views of the question
  // move this class to the parent flutter project

  // formatter for command-line IO
  WebQuestionPresenter();

  @override
  bool askSectionQuestionAndWaitForUserResponse(
    DialogRunner dialoger,
    DialogSectionCfg sectionCfg,
  ) {
    if (sectionCfg.appSection == AppScreen.eventConfiguration) return true;

    return sectionCfg.askIfNeeded();
  }

  @override
  void askAndWaitForUserResponse(
    DialogRunner dialoger,
    Question quest,
  ) {}
}

library RandDee; // R and D -- research and development

import 'package:equatable/equatable.dart';
//
import '../questions/all.dart';
import '../app_entity_enums/all.dart';
import '../enums/all.dart';
import '../util/string_ext.dart';
import '../scoretrader/all.dart';
import '../interfaces/question.dart';

part 'quest.dart';
part 'q_collection.dart';
part 'q_prompt_instance.dart';
part 'q_choice_collection.dart';
part 'q_intent.dart';
part 'q_factory.dart';
part 'answ_capture_cast.dart';

/*
  attempt to create a new question structure
  that conforms more fully to needs of Question and VisualRuleQuestion

  requirements of a question
    scope:  QuestionQuantifier

    ask count (how many user prompts)
    answer count (how many answers allowed per prompt)


    todo:
    rename QuestionQuantifier to QTargetQuantify
    rename QuestionPresenter to QuestionPresenterIfc

*/



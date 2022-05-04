library RandDee; // R and D -- research and development

import 'package:equatable/equatable.dart';
//
import '../questions/all.dart';
import '../app_entity_enums/all.dart';
import '../enums/all.dart';
import '../util/type_cast.dart';
import '../dialog/all.dart';
import '../util/string_ext.dart';

part 'quest.dart';
part 'q_iter.dart';
part 'ans_typ_val_map.dart';
part 'q_type_wrapper.dart';

/*
  attempt to create a new question structure
  that conforms more fully to needs of Question and VisualRuleQuestion

  requirements of a question
    scope:  QuestionQuantifier

    ask count (how many user prompts)
    answer count (how many answers allowed per prompt)


    todo:
    rename QuestionQuantifier to QuestScopeQuantifier


*/



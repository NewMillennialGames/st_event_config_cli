library RandDee; // R and D -- research and development

import 'package:equatable/equatable.dart';
// import 'package:freezed_annotation/freezed_annotation.dart';
//
import '../questions/all.dart';
import '../app_entity_enums/all.dart';
import '../enums/all.dart';
import '../util/string_ext.dart';
import '../scoretrader/all.dart';
import '../interfaces/q_prompt_instance.dart';

// part 'all.freezed.dart';
part 'quest.dart';
part 'q_collection.dart';
part 'q_prompt_instance.dart';
part 'q_choice_collection.dart';
// part 'q_intent.dart';
part 'q_factory.dart';
part 'answ_capture_cast.dart';

/*
  attempt to create a new Quest2 structure
  that conforms more fully to needs of Quest2 and Quest2

  requirements of a Quest2
    scope:  Quest2Quantifier

    ask count (how many user prompts)
    answer count (how many answers allowed per prompt)


    todo:
    rename Quest2Quantifier to QTargetQuantify
    rename Quest2Presenter to Quest2PresenterIfc

*/



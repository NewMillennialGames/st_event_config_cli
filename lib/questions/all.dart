library QuestionsLib;

import 'dart:ffi';

import 'package:equatable/equatable.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
// import 'package:riverpod/riverpod.dart';
//
import '../app_entity_enums/all.dart';
import '../enums/all.dart';
import '../dialog/all.dart';
import '../util/type_cast.dart';
import '../util/string_ext.dart';
import '../r_and_d/all.dart';
//
part 'all.g.dart';
part 'all.freezed.dart';
part 'user_response.dart';
part 'new_quest_derived.dart';
part 'question_quantifier.dart';
part 'question_base.dart';
part 'question_visual_rule.dart';
// part 'question_behave_rule.dart';
part 'vis_rule_choice_config.dart';
part 'user_rule_response_types.dart';

typedef CastUserInputToTyp<InputTyp, AnsTyp> = AnsTyp Function(InputTyp input);
typedef CastUserInputToTyp2<AnsTyp> = AnsTyp Function(String input);

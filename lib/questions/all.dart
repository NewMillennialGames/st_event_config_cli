library InputModels;

import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
//
import '../app_entity_enums/all.dart';
import '../enums/all.dart';
import '../util/type_cast.dart';
import '../util/string_ext.dart';
//
part 'all.g.dart';
part 'user_response.dart';
part 'niu_section.dart';
part 'question_quantifier.dart';
part 'question_base.dart';
part 'question_visual_rule.dart';
part 'question_behave_rule.dart';
part 'vis_rule_choice_config.dart';
part 'user_rule_response_types.dart';

typedef CastUserInputToTyp<InputTyp, AnsTyp> = AnsTyp Function(InputTyp input);

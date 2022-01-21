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
part 'rule_resp_wrapper.dart';
part 'section.dart';
part 'question_quantifier.dart';
part 'question_base.dart';
part 'question_rule_type.dart';
part 'vis_rule_choice_config.dart';

typedef CastUserInputToTyp<InputTyp, AnsTyp> = AnsTyp Function(InputTyp input);

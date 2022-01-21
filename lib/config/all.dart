library EvCfgConfig;

import '../enums/all.dart';
import '../util/type_cast.dart';
import '../app_entity_enums/all.dart';
import '../input_models/all.dart';

// import '../input_models/all.dart';
// import '../app_entities/all.dart';
// import '../enums/all.dart';
// import './strings.dart';

part 'questions.dart';
part 'strings.dart';
part 'constants.dart';

typedef Qb<ConvertTyp, AnsTyp> = Question<ConvertTyp, AnsTyp>;

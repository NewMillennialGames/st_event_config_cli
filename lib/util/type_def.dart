part of StUtil;

// preferred way to construct all Question instances
typedef QuestFactorytSignature = QuestBase Function(
  QTargetIntent qTargetIntent,
  List<QuestPromptPayload> promptVals, {
  String? questId,
});

// for recording user answers to questions
typedef SubmitUserResponseFunc = void Function(String);
// for casting string into expected rule-type value
typedef CastStrToAnswTypCallback<T> = T Function(String);
//
typedef AddQuestChkCallbk = bool Function(dynamic);
typedef GroupingRules = Tuple3<TvGroupCfg, TvGroupCfg?, TvGroupCfg?>;
typedef SortingRules = Tuple3<TvSortCfg, TvSortCfg?, TvSortCfg?>;
typedef FilterRules = Tuple3<TvFilterCfg, TvFilterCfg?, TvFilterCfg?>;

//

typedef RuleQuestTypTup = Tuple2<VisualRuleType, VisRuleQuestType>;

// pass Question, return how many new Questions to create
typedef NewQuestCount = int Function(QuestBase);
// pass Question + newIndx, return list of args for Quest2 template
typedef NewQuestArgGen = List<String> Function(QuestBase, int);

typedef QTargetIntentUpdateFunc = QTargetIntent Function(QTargetIntent);

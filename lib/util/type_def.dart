part of StUtil;

// preferred way to construct all Question instances
typedef QuestConstructSign = QuestBase Function(
  QTargetIntent qTargetIntent,
  List<QuestPromptPayload> promptVals, {
  String? questId,
});

typedef CastStrToAnswTypCallback<T> = T Function(String);
// typedef CastListToType<T> = T Function(List<String>);
// typedef CastUserInputToTyp<InputTyp, AnsTyp> = AnsTyp Function(InputTyp input);
// typedef CastUserInputToTyp2<AnsTyp> = AnsTyp Function(String input);

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

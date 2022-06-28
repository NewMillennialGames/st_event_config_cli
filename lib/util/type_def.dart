part of StUtil;

// preferred way to auto-construct all new Question instances
typedef QuestFactorytSignature = QuestBase Function(
  QTargetResolution qTargetIntent,
  List<QuestPromptPayload> promptVals, {
  String? questId,
});

// for recording user answers to questions
typedef SubmitUserResponseFunc = void Function(String);
// for casting string into expected rule-type value
typedef CastStrToAnswTypCallback<T> = T Function(QuestBase, String);
// typedef CastPriorAnswToType<T> = T Function(QuestBase);

typedef NewQuestIdGenFromPriorAnswer = String Function(
    QuestBase priorAnsweredQuest, int idx);

typedef DerQuestGeneratorFactoryClbk = DerivedQuestGenerator Function(
    QuestBase priorAnsweredQuest, int idx);

typedef PriorQuestIdMatchPatternTest = bool Function(String priorQuestId);

typedef ChoiceListFromPriorAnswer<T> = List<String> Function(
    QuestBase priorAnsweredQuest, int newQuestIdx, int promptIdx);
//
typedef AddQuestRespChkCallbk = bool Function(QuestBase priorAnsweredQuest);
//
typedef GroupingRules = Tuple3<TvGroupCfg, TvGroupCfg?, TvGroupCfg?>;
typedef SortingRules = Tuple3<TvSortCfg, TvSortCfg?, TvSortCfg?>;
typedef FilterRules = Tuple3<TvFilterCfg, TvFilterCfg?, TvFilterCfg?>;
//
// pass Question, return how many new Questions to create
typedef NewQuestCount = int Function(QuestBase);
// pass Question + newIndx, return list of args for Quest2 template
typedef NewQuestArgGen = List<String> Function(QuestBase, int);

// when auto-generating questions (from prior answers)
// this function lets you pass in the source QTI and get a new one back
typedef QTargetIntentUpdateFunc = QTargetResolution Function(
    QuestBase ab, int idx);


// typedef RuleQuestTypTup = Tuple2<VisualRuleType, VisRuleQuestType>;
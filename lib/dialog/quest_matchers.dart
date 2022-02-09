part of ConfigDialogRunner;

void appendNewQuests(QuestListMgr questListMgr, Question quest) {
  //
  for (QuestMatcher qm in _possibleNewQuests) {
    if (qm.doesMatch(quest)) {
      questListMgr.appendNewQuestions(qm.quests);
    }
  }
}

class QuestMatcher<AnsType> {
  //
  final QuestCascadeTyp? cascadeType;
  final AppScreen? appScreen;
  final ScreenWidgetArea? screenWidgetArea;
  final ScreenAreaWidgetSlot? slotInArea;
  final VisualRuleType? visRuleTypeForAreaOrSlot;
  final BehaviorRuleType? behRuleTypeForAreaOrSlot;
  final bool isRuleQuestion;
  Type? typ = UserResponse<String>;
  //
  List<VisualRuleQuestion> quests;

  QuestMatcher(
    this.cascadeType,
    this.appScreen, {
    this.screenWidgetArea,
    this.slotInArea,
    this.visRuleTypeForAreaOrSlot,
    this.behRuleTypeForAreaOrSlot,
    this.isRuleQuestion = false,
    this.typ,
    this.quests = const [],
  });

  bool doesMatch(Question quest) {
    bool dMatch = true;
    dMatch = dMatch &&
        (this.cascadeType == null ||
            this.cascadeType == quest.qQuantify.cascadeType);

    dMatch =
        dMatch && (this.appScreen == null || this.appScreen == quest.appScreen);

    dMatch = dMatch &&
        (this.screenWidgetArea == null ||
            this.screenWidgetArea == quest.screenWidgetArea);

    dMatch = dMatch &&
        (this.slotInArea == null || this.slotInArea == quest.slotInArea);

    dMatch = dMatch &&
        (this.visRuleTypeForAreaOrSlot == null ||
            this.visRuleTypeForAreaOrSlot == quest.visRuleTypeForAreaOrSlot);

    dMatch = dMatch &&
        (this.behRuleTypeForAreaOrSlot == null ||
            this.behRuleTypeForAreaOrSlot == quest.behRuleTypeForAreaOrSlot);

    dMatch = dMatch &&
        (this.isRuleQuestion == false || quest.isRuleQuestion == true);

    dMatch =
        dMatch && (this.typ == null || quest.response.runtimeType == this.typ);

    return dMatch;
  }
}

List<QuestMatcher> _possibleNewQuests = [
  //
  QuestMatcher<int>(
    QuestCascadeTyp.addsVisualRuleQuestions,
    AppScreen.marketView,
    screenWidgetArea: ScreenWidgetArea.filterBar,
    quests: [],
  ),
];

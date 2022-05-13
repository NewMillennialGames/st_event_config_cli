part of ConfigDialogRunner;

class NewQuest2Collector {
  /*
    each answered Quest2 is passed to this object
    then the scope and context of the Quest2 is reviewed

    for certain Quest2s, this NQCollector will auto-generate
    many related sub-Quest2s

    new Quest2s are passed to QuestListMgr
    which assigns them a Quest2Id
    and appends them to the to-be-answered list

    at some point, we may wish to sort Quest2s
    into sensible order, but that process might
    put already answered Quest2s after the current
    Quest2 index  (I've solved this but not tested)

  Summary:
  after user selects desired screens to configure, then we ask
  which screen areas (and slots on those areas) to configure
  then we ask them which visual rules they'd like to apply
  to those areas and/or area-slots on each respective screen
  */

  bool handleAcquiringNewQuest2s(QuestListMgr _questMgr) {
    // returns whether true if new Quest2s were added

    QuestBase questJustAnswered = _questMgr._currentOrLastQuest2;
    // ruleQuest2s don't currently generate new Quest2s
    // actually, a filter, sort or group (level 2 or 3) Quest2
    // should generate the Quest2s under it??  TODO
    if (questJustAnswered.addsRuleDetailQuestsForSlotOrArea ||
        questJustAnswered.generatesNoNewQuest2s) {
      // print(
      //   'Quest: #${questJustAnswered.Quest2Id} -- ${questJustAnswered.questStr} wont generate any new Quest2s',
      // );
      return false;
    }

    bool addedNew = false;
    if (questJustAnswered.addsWhichAreaInSelectedScreenQuest2s) {
      /* called by the last Quest2 in hard-coded event list
        user has given us full list of screens they want to configure
        so we don't need to ask individual screens again
       */
      print('calling: askUserWhichAreasOfSelectedScreensToConfigure');
      askUserWhichAreasOfSelectedScreensToConfigure(
        _questMgr,
        questJustAnswered.mainAnswer as UserResponse<List<AppScreen>>,
      );
      addedNew = true;
      //
    } else if (questJustAnswered.addsWhichRulesForSelectedAreaQuest2s ||
        questJustAnswered.addsWhichSlotOfSelectedAreaQuest2s) {
      /*  for all the areas (to be configured) of all of the selected screens
          we need to know which slot(s) on each area they want to configure

          this will be called once for each screen/area combination
          askeUserWhichPartsOfSelectedAreasToConfigure

          I walked up to farmers market to get some caffeine ... give me 15 minutes notice and I'll walk back to my hotel and put on warmer clothes
      */
      print('calling: askeWhichRulesGoWithAreaAndWhichSlotsToConfig');
      askWhichRulesGoWithAreaAndWhichSlotsToConfig(
        _questMgr,
        questJustAnswered, // QuestBase<String, List<ScreenWidgetArea>>
      );
      addedNew = true;
      //
    } else if (questJustAnswered.addsWhichRulesForSlotsInArea) {
      //
      print('calling: askWhichConfigRulesGoWithEachSlot');
      askWhichConfigRulesGoWithEachSlot(
        _questMgr,
        questJustAnswered, // <String, List<ScreenAreaWidgetSlot>>
      );
      addedNew = true;
      //
    } else if (questJustAnswered.addsRuleDetailQuestsForSlotOrArea) {
      print('calling: genRequestedVisualRulesForAreaOrSlot');

      genRequestedVisualRulesForAreaOrSlot(
        _questMgr,
        questJustAnswered, // as QuestBase<String, List<VisualRuleType>>,
      );
      addedNew = true;
      //
      // } else if (questJustAnswered.addsBehavioralRuleQuest2s) {
      //   print('calling: genRequestedBehaveRulesForAreaOrSlot');
      //   genRequestedBehaveRulesForAreaOrSlot(
      //     _questMgr,
      //     questJustAnswered as Quest2<String, List<BehaviorRuleType>>,
      //   );
      //   addedNew = true;
      //
    } else {
      // no new Quest2s generated;
      if (questJustAnswered.generatesNoNewQuest2s ||
          questJustAnswered.isRuleQuest2) return false;

      print('\nWarning ****************');
      print(
        'Quest ID: ${questJustAnswered.Quest2Id} (cascade type: ${questJustAnswered.qQuantify.cascadeType.name}) did not generate any new Quest2s',
      );
      print('qText: "${questJustAnswered.questStr}"');
    }

    return addedNew;
  }

  // callbacks when a Quest2 needs to add other Quest2s
  void askUserWhichAreasOfSelectedScreensToConfigure(
    QuestListMgr _questMgr,
    UserResponse<List<AppScreen>> response,
  ) {
    // receives list of multiple screens user wants to configure
    // create "include" Quest2s for all areas in selected screens
    // user response to each of these Quest2s will cause a call to:
    // askeUserWhichSlotsOnSelectedAreasToConfigure() below
    // note that these Quest2s have appScreen set, but no ScreenWidgetArea
    List<QuestBase> newQuest2s = [];
    for (AppScreen scr in response.answers) {
      // skip screens that dont have configurable areas
      if (!scr.isConfigurable) continue;

      var q = QuestBase(
        // <String, List<ScreenWidgetArea>>
        QTargetIntent.screenLevel(
          scr,
          responseAddsWhichRuleAndSlotQuest2s: true,
        ),
        'For the ${scr.name} screen, select the areas you`d like to configure?',
        scr.configurableScreenAreas.map((e) => e.name),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => scr.configurableScreenAreas[idx])
              .toList();
        },
        acceptsMultiResponses: true,
      );
      newQuest2s.add(q);
    }
    // now put these Quest2s in the queue
    _questMgr.appendNewQuest2s(
      newQuest2s,
      dbgNam: 'askUserWhichAreasOfSelectedScreensToConfigure',
    );
  }

  void askWhichRulesGoWithAreaAndWhichSlotsToConfig(
    QuestListMgr _questMgr,
    QuestBase quest,
  ) {
    /*  receives 1 screen but multiple areas

    Quest2s created in this section should GENERATE
    the VisualRuleType Quest2s for areas
    that ask user to provide specific rule-args

    and "which slot" style Quest2s for each slot in an area
    */
    AppScreen screen = quest.appScreen;
    assert(quest.mainAnswer is List<ScreenWidgetArea>);

    var areasSelectedForScreenInLastQuest =
        quest.mainAnswer as List<ScreenWidgetArea>;
    if (areasSelectedForScreenInLastQuest.length < 1) return;

    // for each configurable area in current screen
    // make a Quest2 about it's possible rule-types
    List<QuestBase> newQuest2s = [];

    // ask rules for each area
    for (ScreenWidgetArea area in areasSelectedForScreenInLastQuest) {
      var applicableRuleTypes = area.applicableRuleTypes(screen);
      if (!area.isConfigureable || applicableRuleTypes.length < 1) continue;

      var q = QuestBase(
        // <String, List<VisualRuleType>>
        QTargetIntent.ruleLevel(
          screen,
          area,
          null,
          responseAddsRuleDetailQuest2s: true,
        ),
        'Which rules would you like to add to the ${area.name} of ${screen.name}?',
        applicableRuleTypes.map((r) => r.friendlyName),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => applicableRuleTypes[idx])
              .toList();
        },
        acceptsMultiResponses: applicableRuleTypes.length > 0,
      );
      // if (area.applicableRuleTypes.length == 1) {
      //   // only one option;  we can auto-answer this one
      //   q.convertAndStoreUserResponse('0');
      //   _questMgr.addImplicitAnswers([q]);
      //   askWhichConfigRulesGoWithEachSlot(_questMgr, q);
      //   continue;
      // }
      newQuest2s.add(q);
    }

    // ask which slots user would like to configure within each area
    print(
      'screen ${screen.name} has ${areasSelectedForScreenInLastQuest.length} areas to config',
    );
    for (ScreenWidgetArea area in areasSelectedForScreenInLastQuest) {
      var applicableWigetSlots = area.applicableWigetSlots(screen);
      print(
        'screen ${screen.name} + area ${area.name} has ${applicableWigetSlots.length} slots to config (area.isConfigureable: ${area.isConfigureable})',
      );
      if (!area.isConfigureable || applicableWigetSlots.length < 1) continue;

      var q = QuestBase(
        // <String, List<ScreenAreaWidgetSlot>>
        QTargetIntent.areaLevelSlots(
          screen,
          area,
          responseAddsWhichRuleQuest2s: true,
        ),
        'Which slots/widgets/sort-fields on the ${area.name} of ${screen.name} would you like to configure?',
        applicableWigetSlots.map((ScreenAreaWidgetSlot r) => r.choiceName),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => applicableWigetSlots[idx])
              .toList();
        },
        acceptsMultiResponses: true,
      );
      newQuest2s.add(q);
    }

    _questMgr.appendNewQuest2s(
      newQuest2s,
      dbgNam: 'askWhichRulesGoWithAreaAndWhichSlotsToConfig',
    );
    print(
      'askWhichRulesGoWithAreaAndWhichSlotsToConfig adding ${newQuest2s.length} rule Quest2s',
    );
  }

  void askWhichConfigRulesGoWithEachSlot(
    QuestListMgr _questMgr,
    QuestBase quest, // <String, List<ScreenAreaWidgetSlot>>
  ) {
    // receives 1 screen & 1 area but multiple slots

    AppScreen screen = quest.appScreen;
    ScreenWidgetArea screenArea = quest.screenWidgetArea!;

    List<ScreenAreaWidgetSlot> selectedSlotsInArea = quest.mainAnswer ?? [];
    if (selectedSlotsInArea.length < 1) return;

    List<QuestBase> newQuest2s = [];
    for (ScreenAreaWidgetSlot slotInArea in selectedSlotsInArea) {
      //
      var possibleConfigRules = slotInArea.possibleConfigRules(screenArea);
      if (!slotInArea.isConfigurable || possibleConfigRules.length < 1)
        continue;

      var q = QuestBase(
        // <String, List<VisualRuleType>>
        QTargetIntent.ruleLevel(
          screen,
          screenArea,
          slotInArea,
          responseAddsRuleDetailQuest2s: true,
        ),
        'Which rules would you like to add to the ${slotInArea.name} area of ${screenArea.name} on screen ${screen.name}?',
        possibleConfigRules.map((r) => r.friendlyName),
        (String idxStrs) {
          return castStrOfIdxsToIterOfInts(idxStrs)
              .map((idx) => possibleConfigRules[idx])
              .toList();
        },
      );
      newQuest2s.add(q);
    }

    _questMgr.appendNewQuest2s(
      newQuest2s,
      dbgNam: 'askWhichConfigRulesGoWithEachSlot',
    );
  }

  void genRequestedVisualRulesForAreaOrSlot(
    QuestListMgr _questMgr,
    QuestBase quest, // <String, List<VisualRuleType>>
  ) {
    /*
      user has responded WHICH rules they would like to apply
      to EITHER a screenArea, OR a slot in an area
      usually should be just one ruleType for each
      screen location
    */
    List<VisualRuleType> rulesToCreateForAreaOrSlot = quest.mainAnswer ?? [];
    if (rulesToCreateForAreaOrSlot.length < 1) return;

    AppScreen screen = quest.appScreen;
    ScreenWidgetArea area = quest.screenWidgetArea!;
    ScreenAreaWidgetSlot? areaSlot = quest.slotInArea;
    //
    List<QuestBase> newQuest2s = [];
    // Quest2s figure out their Quest2s &
    // select options from the rule-type being passed
    for (VisualRuleType ruleTyp in rulesToCreateForAreaOrSlot) {
      // string is the user-input value being parsed
      // RuleResponseWrapperIfc is one of these response types:
      // TvRowStyleCfg, TvSortOrGroupCfg, TvFilterCfg, ShowHideCfg
      var q = QuestBase(
        // <String, RuleResponseBase>
        screen,
        area,
        ruleTyp,
        areaSlot,
      );
      newQuest2s.add(q);
    }
    _questMgr.appendNewQuest2s(
      newQuest2s,
      dbgNam: 'genRequestedVisualRulesForAreaOrSlot',
    );
  }

  void genRequestedBehaveRulesForAreaOrSlot(
    QuestListMgr _questMgr,
    QuestBase quest, // <String, List<BehaviorRuleType>>
  ) {
    // use example above for this pattern
  }
}

// // callbacks when a Quest2 needs to add other Quest2s
// void niu_askUser2ndOr3rdFieldForSortGroupFilter(
//   QuestListMgr _questMgr,
//   Quest2<String, RuleResponseWrapperIfc> questJustAnswered,
// ) {
//   /*

//   */
//   int curSlot = questJustAnswered.slotInArea?.index ?? 0;
//   if (curSlot > 1) return;

//   // final answer = questJustAnswered.response!.answers as TvSortGroupFilterBase;
//   final nextSlot = ScreenAreaWidgetSlot.values[curSlot + 1];
//   // Quest2 newQuest2 =
//   final newQuest2 = Quest2<String, TvSortGroupFilterBase>(
//     questJustAnswered.appScreen,
//     questJustAnswered.screenWidgetArea!,
//     questJustAnswered.visRuleTypeForAreaOrSlot!,
//     nextSlot,
//   );
//   // switch (questJustAnswered.visRuleTypeForAreaOrSlot) {
//   //   case VisualRuleType.sortCfg:
//   //     newQuest2 = Quest2<String, RuleResponseWrapperIfc>(
//   //       questJustAnswered.appScreen,
//   //       questJustAnswered.screenWidgetArea!,
//   //       questJustAnswered.visRuleTypeForAreaOrSlot!,
//   //       nextSlot,
//   //     );
//   //     break;
//   //   case VisualRuleType.groupCfg:
//   //     break;
//   //   case VisualRuleType.filterCfg:
//   //     break;
//   //   default:
//   //     break;
//   // }

//   _questMgr.appendNewQuest2s(
//     [newQuest2],
//     dbgNam: 'askUser2ndOr3rdFieldForSortGroupFilter',
//   );
// }
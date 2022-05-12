part of Quest2sLib;

// to load prior answers for some Quest2s
// typedef PriorAnswersCallback = List<UserResponse> Function();

// class QuesNiution<ConvertTyp, AnsTyp> extends Equatable {
//   //
//   final QTargetIntent qQuantify;
//   final String _questStr;
//   final Iterable<String>? _answerChoices;
//   // castFunc not used on Rule-Type-Quest2s
//   final CastUserInputToTyp<ConvertTyp, AnsTyp>? castFunc;
//   final int defaultAnswerIdx;
//   final bool acceptsMultiResponses;
//   final bool isNotForOutput;
// // unique value for expedited matching
//   String Quest2Id = '';
//   UserResponse<AnsTyp>? response;

//   QuesNiution(
//     this.qQuantify,
//     this._questStr,
//     this._answerChoices,
//     this.castFunc, {
//     this.defaultAnswerIdx = 1,
//     this.acceptsMultiResponses = false,
//     this.isNotForOutput = false,
//     String? questId,
//   }) : Quest2Id = questId == null ? qQuantify.sortKey : questId;
//   // getters
//   String get questStr => _questStr;
//   bool get isRuleQuest2 => this is Quest2; // || this is BehaveRuleQuest2;

//   bool get isTopLevelConfigOrScreenQuest2 =>
//       qQuantify.isTopLevelConfigOrScreenQuest2;
//   List<String>? get answerChoicesList => _answerChoices?.toList();
//   bool get hasChoices => (_answerChoices?.length ?? 0) > 0;

//   // quantified info
//   AppScreen get appScreen => qQuantify.appScreen;
//   ScreenWidgetArea? get screenWidgetArea => qQuantify.screenWidgetArea;
//   ScreenAreaWidgetSlot? get slotInArea => qQuantify.slotInArea;
//   //
//   VisualRuleType? get visRuleTypeForAreaOrSlot =>
//       qQuantify.visRuleTypeForAreaOrSlot;
//   BehaviorRuleType? get behRuleTypeForAreaOrSlot =>
//       qQuantify.behRuleTypeForAreaOrSlot;
//   //

//   // below controls how each Quest2 causes cascade creation of new Quest2s
//   bool get generatesNoNewQuest2s => qQuantify.generatesNoNewQuest2s;

//   bool get asksWhichScreensToConfig =>
//       qQuantify.appScreen == AppScreen.eventConfiguration &&
//       AnsTyp == List<AppScreen>;

//   bool get addsWhichAreaInSelectedScreenQuest2s =>
//       qQuantify.addsWhichAreaInSelectedScreenQuest2s &&
//       appScreen == AppScreen.eventConfiguration &&
//       AnsTyp == List<AppScreen>;

//   bool get addsWhichRulesForSelectedAreaQuest2s =>
//       qQuantify.addsWhichRulesForSelectedAreaQuest2s &&
//       AnsTyp == List<ScreenWidgetArea>;

//   bool get addsWhichSlotOfSelectedAreaQuest2s =>
//       qQuantify.addsWhichSlotOfSelectedAreaQuest2s &&
//       AnsTyp == List<ScreenWidgetArea>;

//   bool get addsWhichRulesForSlotsInArea =>
//       qQuantify.addsWhichRulesForSlotsInArea &&
//       AnsTyp == List<ScreenAreaWidgetSlot>;

//   bool get addsRuleDetailQuestsForSlotOrArea =>
//       qQuantify.addsRuleDetailQuestsForSlotOrArea;

//   // bool get addsBehavioralRuleQuest2s => qQuantify.addsBehavioralRuleQuest2s;

//   String get sortKey => qQuantify.sortKey;
//   // ask 2nd & 3rd position for (sort, group, filter)
//   // bool get gens2ndOr3rdSortGroupFilterQuests => false;

//   // appliesToClientConfiguration == should be exported to file
//   bool get appliesToClientConfiguration =>
//       isRuleQuest2 || appScreen == AppScreen.eventConfiguration;

//   void convertAndStoreUserResponse(String userResp) {
//     //
//     int answerIdx = -1;
//     AnsTyp? derivedUserResponse;
//     if (ConvertTyp == int) {
//       if (userResp != null) {
//         answerIdx = int.tryParse(userResp) ?? -1;
//       }
//       if (answerIdx == -1 && (hasChoices)) {
//         answerIdx = defaultAnswerIdx;
//       }
//       // print('calling int converter ($answerIdx) on $Quest2');
//       derivedUserResponse = _castResponseToAnswer(answerIdx as ConvertTyp);
//     } else if (ConvertTyp == String) {
//       // print('calling string converter ($userResp) on $Quest2');
//       derivedUserResponse = _castResponseToAnswer(userResp as ConvertTyp);
//     } else {
//       var t = typeOf<ConvertTyp>().toString();
//       throw UnimplementedError('wtf $t');
//     }

//     // verify we got a value
//     if (derivedUserResponse == null) {
//       throw UnimplementedError('no conversion of $userResp or $answerIdx');
//       // print('answer was null on $Quest2Id: $Quest2');
//       // return;
//     }
//     // print('\n\nResp: $derivedUserResponse');
//     this.response = UserResponse<AnsTyp>(derivedUserResponse);
//   }

//   Quest2 fromExisting(
//     String quStr,
//     PerQuestGenOptions pqt,
//   ) {
//     // used to create derived Quest2s from existing answers
//     QTargetIntent newQq = pqt.qQuantUpdater(this.qQuantify);
//     String newId = pqt.questId.isNotEmpty
//         ? pqt.questId
//         : (this.Quest2Id + ':' + newQq.sortKey);
//     return Quest2<String, dynamic>(
//       newQq,
//       quStr,
//       pqt.answerChoices,
//       pqt.castFunc,
//       defaultAnswerIdx: pqt.defaultAnswerIdx,
//       questId: newId,
//     );
//   }

//   AnsTyp? _castResponseToAnswer(ConvertTyp convertibleVal) {
//     // ConvertTyp must be either String or int
//     // AnsTyp is typically a string or whatever returned from: castFunc()

//     try {
//       if (convertibleVal is String) {
//         if (this.castFunc != null) {
//           return castFunc!(convertibleVal);
//         } else {
//           return convertibleVal as AnsTyp?;
//         }
//       }
//     } catch (e) {
//       //
//       print('Err: Str $convertibleVal was invalid or out of range');
//       return null;
//     }

//     assert(convertibleVal == int, 'wtf?');

//     AnsTyp? answer;
//     if (castFunc != null) {
//       answer = castFunc!(convertibleVal);
//     } else {
//       int answerIdx = convertibleVal as int;
//       if (answerChoicesList != null) {
//         answer = answerChoicesList![answerIdx] as AnsTyp;
//       } else {
//         answer = convertibleVal as AnsTyp;
//       }
//     }
//     return answer;
//   }

//   // impl for equatable
//   // but really being used as a search filter
//   // to find Quest2s in a specific granularity
//   @override
//   List<Object> get props => [qQuantify];

//   @override
//   bool get stringify => true;
// }
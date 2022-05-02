import 'package:st_ev_cfg/st_ev_cfg.dart';

class WhenQuestLike {
  /* defines a question pattern
    and the answer that should be provided
    by auto-test (as user) in response
  */
  AppScreen screen;
  ScreenWidgetArea? area;
  ScreenAreaWidgetSlot? slot;
  VisualRuleType? ruleType;
  List<VisRuleQuestType> questTypes;

  WhenQuestLike(
    this.screen,
    this.area,
    this.slot, [
    this.questTypes = const [],
  ]);
}

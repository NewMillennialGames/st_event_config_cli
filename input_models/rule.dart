part of EventCfgModels;

abstract class BaseRule {
  //
  static BaseRule getRule(RuleType typ) {
    //
    switch (typ) {
      case RuleType.filter:
        return FilterRule();
      case RuleType.format:
        return FilterRule();
      case RuleType.group:
        return FilterRule();
      case RuleType.navigate:
        return FilterRule();
      case RuleType.show:
        return FilterRule();
      case RuleType.sort:
        return FilterRule();
      default:
        return FilterRule();
    }
  }

  factory BaseRule.filter() => FilterRule();
  factory BaseRule.format() => FormatRule();
  factory BaseRule.group() => GroupRule();
  factory BaseRule.navigate() => NavigateRule();
  factory BaseRule.show() => NavigateRule();
  factory BaseRule.sort() => NavigateRule();
}

class FilterRule extends BaseRule {
  //
  factory FilterRule() {}
}

class FormatRule extends BaseRule {}

class GroupRule extends BaseRule {}

class NavigateRule extends BaseRule {}

class ShowRule extends BaseRule {}

class SortRule extends BaseRule {}

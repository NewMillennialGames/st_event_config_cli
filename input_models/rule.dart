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
}

class SortRule extends BaseRule {}

class FilterRule extends BaseRule {}

class FormatRule extends BaseRule {}

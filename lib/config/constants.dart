part of EvCfgConfig;

const String APP_NAME = 'EvCfg';
const String VERSION = '0.1.1';

const String CLEAR_FILTER_LABEL = 'All';

class CfgConst {
  // TODO:  move those above to this class

  static bool inTestMode = true;

  static DbTableFieldName cancelSortGroupFilterField =
      DbTableFieldName.imageUrl;
  static int cancelSortIndex = cancelSortGroupFilterField.index;
  static int questCountB4Sorting = 7;
}

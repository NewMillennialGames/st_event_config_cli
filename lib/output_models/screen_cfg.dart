part of OutputModels;

@JsonSerializable()
class ScreenCfg {
  //
  AppScreen appScreen;
  Map<ScreenWidgetArea, ScreenAreaCfg> areaConfig;
  Map<ScreenWidgetArea, SlotOrAreaRuleCfg> slotConfig;

  ScreenCfg(
    this.appScreen,
    this.areaConfig,
    this.slotConfig,
  );

  factory ScreenCfg.fromJson(Map<String, dynamic> json) =>
      _$ScreenCfgFromJson(json);

  Map<String, dynamic> toJson() => _$ScreenCfgToJson(this);
}

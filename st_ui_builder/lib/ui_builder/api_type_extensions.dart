part of StUiController;

extension CompetitionStatusExt5 on CompetitionStatus {
  //
  bool get isTradable => [
        CompetitionStatus.compInFuture,
      ].contains(this);

  bool get hasEnded => [
        CompetitionStatus.compFinished,
        CompetitionStatus.compFinal
      ].contains(this);
}

extension AssetStateExt1 on AssetState {
  //
  bool get isTradable => AssetState.assetOpen == this;
}

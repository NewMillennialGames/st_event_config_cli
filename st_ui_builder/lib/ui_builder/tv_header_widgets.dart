part of StUiController;

/*


*/
class TvGroupHeader extends StatelessWidget {
  // standard group header widget
  final TvAreaRowStyle rowStyle;
  final GroupHeaderData headerData;
  const TvGroupHeader(
    this.rowStyle,
    this.headerData, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // standard group header widget
    return Container(
      child: _rowStyleToHeaderStyle(),
    );
  }

  Widget _rowStyleToHeaderStyle() {
    // TODO:  finish this below
    // temp placeholder UI
    return Row(
      children: [
        Text(headerData.first),
        Text(headerData.second),
        Text(headerData.third),
      ],
    );

    // TODO:  finish this
    switch (rowStyle) {
      case TvAreaRowStyle.assetVsAsset:
      case TvAreaRowStyle.assetVsAssetRanked:
        return Row(
          children: [
            Text(headerData.first),
            Text(headerData.second),
            Text(headerData.third),
          ],
        );
    }
    return Row();
  }
}

// class TvGroupHeaderSep extends StatelessWidget {
//   //
//   GroupHeaderData data;
//   TvGroupHeaderSep(
//     this.data, {
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container();
//   }
// }

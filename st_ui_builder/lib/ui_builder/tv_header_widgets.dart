part of StUiController;

/*


*/
class TvGroupHeader extends StatelessWidget {
  // standard group header widget
  final TvAreaRowStyle rowStyle;
  final AppScreen appScreen;
  final GroupHeaderData headerData;
  const TvGroupHeader(
    this.rowStyle,
    this.appScreen,
    this.headerData, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // standard group header widget
    // print('building a TvGroupHeader first: ${headerData.first}');
    return Container(
      height: 58,
      padding: const EdgeInsets.only(top: 4),
      color: StColors.black,
      child: _rowStyleToHeaderStyle(),
    );
  }

  Widget _rowStyleToHeaderStyle() {
    // TODO:  finish this below
    // temp placeholder UI
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          headerData.h1Displ,
          style: StTextStyles.h3,
        ),
        // Spacer(),
        Text(
          headerData.h2Displ,
          style: StTextStyles.h4.copyWith(
            color: Colors.grey,
          ),
        ),
        // Spacer(),
        // Text(headerData.third),
      ],
    );

    // TODO:  finish this
    switch (rowStyle) {
      case TvAreaRowStyle.assetVsAsset:
      case TvAreaRowStyle.assetVsAssetRanked:
        return Row(
          children: [
            Text(headerData.h1Displ),
            Text(headerData.h2Displ),
            Text(headerData.h3Displ),
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

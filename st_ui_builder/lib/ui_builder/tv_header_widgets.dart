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
    if (headerData.h1Displ.isEmpty && headerData.h2Displ.isEmpty) {
      return const SizedBox.shrink();
    }
    double height = 0;
    if (headerData.h1Displ.isNotEmpty) {
      height += 39;
    }
    if (headerData.h2Displ.isNotEmpty) {
      height += 39;
    }
    return Container(
      height: height.h,
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
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
          style: StTextStyles.h4,
        ),

        if (headerData.h2Displ.isNotEmpty)
          Text(
            headerData.h2Displ,
            style: StTextStyles.h6.copyWith(
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

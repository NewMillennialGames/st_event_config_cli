part of StUiController;

/*


*/

class TvGroupHeader extends StatelessWidget {
  // standard group header widget
  final TvAreaRowStyle rowStyle;
  final AppScreen appScreen;
  final GroupHeaderData headerData;
  //
  TvGroupHeader(
    this.rowStyle,
    this.appScreen,
    this.headerData, {
    Key? key,
  }) : super(key: key) {
    // hide values that are repeats from prior header rows
    headerData.patchFromPriorIfExists();
  }

  @override
  Widget build(BuildContext context) {
    // standard group header widget
    if (headerData.allLabelsAreEmpty) {
      return const SizedBox.shrink();
    }

    // NOTE:  to adjust row-height, tweak the font-size ratios in rowHeightAdjustmentForHidden
    double height = headerData.rowHeightAdjustmentForHidden * 14;

    return Container(
      height: height.h,
      padding: EdgeInsets.only(top: 4.h, bottom: 8.h),
      color: StColors.black,
      child: _rowStyleToHeaderStyle(),
    );
  }

  Widget _rowStyleToHeaderStyle() {
    // TODO:  finish this below;  not handling 3rd group level
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        if (headerData.h1Displ.isNotEmpty)
          Text(
            headerData.h1Displ,
            style: StTextStyles.h4,
            textAlign: headerData.h1DisplayJust.toTextAlign,
          ),
        if (headerData.h2Displ.isNotEmpty)
          Text(
            headerData.h2Displ,
            style: StTextStyles.h4.copyWith(
              color: Colors.grey,
            ),
            textAlign:
                headerData.h2DisplayJust?.toTextAlign ?? TextAlign.center,
          ),
        if (headerData.h3Displ.isNotEmpty)
          Text(
            headerData.h3Displ,
            style: StTextStyles.h6.copyWith(
              color: Colors.grey,
            ),
            textAlign:
                headerData.h3DisplayJust?.toTextAlign ?? TextAlign.center,
          ),
      ],
    );
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

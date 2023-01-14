part of StUiController;

/*


*/

class TvGroupHeader extends StatelessWidget {
  // standard group header widget
  final TvAreaRowStyle rowStyle;
  final AppScreen appScreen;
  final GroupHeaderData headerData;
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
    // TODO:  finish this below;  not handling 3rd group level
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          headerData.h1Displ,
          style: StTextStyles.h4,
          textAlign: headerData.h1DisplayJust.toTextAlign,
        ),

        if (headerData.h2Displ.isNotEmpty)
          Text(
            headerData.h2Displ,
            style: StTextStyles.h6.copyWith(
              color: Colors.grey,
            ),
            textAlign:
                headerData.h2DisplayJust?.toTextAlign ?? TextAlign.center,
          ),
        // Spacer(),
        // Text(headerData.third),
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

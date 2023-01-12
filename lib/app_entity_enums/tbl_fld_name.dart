part of AppEntities;

@JsonEnum()
enum DbTableFieldName {
  assetName,
  assetShortName,
  assetOrgName,
  leagueGrouping,
  competitionDate,
  competitionTime,
  competitionLocation,
  competitionName,
  imageUrl,
  assetOpenPrice,
  assetCurrentPrice,
  assetRankOrScore,
  assetPosition,
  basedOnEventDelimiters, // aka tournament style (only for groupings)
}

// deprecated:  use _filterTitleExtractor(i1.colName, i1.menuTitleIfFilter) instead
// extension DbTableFieldNameExt1 on DbTableFieldName {
//   //
//   String get displayName {
//     switch (this) {
//       case DbTableFieldName.assetName:
//         return "Name";
//       default:
//         return "";
//     }
//   }
// }

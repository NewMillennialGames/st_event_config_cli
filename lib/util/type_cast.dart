part of StUtil;

Type typeOf<T>() => T;

Iterable<int> castStrOfIdxsToIterOfInts(
  String componentIdxsStr, {
  String sep = ',',
  int dflt = -1,
}) {
  return componentIdxsStr
      .split(sep)
      .map((idxStr) => int.tryParse(idxStr) ?? dflt)
      .where((idx) => idx >= 0)
      // remove dups by conversion to set
      .toSet();
}

// Iterable<int> castListOfStrIdxsToIterOfInts(
//   Iterable<String> userRespStrList, {
//   String sep = ',',
//   int dflt = -1,
// }) {
//   return userRespStrList
//       .map((idxStr) => int.tryParse(idxStr) ?? dflt)
//       .where((idx) => idx >= 0)
//       // remove dups by conversion to set
//       .toSet();
// }

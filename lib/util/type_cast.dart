Type typeOf<T>() => T;

Iterable<int> castStrOfIdxsToIterOfInts(
  String componentIdxsStr, {
  String sep = ',',
}) {
  return componentIdxsStr
      .split(sep)
      .map((idxStr) => int.tryParse(idxStr) ?? -1)
      .where((idx) => idx >= 0)
      // remove dups by conversion to set
      .toSet();
}

Iterable<int> castListOfStrIdxsToIterOfInts(
  Iterable<String> userRespStrList, {
  String sep = ',',
}) {
  return userRespStrList
      .map((idxStr) => int.tryParse(idxStr) ?? -1)
      .where((idx) => idx >= 0)
      // remove dups by conversion to set
      .toSet();
}

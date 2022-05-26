class RegexFunctions {
RegExp formatNumberStringsWithCommas = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
String Function(Match) mathFunc = (Match match) => '${match[1]},';
}
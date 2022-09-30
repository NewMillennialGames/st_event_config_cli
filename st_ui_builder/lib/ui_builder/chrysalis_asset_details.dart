class ChrysalisAssetDetails {
  final String accessibilityIssue;
  final String custodyType;
  final String walletType;
  final String walletProvider;
  final double units;
  final bool isDistressed;

  ChrysalisAssetDetails({
    required this.accessibilityIssue,
    required this.custodyType,
    required this.walletType,
    required this.walletProvider,
    required this.units,
    this.isDistressed = false,
  });

  factory ChrysalisAssetDetails.fromJson(Map<String, dynamic> json) {
    final base = json["X-Asset Attributes"] ?? {};
    return ChrysalisAssetDetails(
      accessibilityIssue: base["C_Accessability_Issue"] ?? "None",
      custodyType: base["C_CustodyType"] ?? "",
      walletType: base["C_WalletType"] ?? "",
      walletProvider: base["C_WalletProvider"] ?? "",
      units: double.tryParse("${base["C_Number of Units"]}") ?? 0,
      isDistressed: base["C_Distressed"] ?? false,
    );
  }
}

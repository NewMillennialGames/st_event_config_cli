import 'dart:convert';
import 'dart:io';

Future<Map<String, dynamic>> readJsonFile(String filePath) async {
  //
  String input = await File(filePath).readAsString();
  return jsonDecode(input) as Map<String, dynamic>;
}

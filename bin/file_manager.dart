import 'dart:convert';
import 'dart:io';
import 'constants.dart';
import 'printer.dart';

class FileManager {
  String path;

  FileManager({required this.path});

  Future<File> createOrSelectFile() async {
    File file = File(path);
    await file.create();
    return file;
  }

  Future<String> receiveApiKeyFromFile(File file) async {
    String textFromFile = await _readKeyFromFile(file);
    if (textFromFile.isNotEmpty) {
      Map<String, dynamic> map = jsonDecode(textFromFile);
      return map[API_KEY_STRING];
    } else {
      return _writeKeyInFileAndGet(file);
    }
  }

  Future<String> _readKeyFromFile(File file) async {
    return await file.readAsString();
  }

  String _writeKeyInFileAndGet(File file) {
    stdout.write("""
 ~ Required ${UNDERLINE}Google Studio API key$RESET (If you don't already have a key,
   please CREATE KEY in https://aistudio.google.com/app/apikey)\n
$BLUE ~ key$RESET : ->  """);
    String apiKey = stdin.readLineSync() ?? "";
    Map<String, dynamic> keyMap = {API_KEY_STRING: apiKey};
    file.writeAsString(jsonEncode(keyMap));
    return apiKey;
  }

  replaceKeyInFile(File file) {
    Printer.printInColor(
      """ ~ Your key is invalid. Please pass a valid key  and try again ->  """,
      RED,
    );
    String? newKey = stdin.readLineSync();
    Map<String, dynamic> newKeyMap = {API_KEY_STRING: newKey};
    file.writeAsString(jsonEncode(newKeyMap));
    stdout.write(
        "$GREEN ~ Your key has been replaced. Please run it again and check if it works.");
  }
}

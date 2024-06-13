import 'dart:convert';
import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';

const API_KEY_STRING = "key";
const MODEL_NAME = "gemini-1.5-flash-latest";

void main(List<String> arguments) async {
  File file = await createOrSelectFile();
  String apiKey = await receiveApiKey(file);
  try {
    GenerativeModel model = GenerativeModel(model: MODEL_NAME, apiKey: apiKey);
    ChatSession chatSession = model.startChat();
    while (true) {
      stdout.write("~ Your question ->");
      String? question = stdin.readLineSync();
      stdout.write("\n");
      if (question == null || question.isEmpty) {
        continue;
      }
      String aiAnswer = await chatSession
          .sendMessage(Content.text(question))
          .then((onValue) => onValue.text ?? "");
      stdout.write(aiAnswer);
      stdout.write("\n");
    }
  } on GenerativeAIException catch (e) {
    if (e.message.contains("API key not valid")) {
      stdout.write("""
~ Your key is invalid. Please pass a valid key ->  """);
      String? newKey = stdin.readLineSync();
      Map<String, dynamic> newKeyMap = {API_KEY_STRING: newKey};
      file.writeAsString(jsonEncode(newKeyMap));
    }
  }
}

Future<File> createOrSelectFile() async {
  File file = File("./config.json");
  await file.create();
  return file;
}

Future<String> receiveApiKey(File file) async {
  var fileText = await file.readAsString();
  if (fileText.isNotEmpty) {
    Map<String, dynamic> map = jsonDecode(fileText);
    return map[API_KEY_STRING];
  } else {
    stdout.write("""
 ~ Required Google Studio API key
 (If you don't already have a key, please CREATE KEY in https://aistudio.google.com/app/apikey)
 key : ->  """);
    String apiKey = stdin.readLineSync() ?? "";
    Map<String, dynamic> keyMap = {API_KEY_STRING: apiKey};
    file.writeAsString(jsonEncode(keyMap));
    return apiKey;
  }
}

import 'dart:io';

import 'package:google_generative_ai/google_generative_ai.dart';
import 'functions.dart';
import 'file_manager.dart';

void main(List<String> arguments) async {
  FileManager fileManager = FileManager(path: "./config.json");
  File file = await fileManager.createOrSelectFile();
  String apiKey = await fileManager.receiveApiKeyFromFile(file);
  try {
    await startChat(apiKey);
  } on GenerativeAIException catch (aiError) {
    if (aiError.message.contains("API key not valid")) {
      fileManager.replaceKeyInFile(file);
    }
  }
}

import 'dart:io';
import 'package:google_generative_ai/google_generative_ai.dart';

import 'constants.dart';
import 'formatter.dart';

Future<void> startChat(String apiKey) async {
  GenerativeModel model = GenerativeModel(
    model: MODEL_NAME,
    apiKey: apiKey,
  );
  ChatSession chatSession = model.startChat();
  while (true) {
    stdout.write("$BLUE ~ Your question -> $RESET");
    String? question = stdin.readLineSync();
    if (question == null || question.isEmpty) {
      continue;
    }
    if (question == "exit") {
      break;
    }
    String aiAnswer = await chatSession
        .sendMessage(Content.text(question))
        .then((onValue) => onValue.text ?? "");
    var formattedText = Formatter.formatText(aiAnswer);
    stdout.write(formattedText);
    stdout.write("\n");
  }
}

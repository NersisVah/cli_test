import 'constants.dart';

class Formatter {
  static String formatText(String text) {
    return text.replaceAllMapped(RegExp(r'\*\*(.*?)\*\*'), (Match match) {
      return "$UNDERLINE$BOLD${match.group(1)}$RESET";
    });
  }
}

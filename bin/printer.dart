import 'dart:io';
import 'constants.dart';

class Printer {
  Printer._();

  static void printInColor(String text, String color) {
    stdout.write('$color$text$RESET ');
  }

  static void printInBold(String text) {
    stdout.write('$BOLD$text$RESET ');
  }
}

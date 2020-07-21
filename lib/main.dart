import 'package:flutter/material.dart';
import 'package:jp_flashcard/screens/main_menu/main_menu.dart';
import 'package:jp_flashcard/services/theme.dart';

void main() {
  runApp(MaterialApp(
    home: MainMenu(),
    theme: MyTheme.theme,
  ));
}
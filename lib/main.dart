import 'package:flutter/material.dart';
import 'package:jp_flashcard/screens/repo_menu_page/repo_menu_page.dart';
import 'package:jp_flashcard/services/theme.dart';

void main() {
  runApp(MaterialApp(
    home: RepoMenuPage(),
    theme: MyTheme.theme,
    routes: <String, WidgetBuilder>{
      '/repo_menu_page': (_) {
        return RepoMenuPage();
      }
    },
  ));
}

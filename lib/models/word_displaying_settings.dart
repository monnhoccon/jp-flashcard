import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WordDisplayingSettings with ChangeNotifier {
  bool hasFurigana = true;
  bool hasKanji = true;
  bool furiganaLocked = false;
  var persistData;

  void refresh() async {
    persistData = await SharedPreferences.getInstance();
    hasFurigana = persistData.getBool('hasFurigana') ?? true;
    hasKanji = persistData.getBool('hasKanji') ?? true;

    if (!hasKanji) {
      hasFurigana = false;
    }
    notifyListeners();
  }

  WordDisplayingSettings() {
    refresh();
  }
  

  void toggleFurigana() {
    if (!hasKanji || furiganaLocked) {
      return;
    }
    hasFurigana = !hasFurigana;
    persistData.setBool('hasFurigana', hasFurigana);
    notifyListeners();
  }

  void toggleKanji() {
    if (hasKanji == true) {
      //Toggle to no kanji
      hasFurigana = false;
    } else {
      //Toggle to has kanji
      hasFurigana = persistData.getBool('hasFurigana') ?? true;
    }
    hasKanji = !hasKanji;

    persistData.setBool('hasKanji', hasKanji);
    notifyListeners();
  }
}

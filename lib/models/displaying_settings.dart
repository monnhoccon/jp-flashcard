import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DisplayingSettings with ChangeNotifier {
  bool hasFurigana = true;
  bool hasKanji = true;
  bool displayTag = false;
  var persistData;

  void refresh() async {
    persistData = await SharedPreferences.getInstance();
    hasFurigana = persistData.getBool('hasFurigana') ?? true;
    hasKanji = persistData.getBool('noKanji') ?? true;
    displayTag = persistData.getBool('displayTag') ?? false;

    if (!hasKanji) {
      hasFurigana = false;
    }
    notifyListeners();
  }

  DisplayingSettings() {
    refresh();
  }

  void toggleFurigana() {
    if (!hasKanji) {
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

    persistData.setBool('noKanji', hasKanji);
    notifyListeners();
  }
}

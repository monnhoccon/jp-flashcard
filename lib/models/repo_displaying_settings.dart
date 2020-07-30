import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepoDisplayingSettings with ChangeNotifier {
  bool displayTag = true;
  var persistData;

  void refresh() async {
    persistData = await SharedPreferences.getInstance();
    displayTag = persistData.getBool('displayTag') ?? true;

    notifyListeners();
  }

  RepoDisplayingSettings() {
    refresh();
  }

  void toggleTag() {
    displayTag = !displayTag;
    persistData.setBool('displayTag', displayTag);
    notifyListeners();
  }

  
}

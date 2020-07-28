import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuizSettings extends ChangeNotifier {
  //ANCHOR Public variables
  bool enableDefinitionSelectionQuiz = true;
  bool enableDefinitionShortAnswerQuiz = true;
  bool enableWordSelectionQuiz = true;
  bool enableWordShortAnswerQuiz = true;
  bool enableKanjiShortAnswerQuiz = true;
  bool enableAnswerAudio = true;
  bool onlyShowFavorite = true;

  //ANCHOR Constructor
  QuizSettings() {
    refresh();
  }

  //ANCHOR Initialize variables
  var _persistData;
  Future<void> refresh() async {
    _persistData = await SharedPreferences.getInstance();
    enableDefinitionSelectionQuiz =
        _persistData.getBool('enableDefinitionSelectionQuiz') ?? true;
    enableDefinitionShortAnswerQuiz =
        _persistData.getBool('enableDefinitionShortAnswerQuiz') ?? true;
    enableWordSelectionQuiz =
        _persistData.getBool('enableWordSelectionQuiz') ?? true;
    enableWordShortAnswerQuiz =
        _persistData.getBool('enableWordShortAnswerQuiz') ?? true;
    enableKanjiShortAnswerQuiz =
        _persistData.getBool('enableKanjiShortAnswerQuiz') ?? true;
    enableAnswerAudio = _persistData.getBool('enableAnswerAudio') ?? true;
    onlyShowFavorite = _persistData.getBool('onlyShowFavorite') ?? false;
    notifyListeners();
  }

  //ANCHOR Toggle functions
  void toggleDefinitionSelectionQuiz() {
    if (enableDefinitionSelectionQuiz &&
        !enableDefinitionShortAnswerQuiz &&
        !enableKanjiShortAnswerQuiz &&
        !enableWordSelectionQuiz &&
        !enableWordShortAnswerQuiz) {
      return;
    }
    enableDefinitionSelectionQuiz = !enableDefinitionSelectionQuiz;
    _persistData.setBool(
        'enableDefinitionSelectionQuiz', enableDefinitionSelectionQuiz);
    notifyListeners();
  }

  void toggleDefinitionShortAnswerQuiz() {
    if (!enableDefinitionSelectionQuiz &&
        enableDefinitionShortAnswerQuiz &&
        !enableKanjiShortAnswerQuiz &&
        !enableWordSelectionQuiz &&
        !enableWordShortAnswerQuiz) {
      return;
    }
    enableDefinitionShortAnswerQuiz = !enableDefinitionShortAnswerQuiz;
    _persistData.setBool(
        'enableDefinitionShortAnswerQuiz', enableDefinitionShortAnswerQuiz);
    notifyListeners();
  }

  void toggleWordSelectionQuiz() {
    if (!enableDefinitionSelectionQuiz &&
        !enableDefinitionShortAnswerQuiz &&
        !enableKanjiShortAnswerQuiz &&
        enableWordSelectionQuiz &&
        !enableWordShortAnswerQuiz) {
      return;
    }
    enableWordSelectionQuiz = !enableWordSelectionQuiz;
    _persistData.setBool('enableWordSelectionQuiz', enableWordSelectionQuiz);
    notifyListeners();
  }

  void toggleWordShortAnswerQuiz() {
    if (!enableDefinitionSelectionQuiz &&
        !enableDefinitionShortAnswerQuiz &&
        !enableKanjiShortAnswerQuiz &&
        !enableWordSelectionQuiz &&
        enableWordShortAnswerQuiz) {
      return;
    }
    enableWordShortAnswerQuiz = !enableWordShortAnswerQuiz;
    _persistData.setBool(
        'enableWordShortAnswerQuiz', enableWordShortAnswerQuiz);
    notifyListeners();
  }

  void toggleKanjiShortAnswerQuiz() {
    if (!enableDefinitionSelectionQuiz &&
        !enableDefinitionShortAnswerQuiz &&
        enableKanjiShortAnswerQuiz &&
        !enableWordSelectionQuiz &&
        !enableWordShortAnswerQuiz) {
      return;
    }
    enableKanjiShortAnswerQuiz = !enableKanjiShortAnswerQuiz;
    _persistData.setBool(
        'enableKanjiShortAnswerQuiz', enableKanjiShortAnswerQuiz);
    notifyListeners();
  }

  void toggleAnswerAudio() {
    enableAnswerAudio = !enableAnswerAudio;
    _persistData.setBool('enableAnswerAudio', enableAnswerAudio);
    notifyListeners();
  }

  void toggleShowFavorite() {
    onlyShowFavorite = !onlyShowFavorite;
    _persistData.setBool('onlyShowFavorite', onlyShowFavorite);
    notifyListeners();
  }
}

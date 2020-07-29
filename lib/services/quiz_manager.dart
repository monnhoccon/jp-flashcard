import 'dart:math';
import 'package:collection/collection.dart';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/models/quiz_settings.dart';
import 'package:jp_flashcard/screens/learning/definition_selection_quiz.dart';
import 'package:jp_flashcard/screens/learning/definition_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/kanji_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/components/quiz_answer_dialog.dart';
import 'package:jp_flashcard/screens/learning/word_selection_quiz.dart';
import 'package:jp_flashcard/screens/learning/word_short_answer_quiz.dart';
import 'package:jp_flashcard/services/flashcard_manager.dart';

enum QuizType {
  definition_selection,
  definition_shortAnswer,
  word_selection,
  word_short_answer,
  kanji_short_answer,
}

class QuizManager extends ChangeNotifier {
  //ANCHOR Public variables
  int repoId;

  //ANCHOR Constructor
  QuizManager({this.repoId}) {
    _initVariables();
  }

  //ANCHOR Initialize variables
  FlashcardList _flashcardList;
  QuizSettings _quizSettings;

  void _initVariables() async {
    _quizSettings = QuizSettings();
    await _quizSettings.refresh();
    _flashcardList = FlashcardList(repoId: repoId);
    await _refreshFlashcardList();
    navigateToNextQuiz();
  }

  Widget currentQuiz = Container();

  Future<void> _updateProgress(
      FlashcardInfo flashcardInfo, bool positive) async {
    //Add or minus progress according to the quiz type
    int newProgress = flashcardInfo.progress;
    if (_quizType == QuizType.definition_selection) {
      newProgress += positive ? 5 : -5;
    } else if (_quizType == QuizType.definition_shortAnswer) {
      newProgress += positive ? 7 : -3;
    } else if (_quizType == QuizType.word_selection) {
      newProgress += positive ? 5 : -5;
    } else if (_quizType == QuizType.word_short_answer) {
      newProgress += positive ? 7 : -3;
    } else if (_quizType == QuizType.kanji_short_answer) {
      newProgress += positive ? 7 : -3;
    }

    //Checking whether out of range
    if (newProgress > 100) {
      newProgress = 100;
    } else if (newProgress < 0) {
      newProgress = 0;
    }
    await FlashcardManager.db(repoId)
        .updateProgress(flashcardInfo.flashcardId, newProgress);
    await _refreshFlashcardList();
    return;
  }

  //ANCHOR Answer correct
  void answerCorrect(FlashcardInfo flashcardInfo, BuildContext context) async {
    await _updateProgress(flashcardInfo, true);
    await QuizAnswerDialog.correct(
            flashcardInfo, _quizSettings.enableAnswerAudio)
        .dialog(context);
    navigateToNextQuiz();
  }

  //ANCHOR Answer incorrect
  void answerIncorrect(
      FlashcardInfo flashcardInfo, BuildContext context) async {
    await _updateProgress(flashcardInfo, false);
    await QuizAnswerDialog.incorrect(
            flashcardInfo, _quizSettings.enableAnswerAudio)
        .dialog(context);
    navigateToNextQuiz();
  }

  void navigateToNextQuiz() {
    _quizType = _randomQuizType();

    _currentFlashcardInfo = _randomFlashcardInfo();
    if (_quizType == QuizType.definition_selection) {
      currentQuiz = DefinitionSelectionQuiz(
        flashcardInfo: _currentFlashcardInfo,
      );
    } else if (_quizType == QuizType.definition_shortAnswer) {
      currentQuiz = DefinitionShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: _currentFlashcardInfo,
      );
    } else if (_quizType == QuizType.word_selection) {
      currentQuiz = WordSelectionQuiz(
        flashcardInfo: _currentFlashcardInfo,
      );
    } else if (_quizType == QuizType.word_short_answer) {
      currentQuiz = WordShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: _flashcardList.flashcardInfoList[0],
      );
    } else if (_quizType == QuizType.kanji_short_answer) {
      currentQuiz = KanjiShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: _currentFlashcardInfo,
      );
    }

    notifyListeners();
  }

  //ANCHOR Generate random quiz type
  QuizType _quizType;
  QuizType _randomQuizType() {
    int randomInt = Random().nextInt(1); //QuizType.values.length);
    return QuizType.definition_selection;
  }

  //ANCHOR Generate random flashcardInfo
  FlashcardInfo _currentFlashcardInfo;
  FlashcardInfo _randomFlashcardInfo() {
    return _currentFlashcardInfoList
        .toList()[Random().nextInt(_indexUpperBound)];
  }

  PriorityQueue<FlashcardInfo> _currentFlashcardInfoList = PriorityQueue(
    (FlashcardInfo a, FlashcardInfo b) {
      return b.progress - a.progress;
    },
  );

  int _indexUpperBound;
  Future<void> _refreshFlashcardList() async {
    await _flashcardList.refresh();
    _currentFlashcardInfoList.clear();
    for (final flashcardInfo in _flashcardList.flashcardInfoList) {
      if (!_quizSettings.onlyShowFavorite) {
        if (flashcardInfo.progress >= 100) {
          continue;
        } else if (flashcardInfo.progress >= 80 && Random().nextInt(2) > 0) {
          continue;
        } else if (flashcardInfo.progress >= 40 && Random().nextInt(4) > 3) {
          continue;
        }
      }
      if (!_quizSettings.onlyShowFavorite && flashcardInfo.progress < 100 ||
          (_quizSettings.onlyShowFavorite && flashcardInfo.favorite)) {
        _currentFlashcardInfoList.add(flashcardInfo);
      }
    }

    _indexUpperBound = _currentFlashcardInfoList.length;
    if (!_quizSettings.onlyShowFavorite && _indexUpperBound > 10) {
      _indexUpperBound = 10;
    }
  }

  //ANCHOR Refresh quiz settings
  void refreshQuizSettings() async {
    await _quizSettings.refresh();
  }

  dynamic getRandomFlashcardInfoList(FlashcardInfo flashcardInfo) {
    int numResult = 3;
    Set<FlashcardInfo> randomFlashcardInfoSet = Set();
    while (randomFlashcardInfoSet.length < numResult) {
      FlashcardInfo randomFlashcardInfo =
          randomChoice(_flashcardList.flashcardInfoList);
      if (randomFlashcardInfo != flashcardInfo) {
        randomFlashcardInfoSet.add(randomFlashcardInfo);
      }
    }

    return randomFlashcardInfoSet.toList();
  }
}

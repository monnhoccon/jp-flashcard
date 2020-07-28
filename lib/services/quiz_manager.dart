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
import 'package:jp_flashcard/screens/learning/quiz_answer_dialog.dart';
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
  QuizType _quizType;
  void _initVariables() async {
    _flashcardList = FlashcardList(repoId: repoId);
    await _flashcardList.refresh();
    _refreshCurrentFlashcardInfoList();
    _quizSettings = QuizSettings();
    await _quizSettings.refresh();
    enableAnswerAudio = _quizSettings.enableAnswerAudio;
    navigateToNextQuiz();
  }

  Widget currentQuiz = Container();

  void answerCorrect(FlashcardInfo flashcardInfo, BuildContext context) async {
    int newProgress = flashcardInfo.progress + 5;
    if (newProgress > 100) {
      newProgress = 100;
    }
    await FlashcardManager.db(repoId)
        .updateProgress(flashcardInfo.flashcardId, newProgress);
    await _flashcardList.refresh();
    _refreshCurrentFlashcardInfoList();
    await QuizAnswerDialog.correct(flashcardInfo, enableAnswerAudio)
        .dialog(context);
    navigateToNextQuiz();
  }

  void answerIncorrect(
      FlashcardInfo flashcardInfo, BuildContext context) async {
    int newProgress = flashcardInfo.progress - 5;
    if (newProgress < 0) {
      newProgress = 0;
    }
    await FlashcardManager.db(repoId)
        .updateProgress(flashcardInfo.flashcardId, newProgress);
    await _flashcardList.refresh();
    _refreshCurrentFlashcardInfoList();
    await QuizAnswerDialog.incorrect(flashcardInfo, enableAnswerAudio)
        .dialog(context);
    navigateToNextQuiz();
  }

  void navigateToNextQuiz() {
    _quizType = _randomQuizType();
    int upperBound = _flashcardList.flashcardInfoList.length - 1;
    if (upperBound > 8) {
      upperBound = 8;
    }
    FlashcardInfo flashcardInfo =
        _currentFlashcardInfoList.toList()[Random().nextInt(upperBound)];
    if (_quizType == QuizType.definition_selection) {
      currentQuiz = DefinitionSelectionQuiz(
        flashcardInfo: flashcardInfo,
      );
    } else if (_quizType == QuizType.definition_shortAnswer) {
      currentQuiz = DefinitionShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: flashcardInfo,
      );
    } else if (_quizType == QuizType.word_selection) {
      currentQuiz = WordSelectionQuiz(
        repoId: repoId,
        flashcardInfo: flashcardInfo,
      );
    } else if (_quizType == QuizType.word_short_answer) {
      currentQuiz = WordShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: _flashcardList.flashcardInfoList[0],
      );
    } else if (_quizType == QuizType.kanji_short_answer) {
      currentQuiz = KanjiShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: flashcardInfo,
      );
    }

    notifyListeners();
  }

  QuizType _randomQuizType() {
    int randomInt = Random().nextInt(1); //QuizType.values.length);
    return QuizType.values[randomInt];
  }

  PriorityQueue<FlashcardInfo> _currentFlashcardInfoList = PriorityQueue(
    (FlashcardInfo a, FlashcardInfo b) {
      return b.progress - a.progress;
    },
  );

  void _refreshCurrentFlashcardInfoList() {
    _currentFlashcardInfoList.clear();
    for (final flashcardInfo in _flashcardList.flashcardInfoList) {
      if (flashcardInfo.progress > 100) {
        continue;
      }
      _currentFlashcardInfoList.add(flashcardInfo);
    }
  }

  //ANCHOR Refresh quiz settings
  bool enableAnswerAudio;
  void refreshQuizSettings() async {
    await _quizSettings.refresh();
    enableAnswerAudio = _quizSettings.enableAnswerAudio;
  }
}

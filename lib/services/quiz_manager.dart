import 'dart:math';
import 'package:collection/collection.dart';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displaying_settings.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/models/quiz_settings.dart';
import 'package:jp_flashcard/screens/learning/definition_selection_quiz.dart';
import 'package:jp_flashcard/screens/learning/definition_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/kanji_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/components/quiz_answer_dialog.dart';
import 'package:jp_flashcard/screens/learning/word_selection_quiz.dart';
import 'package:jp_flashcard/screens/learning/word_short_answer_quiz.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/flashcard_manager.dart';
import 'package:provider/provider.dart';

enum QuizType {
  definition_selection,
  definition_short_answer,
  word_selection,
  word_short_answer,
  kanji_short_answer,
}

class QuizManager extends ChangeNotifier {
  //ANCHOR Public variables
  final int repoId;
  final BuildContext context;

  //ANCHOR Constructor
  QuizManager({this.repoId, this.context}) {
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
    if (newProgress >= 100) {
      return;
    }
    if (_quizType == QuizType.definition_selection) {
      newProgress += positive ? 5 : -5;
    } else if (_quizType == QuizType.definition_short_answer) {
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
    return;
  }

  //ANCHOR Answer correct
  void answerCorrect(FlashcardInfo flashcardInfo, BuildContext context) async {
    await _updateProgress(flashcardInfo, true);
    await QuizAnswerDialog.correct(
            flashcardInfo, _quizSettings.enableAnswerAudio)
        .dialog(context);
    navigateToNextQuiz();
    return;
  }

  //ANCHOR Answer incorrect
  void answerIncorrect(
      FlashcardInfo flashcardInfo, BuildContext context) async {
    await _updateProgress(flashcardInfo, false);
    await QuizAnswerDialog.incorrect(
            flashcardInfo, _quizSettings.enableAnswerAudio)
        .dialog(context);
    navigateToNextQuiz();
    return;
  }

  void navigateToNextQuiz() async {
    _quizType = _randomQuizType();
    int indexUpperBound = await _refreshFlashcardList();

    //No cards founded
    if (indexUpperBound == 0) {
      currentQuiz = Container(
        child: Center(
          child: Text(
            DisplayedString.zhtw['no card'] ?? '',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      );
      notifyListeners();
      return;
    }

    _currentFlashcardInfo = _randomFlashcardInfo(indexUpperBound);
    if (_quizType == QuizType.definition_selection) {
      currentQuiz = DefinitionSelectionQuiz(
        flashcardInfo: _currentFlashcardInfo,
      );
    } else if (_quizType == QuizType.definition_short_answer) {
      currentQuiz = DefinitionShortAnswerQuiz(
        flashcardInfo: _currentFlashcardInfo,
      );
    } else if (_quizType == QuizType.word_selection) {
      currentQuiz = WordSelectionQuiz(
        flashcardInfo: _currentFlashcardInfo,
      );
    } else if (_quizType == QuizType.word_short_answer) {
      currentQuiz = WordShortAnswerQuiz(
        flashcardInfo: _currentFlashcardInfo,
      );
    } else if (_quizType == QuizType.kanji_short_answer) {
      currentQuiz = KanjiShortAnswerQuiz(
        flashcardInfo: _currentFlashcardInfo,
      );
    }

    notifyListeners();
    return;
  }

  //ANCHOR Generate random quiz type
  QuizType _quizType;
  QuizType _randomQuizType() {
    int randomInt = Random().nextInt(100);
    if (randomInt < 25 && _quizSettings.enableDefinitionSelectionQuiz) {
      //25%
      return QuizType.definition_selection;
    } else if (randomInt < 35 &&
        _quizSettings.enableDefinitionShortAnswerQuiz) {
      //10%
      return QuizType.definition_short_answer;
    } else if (randomInt < 60 && _quizSettings.enableWordSelectionQuiz) {
      //25%
      return QuizType.word_selection;
    } else if (randomInt < 70 && _quizSettings.enableWordShortAnswerQuiz) {
      //10%
      return QuizType.word_short_answer;
    } else if (randomInt < 100 && _quizSettings.enableKanjiShortAnswerQuiz) {
      //30%
      return QuizType.kanji_short_answer;
    }
    return _randomQuizType();
  }

  //ANCHOR Generate random flashcardInfo
  FlashcardInfo _currentFlashcardInfo;
  FlashcardInfo _randomFlashcardInfo(int indexUpperBound) {
    return _currentFlashcardInfoList
        .toList()[Random().nextInt(indexUpperBound)];
  }

  PriorityQueue<FlashcardInfo> _currentFlashcardInfoList = PriorityQueue(
    (FlashcardInfo a, FlashcardInfo b) {
      return b.progress - a.progress;
    },
  );

  Future<int> _refreshFlashcardList() async {
    await _flashcardList.refresh();
    _currentFlashcardInfoList.clear();
    for (final flashcardInfo in _flashcardList.flashcardInfoList) {
      //Check whether the flashcard has kanji
      if (_quizType == QuizType.kanji_short_answer &&
          flashcardInfo.kanji.isEmpty) {
        continue;
      }
      if (!_quizSettings.onlyShowFavorite) {
        if (flashcardInfo.progress >= 100 && Random().nextInt(7) > 5) {
          continue;
        } else if (flashcardInfo.progress >= 80 && Random().nextInt(2) > 0) {
          continue;
        } else if (flashcardInfo.progress >= 40 && Random().nextInt(4) > 2) {
          continue;
        }
        _currentFlashcardInfoList.add(flashcardInfo);
      } else {
        if (flashcardInfo.favorite) {
          _currentFlashcardInfoList.add(flashcardInfo);
        }
      }
    }

    int indexUpperBound = _currentFlashcardInfoList.length;
    if (!_quizSettings.onlyShowFavorite && indexUpperBound > 8) {
      indexUpperBound = 8;
    }
    return indexUpperBound;
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

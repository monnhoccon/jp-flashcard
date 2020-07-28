import 'dart:math';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_list.dart';
import 'package:jp_flashcard/screens/learning/definition_selection_quiz.dart';
import 'package:jp_flashcard/screens/learning/definition_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/kanji_short_answer_quiz.dart';
import 'package:jp_flashcard/screens/learning/word_selection_quiz.dart';
import 'package:jp_flashcard/screens/learning/word_short_answer_quiz.dart';

enum QuizType {
  definition_selection,
  definition_shortAnswer,
  word_selection,
  word_short_answer,
  kanji_short_answer,
}

class QuizManager extends ChangeNotifier {
  var randomGenerator;
  FlashcardList flashcardList;
  Widget currentQuiz = Container();

  void navigateToNextQuiz() {
    QuizType quizType = randomQuizType();
    
    if (quizType == QuizType.definition_selection) {
      currentQuiz = DefinitionSelectionQuiz(
        flashcardInfo: flashcardList.flashcardInfoList[0],
      );
    } 
    else if (quizType == QuizType.definition_shortAnswer) {
      currentQuiz = DefinitionShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: flashcardList.flashcardInfoList[0],
      );
    } else if (quizType == QuizType.word_selection) {
      currentQuiz = WordSelectionQuiz(
        repoId: repoId,
        flashcardInfo: flashcardList.flashcardInfoList[0],
      );
    } else if (quizType == QuizType.word_short_answer) {
      currentQuiz = WordShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: flashcardList.flashcardInfoList[0],
      );
    } else if (quizType == QuizType.kanji_short_answer) {
      currentQuiz = KanjiShortAnswerQuiz(
        repoId: repoId,
        flashcardInfo: flashcardList.flashcardInfoList[0],
      );
    }
    
    notifyListeners();
  }

  QuizType randomQuizType() {
    int randomInt = randomGenerator.nextInt(1);//QuizType.values.length);
    return QuizType.values[randomInt];
  }

  void initVariables() async {
    flashcardList = FlashcardList(repoId: repoId);
    await flashcardList.refresh();
    randomGenerator = Random();
    navigateToNextQuiz();
  }

  int repoId;
  QuizManager({this.repoId}) {
    initVariables();
  }
}

import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/quiz_page/components/displayed_options.dart';
import 'package:jp_flashcard/screens/quiz_page/components/displayed_question.dart';
import 'package:jp_flashcard/services/managers/quiz_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class WordSelectionQuiz extends StatelessWidget {
  //ANCHOR Public variables
  final FlashcardInfo flashcardInfo;
  WordSelectionQuiz({this.flashcardInfo});

  //ANCHOR Apply selection
  void _applySelection(int index, BuildContext context) {
    if (index == _correctAnswerIndex) {
      _quizManager.answerCorrect(flashcardInfo, context);
    } else {
      _quizManager.answerIncorrect(flashcardInfo, context);
    }
    return;
  }

  //ANCHOR Initialize displayed word list
  String _displayedDefinition;
  int _correctAnswerIndex;
  List<FlashcardInfo> _displayedWordList;

  void _initDisplayedWordList() {
    //Random choose one definition to display
    _displayedDefinition = randomChoice(flashcardInfo.definition);

    //Get 3 random flashcard infos
    _displayedWordList = _quizManager.getRandomFlashcardInfoList(flashcardInfo);

    //Add the correct answer
    _correctAnswerIndex = Random().nextInt(4);
    _displayedWordList.insert(_correctAnswerIndex, flashcardInfo);
    return;
  }

  //ANCHOR Initialize variables
  QuizManager _quizManager;

  void _initVariables(BuildContext context) {
    _quizManager = Provider.of<QuizManager>(context, listen: false);
    return;
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Initialize
    _initVariables(context);
    _initDisplayedWordList();

    //ANCHOR Word selection quiz
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //ANCHOR Displayed question
          DisplayedQuestion(
            child: Text(
              _displayedDefinition,
              style: TextStyle(fontSize: 35, height: 1.2),
            ),
          ),

          //ANCHOR Displayed options
          DisplayedOptions(
            options: _displayedWordList,
            applySelection: _applySelection,
            onlyString: false,
          ),
        ],
      ),
    );
  }
}

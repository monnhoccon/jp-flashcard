import 'dart:math';
import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/components/displayed_word.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';
import 'components/displayed_options.dart';
import 'components/displayed_question.dart';

// ignore: must_be_immutable
class DefinitionSelectionQuiz extends StatelessWidget {
  //ANCHOR Public Variables
  final FlashcardInfo flashcardInfo;

  //ANCHOR Constructor
  DefinitionSelectionQuiz({this.flashcardInfo});

  //ANCHOR Apply selection
  void _applySelection(int index, BuildContext context) {
    if (index == _correctAnswerIndex) {
      _quizManager.answerCorrect(flashcardInfo, context);
    } else {
      _quizManager.answerIncorrect(flashcardInfo, context);
    }
  }

  //ANCHOR Initialize displayed defintion list
  List<FlashcardInfo> _randomFlashcardInfoList = [];
  List<String> _displayedDefinitionList = [];
  int _correctAnswerIndex;

  void _initDisplayedDefinitionList() {
    //Get 3 random flashcard infos
    _randomFlashcardInfoList =
        _quizManager.getRandomFlashcardInfoList(flashcardInfo);

    //Convert to list of string
    _displayedDefinitionList.clear();
    for (final randomFlashcardInfo in _randomFlashcardInfoList) {
      _displayedDefinitionList
          .add(randomChoice(randomFlashcardInfo.definition));
    }

    //Add the correct answer
    _correctAnswerIndex = Random().nextInt(4);
    _displayedDefinitionList.insert(
        _correctAnswerIndex, randomChoice(flashcardInfo.definition));
  }

  //ANCHOR Initialize variables
  QuizManager _quizManager;
  void _initVariables(BuildContext context) {
    _quizManager = Provider.of<QuizManager>(context, listen: false);
  }

  @override
  //ANCHOR Build
  Widget build(BuildContext context) {
    //ANCHOR Initialize
    _initVariables(context);
    _initDisplayedDefinitionList();

    //ANCHOR Definition selection quiz
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //ANCHOR Displayed word
          DisplayedQuestion(
            child: DisplayedWord(
              flashcardInfo: flashcardInfo,
              displayedWordSize: DisplayedWordSize.large(),
            ),
          ),

          //ANCHOR Displayed definition list
          DisplayedOptions(
            options: _displayedDefinitionList,
            applySelection: _applySelection,
            onlyString: true,
          ),
        ],
      ),
    );
  }
}

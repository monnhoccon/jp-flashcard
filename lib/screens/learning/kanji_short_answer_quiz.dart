import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/learning/components/action_button.dart';
import 'package:jp_flashcard/screens/learning/components/displayed_question.dart';
import 'package:jp_flashcard/components/displayed_word.dart';
import 'package:jp_flashcard/screens/repo/widget/kanji_input.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class KanjiShortAnswerQuiz extends StatelessWidget {
  //ANCHOR Public variables
  final FlashcardInfo flashcardInfo;

  //ANCHOR Constructor
  KanjiShortAnswerQuiz({this.flashcardInfo});

  //ANCHOR Confirm input
  void _confirmInput(bool correct, BuildContext context) {
    if (correct) {
      _quizManager.answerCorrect(flashcardInfo, context);
    } else {
      _quizManager.answerIncorrect(flashcardInfo, context);
    }
    return;
  }

  //ANCHOR On pressed functions of buttons
  void _dontKnowButtonOnPressed(BuildContext context) {
    _confirmInput(false, context);
    return;
  }

  void _confirmButtonOnPressed(BuildContext context) {
    bool allCorrect = true;
    bool isEmpty = false;
    for (int i = 0; i < flashcardInfo.kanji.length; i++) {
      if (_validationKeyList[i].currentState.validate()) {
        if (_inputControllerList[i].text.toString() !=
            flashcardInfo.kanji[i].furigana) {
          allCorrect = false;
        }
      } else {
        isEmpty = true;
      }
    }
    if (isEmpty) {
      return;
    }
    _confirmInput(allCorrect, context);
    return;
  }

  //ANCHOR Initialize answer input list
  List<TextEditingController> _inputControllerList = [];
  List<GlobalKey<FormState>> _validationKeyList = [];
  List<Widget> _answerInputList = [];

  void _initAnswerInputList() {
    _inputControllerList.clear();
    _validationKeyList.clear();
    _answerInputList.clear();
    for (int i = 0; i < flashcardInfo.kanji.length; i++) {
      _inputControllerList.add(TextEditingController());
      _validationKeyList.add(GlobalKey<FormState>());
      _answerInputList.add(
        Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
          child: KanjiInput(
            validationKey: _validationKeyList[i],
            inputController: _inputControllerList[i],
            displayedString: flashcardInfo.word[flashcardInfo.kanji[i].index],
          ),
        ),
      );
    }
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
    _initAnswerInputList();

    //ANCHOR Kanji short answer quiz
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          //ANCHOR Displayed question
          DisplayedQuestion(
            child: DisplayedWord(
              flashcardInfo: flashcardInfo,
              displayedWordSize: DisplayedWordSize.large(),
            ),
          ),

          //ANCHOR Answer input list
          ..._answerInputList,

          //ANCHOR Action buttons
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 25, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                //ANCHOR Don't know button
                ActionButton(
                  displayingString: DisplayedString.zhtw['dont know'] ?? '',
                  onPressed: _dontKnowButtonOnPressed,
                ),

                //ANCHOR Confirm button
                ActionButton(
                  displayingString: DisplayedString.zhtw['confirm'] ?? '',
                  onPressed: _confirmButtonOnPressed,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screens/repo/widget/input_field.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/quiz_manager.dart';
import 'package:provider/provider.dart';
import 'components/action_button.dart';
import 'components/displayed_question.dart';

// ignore: must_be_immutable
class WordShortAnswerQuiz extends StatelessWidget {
  //ANCHOR Public variables
  final FlashcardInfo flashcardInfo;

  //ANCHOR Constructor
  WordShortAnswerQuiz({this.flashcardInfo});

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
    if (_validationKey.currentState.validate()) {
      if (_inputController.text.toString() != flashcardInfo.word) {
        allCorrect = false;
      }
    } else {
      isEmpty = true;
    }

    if (isEmpty) {
      return;
    }
    _confirmInput(allCorrect, context);
    return;
  }

  //ANCHOR Initialize answer input
  TextEditingController _inputController = TextEditingController();
  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  Widget _answerInput;

  void _initAnswerInput() {
    _answerInput = Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
      child: InputField(
        inputController: _inputController,
        validationKey: _validationKey,
        displayedString: DisplayedString.zhtw['enter word'] ?? '',
      ),
    );
    return;
  }

  //ANCHOR Initialize variables
  QuizManager _quizManager;
  String _displayedDefinition;

  void _initVariables(BuildContext context) {
    _quizManager = Provider.of<QuizManager>(context, listen: false);
    _displayedDefinition = randomChoice(flashcardInfo.definition);
    return;
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Initialize
    _initVariables(context);
    _initAnswerInput();

    //ANCHOR Word short answer quiz
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          //ANCHOR Displayed question
          DisplayedQuestion(
            child: Text(
              _displayedDefinition,
              style: TextStyle(fontSize: 35, height: 1.2),
            ),
          ),

          //ANCHOR Answer input
          _answerInput,

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

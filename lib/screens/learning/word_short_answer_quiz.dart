import 'package:dart_random_choice/dart_random_choice.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:jp_flashcard/screens/learning/answer_correct_dialog.dart';
import 'package:jp_flashcard/screens/learning/answer_incorrect_dialog.dart';
import 'package:jp_flashcard/screens/repo/widget/input_field.dart';
import 'package:jp_flashcard/components/displayed_word.dart';
import 'package:jp_flashcard/screens/repo/widget/kanji_input.dart';

// ignore: must_be_immutable
class WordShortAnswerQuiz extends StatefulWidget {
  int repoId;
  FlashcardInfo flashcardInfo;
  bool hasFurigana;
  Function nextQuiz;
  WordShortAnswerQuiz(
      {this.flashcardInfo, this.repoId, this.hasFurigana, this.nextQuiz});
  @override
  _WordShortAnswerQuizState createState() => _WordShortAnswerQuizState();
}

class _WordShortAnswerQuizState extends State<WordShortAnswerQuiz> {
  String word;

  TextEditingController inputValue = TextEditingController();
  GlobalKey<FormState> validationKey = GlobalKey<FormState>();
  Widget answerInput;

  void answerCorrect() async {
    AnswerCorrectDialog answerCorrectDialog = AnswerCorrectDialog(
      flashcardInfo: widget.flashcardInfo,
      hasFurigana: widget.hasFurigana,
    );
    await answerCorrectDialog.dialog(context);

    widget.nextQuiz();
  }

  void answerIncorrect() async {
    AnswerIncorrectDialog answerIncorrectDialog = AnswerIncorrectDialog(
      incorrectFlashcardInfo: widget.flashcardInfo,
      correctFlashcardInfo: widget.flashcardInfo,
      hasFurigana: widget.hasFurigana,
    );
    await answerIncorrectDialog.dialog(context);
    widget.nextQuiz();
  }

  String displayedDefinition;
  void initAnswerInput() {
    displayedDefinition = randomChoice(widget.flashcardInfo.definition);
    answerInput = Padding(
      padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
      child: InputField(
        inputValue: inputValue,
        validationKey: validationKey,
        displayedString: '請輸入單字',
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    initAnswerInput();
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  displayedDefinition,
                  style: TextStyle(fontSize: 35, height: 1.2),
                ),
              ],
            ),
          ),
          answerInput,
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 25, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                ButtonTheme(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: FlatButton(
                    onPressed: () async {
                      answerIncorrect();
                    },
                    child: Text('不知道'),
                  ),
                ),
                ButtonTheme(
                  padding: EdgeInsets.fromLTRB(15, 0, 15, 0),
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  child: FlatButton(
                    onPressed: () {
                      bool allCorrect = true;
                      bool isEmpty = false;
                      if (validationKey.currentState.validate()) {
                        if (inputValue.text.toString() !=
                            widget.flashcardInfo.word) {
                          allCorrect = false;
                        }
                      } else {
                        isEmpty = true;
                      }

                      if (isEmpty) {
                        return;
                      }
                      if (allCorrect) {
                        answerCorrect();
                      } else {
                        answerIncorrect();
                      }
                    },
                    child: Text('確認'),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}

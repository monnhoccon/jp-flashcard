import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/screen/repo/widget/input_field.dart';
import 'package:jp_flashcard/utils/text_to_speech.dart';
import 'package:jp_flashcard/widget/displayed_word.dart';

// ignore: must_be_immutable
class DefinitionShortAnswerQuiz extends StatefulWidget {
  int repoId;
  FlashcardInfo flashcardInfo;
  DefinitionShortAnswerQuiz({this.flashcardInfo, this.repoId});
  @override
  _DefinitionShortAnswerQuizState createState() =>
      _DefinitionShortAnswerQuizState();
}

class _DefinitionShortAnswerQuizState extends State<DefinitionShortAnswerQuiz> {
  List<String> definition = [];

  List<bool> definitionIsAnswered = [];
  List<TextEditingController> inputTextList = [];
  List<GlobalKey<FormState>> validationKeyList = [];
  List<Widget> answerInputList = [];

  void answerCorrect() {
    print('correct');
  }

  void answerIncorrect() {
    print('incorrect');
  }

  void initAnswerInputList() {
    for (int i = 0; i < definition.length; i++) {
      definitionIsAnswered.add(false);
      inputTextList.add(TextEditingController());
      validationKeyList.add(GlobalKey<FormState>());
      answerInputList.add(
        Padding(
          padding: EdgeInsets.fromLTRB(25, 0, 25, 10),
          child: InputField(
            validationKey: validationKeyList[i],
            inputText: inputTextList[i],
            displayedString: '請輸入定義',
          ),
        ),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    definition = widget.flashcardInfo.definition;
    initAnswerInputList();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 20, 0, 25),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                DisplayedWord(
                  flashcardInfo: widget.flashcardInfo,
                  hasFurigana: true,
                  textFontSize: 35,
                  furiganaFontSize: 15,
                )
              ],
            ),
          ),
          ...answerInputList,
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 25, 20),
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
                      for (int i = 0; i < definition.length; i++) {
                        if (validationKeyList[i].currentState.validate()) {
                          bool correct = false;
                          for (int j = 0; j < definition.length; j++) {
                            if (definition[j] ==
                                    inputTextList[i].text.toString() &&
                                !definitionIsAnswered[j]) {
                              correct = true;
                              definitionIsAnswered[j] = true;
                              break;
                            }
                          }
                          if (!correct) {
                            allCorrect = false;
                            break;
                          }
                        } else {
                          isEmpty = true;
                        }
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

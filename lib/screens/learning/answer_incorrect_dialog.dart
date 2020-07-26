import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_settings.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/services/text_to_speech.dart';
import 'package:jp_flashcard/components/displayed_word.dart';

class AnswerIncorrectDialog {
  FlashcardInfo correctFlashcardInfo;
  FlashcardInfo incorrectFlashcardInfo;
  Map _displayedStringZHTW = {
    'answer incorrect': '答錯了！',
    'correct answer': '正確答案:',
    'your answer': '你的答案:',
    'continue': '繼續',
  };

  bool hasFurigana;

  AnswerIncorrectDialog(
      {this.correctFlashcardInfo,
      this.incorrectFlashcardInfo,
      this.hasFurigana});

  List<Widget> displayedCorrectDefinitionList = [];
  void initDisplayedCorrectDefinitionList() {
    displayedCorrectDefinitionList.clear();
    int i = 1;
    for (final definition in correctFlashcardInfo.definition) {
      displayedCorrectDefinitionList.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Text(
          correctFlashcardInfo.definition.length > 1
              ? '$i. ' + definition
              : definition,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
      i++;
    }
  }

  List<Widget> displayedCorrectWordTypeList = [];
  void initDisplayedCorrectWordTypeList() {
    displayedCorrectWordTypeList.clear();
    for (final wordType in correctFlashcardInfo.wordType) {
      displayedCorrectWordTypeList.add(Text(
          (wordType != correctFlashcardInfo.wordType.last)
              ? (wordType + ' · ')
              : (wordType)));
    }
  }

  List<Widget> displayedIncorrectDefinitionList = [];
  void initDisplayedIncorrectDefinitionList() {
    displayedIncorrectDefinitionList.clear();
    int i = 1;
    for (final definition in incorrectFlashcardInfo.definition) {
      displayedIncorrectDefinitionList.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Text(
          incorrectFlashcardInfo.definition.length > 1
              ? '$i. ' + definition
              : definition,
          style: TextStyle(
            fontSize: 20,
          ),
        ),
      ));
      i++;
    }
  }

  List<Widget> displayedIncorrectWordTypeList = [];
  void initDisplayedIncorrectWordTypeList() {
    displayedIncorrectWordTypeList.clear();
    for (final wordType in incorrectFlashcardInfo.wordType) {
      displayedIncorrectWordTypeList.add(Text(
          (wordType != incorrectFlashcardInfo.wordType.last)
              ? (wordType + ' · ')
              : (wordType)));
    }
  }

  dialog(BuildContext context) async {
    initDisplayedCorrectDefinitionList();
    initDisplayedCorrectWordTypeList();
    initDisplayedIncorrectDefinitionList();
    initDisplayedIncorrectWordTypeList();
    TextToSpeech.tts.speak('ja-JP', correctFlashcardInfo.word);
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: SingleChildScrollView(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 400,
                    color: Colors.red[600],
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      child: Text(
                        _displayedStringZHTW['answer incorrect'] ?? '',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 15, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                          child: Text(
                            _displayedStringZHTW['correct answer'] ?? '',
                            style: TextStyle(
                              color: Colors.red[600],
                              fontSize: 15,
                            ),
                          ),
                        ),
                        DisplayedWord(
                          flashcardInfo: correctFlashcardInfo,
                          displayedWordSettings: DisplayedWordSettings.large(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.center,
                          runSpacing: 5,
                          children: displayedCorrectWordTypeList,
                        ),
                        SizedBox(
                          height: 3,
                        ),
                        ...displayedCorrectDefinitionList,
                        //TODO Get incorrect flashcardinfo
                        /*
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 20, 0, 5),
                          child: Text(
                            _displayedStringZHTW['your answer'] ?? '',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 15,
                            ),
                          ),
                        ),
                        DisplayedWord(
                          flashcardInfo: correctFlashcardInfo,
                          furiganaFontSize: 12,
                          textFontSize: 28,
                          hasFurigana: hasFurigana,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.center,
                          runSpacing: 5,
                          children: displayedCorrectWordTypeList,
                        ),
                        ...displayedCorrectDefinitionList,
                        */
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            _displayedStringZHTW['continue'] ?? '',
                            style: TextStyle(
                                fontSize: 15,
                                color: Theme.of(context).primaryColor),
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              )),
            ),
          );
        });
  }
}

import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/services/text_to_speech.dart';
import 'package:jp_flashcard/components/displayed_word.dart';

class AnswerCorrectDialog {
  FlashcardInfo flashcardInfo;
  Map _displayedStringZHTW = {
    'answer correct': '答對了！',
    'continue': '繼續',
  };

  bool hasFurigana;

  AnswerCorrectDialog({this.flashcardInfo, this.hasFurigana});

  List<Widget> displayedDefinitionList = [];
  void initDisplayedDefinitionList() {
    displayedDefinitionList.clear();
    int i = 1;
    for (final definition in flashcardInfo.definition) {
      displayedDefinitionList.add(Padding(
        padding: EdgeInsets.fromLTRB(0, 3, 0, 3),
        child: Text(
          flashcardInfo.definition.length > 1
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

  List<Widget> displayedWordTypeList = [];
  void initDisplayedWordTypeList() {
    displayedWordTypeList.clear();
    for (final wordType in flashcardInfo.wordType) {
      displayedWordTypeList.add(Text((wordType != flashcardInfo.wordType.last)
          ? (wordType + ' · ')
          : (wordType)));
    }
  }

  dialog(BuildContext context) async {
    initDisplayedDefinitionList();
    initDisplayedWordTypeList();
    TextToSpeech.tts.speak('ja-JP', flashcardInfo.word);
    return showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Container(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Container(
                  width: 400,
                  color: Colors.green,
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                    child: Text(
                      _displayedStringZHTW['answer correct'] ?? '',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      DisplayedWord(
                        flashcardInfo: flashcardInfo,
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
                        children: displayedWordTypeList,
                      ),
                      SizedBox(
                        height: 8,
                      ),
                      ...displayedDefinitionList,
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
          );
        });
  }
}

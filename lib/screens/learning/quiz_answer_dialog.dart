import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/displayed_word_size.dart';
import 'package:jp_flashcard/models/displaying_settings.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/text_to_speech.dart';
import 'package:jp_flashcard/components/displayed_word.dart';
import 'package:provider/provider.dart';

class QuizAnswerDialog {
  //ANCHOR Public variables
  FlashcardInfo flashcardInfo;
  bool enableAnswerAudio = true;
  bool answerCorrect;

  //ANCHOR APIs
  static correct(FlashcardInfo flashcardInfo, bool enableAnswerAudio) {
    return QuizAnswerDialog(
      flashcardInfo: flashcardInfo,
      answerCorrect: true,
      enableAnswerAudio: enableAnswerAudio,
    );
  }

  static incorrect(FlashcardInfo flashcardInfo, bool enableAnswerAudio) {
    return QuizAnswerDialog(
      flashcardInfo: flashcardInfo,
      answerCorrect: false,
      enableAnswerAudio: enableAnswerAudio,
    );
  }

  //ANCHOR Constructor
  QuizAnswerDialog(
      {this.flashcardInfo, this.answerCorrect, this.enableAnswerAudio});

  //ANCHOR Initialize displayed definition list
  List<Widget> _displayedDefinitionList = [];
  void initDisplayedDefinitionList() {
    _displayedDefinitionList.clear();
    int i = 1;
    for (final definition in flashcardInfo.definition) {
      _displayedDefinitionList.add(Padding(
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

  //ANCHOR Initialize displayed word type list
  List<Widget> _displayedWordTypeList = [];
  void initDisplayedWordTypeList() {
    _displayedWordTypeList.clear();
    for (final wordType in flashcardInfo.wordType) {
      _displayedWordTypeList.add(Text((wordType != flashcardInfo.wordType.last)
          ? (wordType + ' · ')
          : (wordType)));
    }
  }

  //ANCHOR Title widgets
  Widget answerCorrectTitle() {
    return Container(
      width: 400,
      color: Colors.green,
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Text(
          DisplayedString.zhtw['answer correct'] ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Widget answerIncorrectTitle() {
    return Container(
      width: 400,
      color: Colors.red[600],
      child: Padding(
        padding: EdgeInsets.fromLTRB(20, 10, 20, 10),
        child: Text(
          DisplayedString.zhtw['answer incorrect'] ?? '',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
          ),
        ),
      ),
    );
  }

  Future<void> dialog(BuildContext context) async {
    //ANCHOR Initialize
    initDisplayedDefinitionList();
    initDisplayedWordTypeList();

    //ANCHOR Speak the word
    if (enableAnswerAudio) {
      TextToSpeech.tts.speak('ja-JP', flashcardInfo.word);
    }

    return showDialog(
        context: context,
        builder: (context) {
          //ANCHOR Providers
          return ChangeNotifierProvider<DisplayingSettings>(
            create: (context) {
              return DisplayingSettings();
            },

            //ANCHOR Answer correct dialog widget
            child: Dialog(
              child: Container(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  //ANCHOR Title
                  answerCorrect ? answerCorrectTitle() : answerIncorrectTitle(),

                  //ANCHOR Content
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        //ANCHOR Correct answer label
                        !answerCorrect
                            ? Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
                                child: Text(
                                  DisplayedString.zhtw['correct answer'] ?? '',
                                  style: TextStyle(
                                    color: Colors.red[600],
                                    fontSize: 15,
                                  ),
                                ),
                              )
                            : Container(),

                        //ANCHOR Displayed word
                        DisplayedWord(
                          flashcardInfo: flashcardInfo,
                          displayedWordSize: DisplayedWordSize.large(),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        //ANCHOR Displayed word type list
                        Wrap(
                          alignment: WrapAlignment.start,
                          runAlignment: WrapAlignment.center,
                          runSpacing: 5,
                          children: _displayedWordTypeList,
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        //ANCHOR Displayed definition list
                        ..._displayedDefinitionList,
                      ],
                    ),
                  ),

                  //ANCHOR Action buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      //ANCHOR Continue button
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 0, 0, 10),
                        child: FlatButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text(
                            DisplayedString.zhtw['continue'] ?? '',
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

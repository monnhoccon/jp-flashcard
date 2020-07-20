import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';

class AnswerCorrectDialog {
  FlashcardInfo flashcardInfo;
  Map _displayedStringZHTW = {'correct answer': '答對了！'};
  Function applySelection;

  AnswerCorrectDialog({this.flashcardInfo, this.applySelection});

  dialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text(_displayedStringZHTW['correct answer'] ?? ''),
            actions: <Widget>[
              FlatButton(
                onPressed: () {},
                child: Text('continue'),
              )
            ],
          );
        });
  }
}

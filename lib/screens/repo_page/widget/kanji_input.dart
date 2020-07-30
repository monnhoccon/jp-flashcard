import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/jp_letter.dart';

// ignore: must_be_immutable
class KanjiInput extends StatelessWidget {
  final validationKey;
  final String displayedString;
  final TextEditingController inputController;
  KanjiInput({this.inputController, this.validationKey, this.displayedString});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 5),
            child: Text(
              (displayedString ?? '') + ': ',
              style: TextStyle(fontSize: 18),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 15, 0),
            child: Container(
              width: 90,
              child: Form(
                key: validationKey,
                child: TextFormField(
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                  ),
                  decoration: InputDecoration(
                    alignLabelWithHint: true,
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    isDense: true,
                    contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
                    errorStyle: TextStyle(fontSize: 0, height: 0),
                  ),
                  controller: inputController,
                  validator: (input) {
                    if (input.isEmpty) {
                      return 'error';
                    }
                    for (int i = 0; i < input.length; i++) {
                      bool isKanji = true;
                      for (final letter in JPLetter.letterList) {
                        if (letter == input[i]) {
                          isKanji = false;
                          break;
                        }
                      }
                      if (isKanji) {
                        return 'error';
                      }
                    }
                    return null;
                  },
                  onChanged: (String text) {},
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

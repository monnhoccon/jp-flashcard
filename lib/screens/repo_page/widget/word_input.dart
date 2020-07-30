import 'package:flutter/material.dart';

// ignore: must_be_immutable
class WordInput extends StatelessWidget {
  final validationKey;
  final String displayedString;
  final TextEditingController value;
  WordInput({this.value, this.validationKey, this.displayedString, this.parseKanji});

  Function parseKanji;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5),
      child: Form(
        key: validationKey,
        child: TextFormField(
          style: TextStyle(
            fontSize: 18,
          ),
          decoration: InputDecoration(
            alignLabelWithHint: true,
            labelText: displayedString ?? '',
            labelStyle: TextStyle(
              height: 1,
            ),
            floatingLabelBehavior: FloatingLabelBehavior.always,
            isDense: true,
            contentPadding: EdgeInsets.fromLTRB(0, 5, 0, 5),
            errorStyle: TextStyle(fontSize: 0, height: 0),
          ),
          controller: value,
          validator: (value) {
            if (value.isEmpty) {
              return displayedString ?? '';
            }
            return null;
          },
          onChanged: (String text) {
            parseKanji(text);
          },
        ),
      ),
    );
  }
}

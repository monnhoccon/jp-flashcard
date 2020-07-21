import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/screens/repo/widget/add_word_type_dialog.dart';
import 'package:jp_flashcard/screens/repo/widget/input_field.dart';

class DefinitionInput extends StatefulWidget {
  final validationKey;
  final displayedString;

  final TextEditingController value;
  DefinitionInput({this.value, this.validationKey, this.displayedString});

  @override
  _DefinitionInputState createState() => _DefinitionInputState();
}

class _DefinitionInputState extends State<DefinitionInput> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InputField(
            validationKey: widget.validationKey,
            displayedString: widget.displayedString,
            inputValue: widget.value),
      ],
    );
  }
}

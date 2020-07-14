import 'package:flutter/material.dart';
import 'package:jp_flashcard/screen/main_menu/widgets/tag_box.dart';
import 'package:jp_flashcard/screen/repo/widget/add_word_type_dialog.dart';
import 'package:jp_flashcard/screen/repo/widget/input_field.dart';

class DefinitionInput extends StatefulWidget {
  final validationKey;

  final TextEditingController value;
  DefinitionInput({this.value, this.validationKey});

  @override
  _DefinitionInputState createState() => _DefinitionInputState();
}

class _DefinitionInputState extends State<DefinitionInput> {
  Map _displayedStringZHTW = {'add word type': '新增詞性'};
  List<TagBox> selectedWordTypeBoxList = [];
  void applySelection(List<TagBox> newSelectedWordTypeBoxList) {
    setState(() {
      selectedWordTypeBoxList = newSelectedWordTypeBoxList;
    });
  }

  Future<void> addWordTypeDialog(BuildContext context) async {
    AddWordTypeDialog addWordTypeDialog = AddWordTypeDialog(
        selectedWordTypeBoxList: selectedWordTypeBoxList,
        applySelection: applySelection);
    await addWordTypeDialog.dialog(context);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> wordTypeBoxList = List.from(selectedWordTypeBoxList);
    wordTypeBoxList.add((Container(
        height: 25,
        child: ButtonTheme(
          minWidth: 5.0,
          height: 28.0,
          child: FlatButton(
            onPressed: () async {
              await addWordTypeDialog(context);
              setState(() {});
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Icon(
                  Icons.add,
                  size: 15,
                  color: Colors.white,
                ),
                SizedBox(width: 2),
                Text(
                  _displayedStringZHTW['add word type'] ?? '',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18.0),
            ),
            color: Theme.of(context).primaryColor,
          ),
        ))));
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        InputField(
            validationKey: widget.validationKey,
            errorMessage: null,
            value: widget.value),
        Wrap(
          spacing: 5,
          children: wordTypeBoxList,
        )
      ],
    );
  }
}

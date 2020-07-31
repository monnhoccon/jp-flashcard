import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/components/word_type_box.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class AddWordTypeDialog {
  List<WordTypeBox> selectedWordTypeBoxList = [];
  List<WordTypeBox> wordTypeBoxList = [];
  Map _displayedStringZHTW = {'select word type': '選擇詞性'};
  Function applySelection;

  AddWordTypeDialog({this.selectedWordTypeBoxList, this.applySelection});

  Future<void> updateWordTypeBoxList() async {
    List<WordTypeBox> newWordTypeBoxList = [];
    await RepoDatabase.db.getWordTypeList().then((wordTypeList) {
      for (final wordType in wordTypeList) {
        bool selected = false;
        for (final selectedWordType in selectedWordTypeBoxList) {
          if (wordType['wordType'] == selectedWordType.displayedString) {
            selected = true;
            break;
          }
        }
        if (selected)
          newWordTypeBoxList.add(WordTypeBox(
            displayedString: wordType['wordType'],
            canSelect: true,
            selected: true,
          ));
        else
          newWordTypeBoxList.add(WordTypeBox(
            displayedString: wordType['wordType'],
            canSelect: true,
            selected: false,
          ));
      }
      wordTypeBoxList = newWordTypeBoxList;
    });
    return;
  }

  void updateSelectedWordTypeBoxList() {
    selectedWordTypeBoxList.clear();
    for (final wordTypeBox in wordTypeBoxList) {
      if (wordTypeBox.selected)
        selectedWordTypeBoxList.add(WordTypeBox(
          displayedString: wordTypeBox.displayedString,
          canSelect: false,
          selected: true,
        ));
    }
  }

  dialog(BuildContext context) async {
    await updateWordTypeBoxList();
    return showDialog(
      context: context,
      child: AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['select word type'] ?? '' ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        contentPadding: EdgeInsets.fromLTRB(24, 15, 24, 5),
        content: Container(
          width: 500,
          child: NoOverscrollGlow(
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    children: wordTypeBoxList,
                  ),
                ],
              ),
            ),
          ),
        ),

        //ANCHOR Action buttons
        actions: <Widget>[
          //ANCHOR Cancel button
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(
              DisplayedString.zhtw['cancel'] ?? '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),

          //ANCHOR Apply button
          FlatButton(
            onPressed: () {
              updateSelectedWordTypeBoxList();
              applySelection(selectedWordTypeBoxList);
              Navigator.of(context).pop();
            },
            child: Text(
              DisplayedString.zhtw['confirm'] ?? '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      ),
    );
  }
}

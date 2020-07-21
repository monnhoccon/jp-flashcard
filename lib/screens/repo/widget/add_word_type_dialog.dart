import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/services/database.dart';

class AddWordTypeDialog {
  List<TagBox> selectedWordTypeBoxList = [];
  List<TagBox> wordTypeBoxList = [];
  Map _displayedStringZHTW = {'select word type': '選擇詞性'};
  Function applySelection;

  AddWordTypeDialog({this.selectedWordTypeBoxList, this.applySelection});

  Future<void> updateWordTypeBoxList() async {
    List<TagBox> newWordTypeBoxList = [];
    await DBManager.db.getWordTypeList().then((wordTypeList) {
      for (final wordType in wordTypeList) {
        bool selected = false;
        for (final selectedWordType in selectedWordTypeBoxList) {
          if (wordType['wordType'] == selectedWordType.displayedString) {
            selected = true;
            break;
          }
        }
        if (selected)
          newWordTypeBoxList.add(TagBox(
            displayedString: wordType['wordType'],
            canSelect: true,
            selected: true,
          ));
        else
          newWordTypeBoxList.add(TagBox(
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
        selectedWordTypeBoxList.add(TagBox(
          displayedString: wordTypeBox.displayedString,
          canSelect: false,
          selected: true,
        ));
    }
  }

  //TODO Clear button
  dialog(BuildContext context) async {
    await updateWordTypeBoxList();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 13, 10, 0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _displayedStringZHTW['select word type'] ?? '',
                            style: Theme.of(context).textTheme.headline6,
                          ),
                          IconButton(
                            icon: Icon(Icons.clear),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 10, 24, 0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        runSpacing: 5,
                        children: wordTypeBoxList,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                          child: IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () async {
                              updateSelectedWordTypeBoxList();
                              applySelection(selectedWordTypeBoxList);
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          });
        });
  }
}

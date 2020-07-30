import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class TagFilterDialog {
  //ANCHOR Public variables
  List<String> filterTagList = [];

  //ANCHOR Private variables
  List<TagBox> _tagBoxList = [];

  //ANCHOR Constructor
  TagFilterDialog({this.filterTagList});

  static TagFilterDialog dialog(List<String> filterTagList) {
    return TagFilterDialog(filterTagList: filterTagList);
  }

  //Update Functions
  void _updateFilterTagList() {
    List<String> newSelectedTagList = [];
    for (final tagBox in _tagBoxList) {
      if (tagBox.selected) newSelectedTagList.add(tagBox.displayedString);
    }
    filterTagList = newSelectedTagList;
  }

  Future<dynamic> _initTagBoxList() async {
    List<TagBox> newTagBoxList = [];
    await RepoDatabase.db.getTagList().then((tags) {
      for (final tag in tags) {
        bool selected = false;
        for (final selectedTag in filterTagList) {
          if (tag['tag'] == selectedTag) {
            selected = true;
            break;
          }
        }

        if (selected)
          newTagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: true,
          ));
        else
          newTagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: false,
          ));
      }
      _tagBoxList = newTagBoxList;
      _tagBoxList
          .sort((a, b) => a.displayedString.compareTo(b.displayedString));
    });
    return;
  }

  //ANCHOR Apply selection
  void _applySelection(BuildContext context) {
    _updateFilterTagList();
    Navigator.of(context).pop(filterTagList);
  }

  //ANCHOR Show dialog
  Future<dynamic> show(BuildContext context) async {
    await _initTagBoxList();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            //ANCHOR Title
            title: Text(
              DisplayedString.zhtw['select tags'] ?? '',
              style: TextStyle(fontSize: 25, color: Colors.black),
            ),

            //ANCHOR Content
            contentPadding: EdgeInsets.fromLTRB(24, 15, 24, 5),
            content: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    children: _tagBoxList,
                  ),
                ],
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

              //ANCHOR Confirm button
              FlatButton(
                onPressed: () {
                  _applySelection(context);
                },
                child: Text(
                  DisplayedString.zhtw['confirm'] ?? '',
                  style: TextStyle(color: Theme.of(context).primaryColor),
                ),
              ),
            ],
          );
        });
      },
    );
  }
}

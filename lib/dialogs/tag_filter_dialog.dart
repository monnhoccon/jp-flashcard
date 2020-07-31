import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/managers/tag_manager.dart';
import 'package:provider/provider.dart';

class TagFilterDialog {
  //ANCHOR Public variables
  List<String> selectedTagList = [];

  //ANCHOR Constructor
  TagFilterDialog({this.selectedTagList});

  //ANCHOR API
  static TagFilterDialog dialog(List<String> selectedTagList) {
    return TagFilterDialog(selectedTagList: selectedTagList);
  }

  //ANCHOR Apply selection
  void _applySelection(BuildContext context, TagManager tagManager) {
    tagManager.applySelection();
    Navigator.of(context).pop(tagManager.selectedTagList);
  }

  //ANCHOR Dialog widget
  Widget _dialogWidget() {
    return Consumer<TagManager>(builder: (context, tagManager, child) {
      return AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['tag filter'] ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        contentPadding: EdgeInsets.fromLTRB(24, 15, 24, 5),
        content: Container(
          width: 500,
          child: NoOverscrollGlow(
            child: SingleChildScrollView(
              child: Wrap(
                direction: Axis.horizontal,
                spacing: 5,
                runSpacing: 5,
                children: tagManager.tagBoxList,
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
              _applySelection(context, tagManager);
            },
            child: Text(
              DisplayedString.zhtw['confirm'] ?? '',
              style: TextStyle(color: Theme.of(context).primaryColor),
            ),
          ),
        ],
      );
    });
  }

  //ANCHOR Show dialog
  Future<List<String>> show(BuildContext context) async {
    return showDialog(
      context: context,
      child: ChangeNotifierProvider<TagManager>(
        create: (context) {
          return TagManager(selectedTagList: selectedTagList);
        },
        child: _dialogWidget(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class DeleteTagDialog {
  //ANCHOR Public variables
  String tag;

  //ANCHOR Constructor
  DeleteTagDialog({this.tag});

  //ANCHOR API
  static DeleteTagDialog dialog(String tag) {
    return DeleteTagDialog(tag: tag);
  }

  //ANCHOR Confirm
  void confirm(BuildContext context) async {
    Navigator.of(context).pop();
    await RepoDatabase.db.deleteTagFromList(tag);
  }

  //ANCHOR Show dialog
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['delete tag title'] ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        content: Text(DisplayedString.zhtw['delete tag content'] ?? ''),
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),

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
              confirm(context);
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

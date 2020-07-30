import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class DeleteRepoDialog {
  //ANCHOR Public variables
  RepoInfo repoInfo;

  //ANCHOR Constructor
  DeleteRepoDialog({this.repoInfo});

  //ANCHOR API
  static DeleteRepoDialog dialog(RepoInfo repoInfo) {
    return DeleteRepoDialog(repoInfo: repoInfo);
  }

  //ANCHOR Confirm
  void confirm(BuildContext context) async {
    Navigator.of(context).pop();
    await repoInfo.deleteRepo();
  }

  //ANCHOR Show dialog
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['delete alert title'] ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        content: Text(DisplayedString.zhtw['delete alert content'] ?? ''),
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

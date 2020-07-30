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

  //ANCHOR Show dialog
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text(DisplayedString.zhtw['delete alert title'] ?? ''),
        content: Text(DisplayedString.zhtw['delete alert content'] ?? ''),
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(DisplayedString.zhtw['cancel'] ?? ''),
          ),
          FlatButton(
            onPressed: () async {
              Navigator.of(context).pop();
              await repoInfo.deleteRepo();
            },
            child: Text(DisplayedString.zhtw['confirm'] ?? ''),
          ),
        ],
      ),
    );
  }
}

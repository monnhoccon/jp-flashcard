import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/input_field.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class RenameRepoDialog {
  //ANCHOR Public variables
  RepoInfo repoInfo;

  //ANCHOR Constructor
  RenameRepoDialog({this.repoInfo});

  //ANCHOR API
  static RenameRepoDialog dialog(RepoInfo repoInfo) {
    return RenameRepoDialog(repoInfo: repoInfo);
  }

  //ANCHOR Confirm
  void confirm(BuildContext context) async {
    await repoInfo.updateRepoTitle(_inputController.text.toString());
    Navigator.of(context).pop();
  }

  //ANCHOR Private variables
  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();

  //ANCHOR Show dialog
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['rename'] ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        contentPadding: EdgeInsets.fromLTRB(24, 0, 24, 5),
        content: 
            InputField(
          displayedString: null,
          inputController: _inputController,
          validationKey: _validationKey,
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

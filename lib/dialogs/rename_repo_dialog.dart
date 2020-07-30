import 'package:flutter/material.dart';
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

  //ANCHOR Private variables
  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();

  //ANCHOR Show dialog
  Future<void> show(BuildContext context) {
    return showDialog(
      context: context,
      child: AlertDialog(
        title: Text(DisplayedString.zhtw['rename']),
        content: Form(
          key: _validationKey,
          child: ConstrainedBox(
            constraints: BoxConstraints(),
            child: TextFormField(
              decoration: InputDecoration(
                errorStyle: TextStyle(fontSize: 0, height: 0),
                contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(18),
                  borderSide:
                      BorderSide(width: 1.5, color: Colors.lightBlue[800]),
                ),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(18),
                    borderSide:
                        BorderSide(width: 1.5, color: Colors.lightBlue[800])),
              ),
              controller: _inputController,
              validator: (value) {
                if (value.isEmpty) {
                  return '';
                }
                return null;
              },
            ),
          ),
        ),
        contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 0),
        actions: <Widget>[
          FlatButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text(DisplayedString.zhtw['cancel'] ?? ''),
          ),
          FlatButton(
            onPressed: () {
              if (_validationKey.currentState.validate()) {
                repoInfo
                    .updateRepoTitle(_inputController.text.toString())
                    .then((value) {
                  Navigator.of(context).pop();
                });
              }
            },
            child: Text(DisplayedString.zhtw['confirm'] ?? ''),
          )
        ],
      ),
    );
  }
}

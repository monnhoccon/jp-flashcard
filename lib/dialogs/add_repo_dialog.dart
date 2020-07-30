import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/components/tag_box_button.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/components/input_field.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'add_tag_dialog.dart';

class AddRepoDialog {
  //ANCHOR Constructor
  AddRepoDialog();

  //ANCHOR API
  static AddRepoDialog dialog() {
    return AddRepoDialog();
  }

  //ANCHOR Apply selection
  void _applySelection(BuildContext context) async {
    if (_validationKey.currentState.validate()) {
      List<String> tagList =
          _selectedTagBoxList.map((e) => e.displayedString).toList();

      RepoInfo repoInfo = RepoInfo(
        title: _inputController.text.toString(),
        tagList: tagList,
      );
      await repoInfo.addToDatabse();
      Navigator.of(context).pop();
    }
  }

  //ANCHOR Add tag
  void _addTag(BuildContext context, Function setState) {
    AddTagDialog.dialog(_selectedTagBoxList).show(context).then((value) {
      setState(() {
        if (value != null) {
          _selectedTagBoxList = value;
        }
      });
    });
  }

  //ANCHOR Private variables
  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();
  List<TagBox> _selectedTagBoxList = [];
  
  //ANCHOR Show dialog
  Future<void> show(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            //ANCHOR Title
            title: Text(
              DisplayedString.zhtw['create repo'] ?? '',
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
                      //ANCHOR Title input field
                      InputField(
                        displayedString: DisplayedString.zhtw['title'],
                        inputController: _inputController,
                        validationKey: _validationKey,
                      ),

                      //ANCHOR Tag box list
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 8),
                        child: Text(
                          DisplayedString.zhtw['tags'] ?? '',
                          style: TextStyle(
                            color: Theme.of(context).primaryColor,
                            fontSize: 15,
                            height: 1,
                          ),
                        ),
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        runSpacing: 5,
                        children: <Widget>[
                          //ANCHOR Selected tag box list
                          ..._selectedTagBoxList,

                          //ANCHOR Add tag button
                          TagBoxButton(onPressed: () {
                            _addTag(context, setState);
                          }),
                        ],
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

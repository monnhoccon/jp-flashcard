import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/managers/tag_manager.dart';
import 'package:provider/provider.dart';

class AddTagDialog {
  //ANCHOR Public variables
  List<String> selectedTagList = [];

  //ANCHOR Constructor
  AddTagDialog({this.selectedTagList});

  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();

  //ANCHOR API
  static AddTagDialog dialog(List<String> selectedTagList) {
    return AddTagDialog(selectedTagList: selectedTagList);
  }

  //ANCHOR Tag duplicated
  Future<bool> _tagDuplicated(String tag) async {
    return await RepoDatabase.db.tagDuplicated(tag);
  }

  //ANCHOR Apply selection
  void _applySelection(BuildContext context, TagManager tagManager) {
    tagManager.applySelection();
    Navigator.of(context).pop(tagManager.selectedTagList);
  }

  //ANCHOR Initialize variables
  double _dynamicHeight = 38;
  Color _hintColor;
  bool _isError = false;

  void _initVariables(BuildContext context) {
    _hintColor = Theme.of(context).hintColor;
  }

  //ANCHOR Dialog widget
  Widget _dialogWidget() {
    return Consumer<TagManager>(builder: (context, tagManager, child) {
      return AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['add tags'] ?? '',
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
                  //ANCHOR Displayed tag box list

                  Wrap(
                    direction: Axis.horizontal,
                    spacing: 5,
                    runSpacing: 5,
                    children: tagManager.tagBoxList,
                  ),

                  //ANCHOR Add tag textfield and button
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                          height: _dynamicHeight,
                          child: Form(
                            key: _validationKey,
                            child: TextFormField(
                              onFieldSubmitted: (String value) {
                                String newTag =
                                    _inputController.text.toString();

                                if (_validationKey.currentState.validate()) {
                                  _tagDuplicated(newTag)
                                      .then((duplicated) async {
                                    if (duplicated) {
                                      _isError = true;
                                      _dynamicHeight = 60;
                                      _hintColor = Theme.of(context).errorColor;
                                    } else {
                                      _dynamicHeight = 38;
                                      _hintColor =
                                          Theme.of(context).primaryColor;
                                      _isError = false;

                                      //Validation pass

                                      tagManager.createTag(newTag);
                                      _inputController.clear();
                                    }
                                  });
                                } else {
                                  _isError = true;
                                  _dynamicHeight = 60;
                                  _hintColor = Theme.of(context).errorColor;
                                }
                                tagManager.refresh();
                              },
                              decoration: InputDecoration(
                                  contentPadding:
                                      EdgeInsets.fromLTRB(15, 0, 10, 0),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide(
                                      width: 1.5,
                                      color: Colors.lightBlue[800],
                                    ),
                                  ),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(18),
                                    borderSide: BorderSide(
                                        width: 0, color: Colors.lightBlue[800]),
                                  ),
                                  hintText:
                                      DisplayedString.zhtw['new tag'] ?? '',
                                  hintStyle: TextStyle(color: _hintColor),
                                  errorText: _isError
                                      ? (DisplayedString.zhtw['duplicated'] ??
                                          '')
                                      : null),
                              controller: _inputController,
                              validator: (tag) {
                                if (tag.isEmpty) {
                                  return DisplayedString.zhtw['tag error'] ??
                                      '';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                      ),
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
    _initVariables(context);
    return showDialog(
      context: context,
      child: ChangeNotifierProvider<TagManager>(
        create: (context) {
          print(selectedTagList);
          return TagManager(selectedTagList: selectedTagList);
        },
        child: _dialogWidget(),
      ),
    );
  }
}

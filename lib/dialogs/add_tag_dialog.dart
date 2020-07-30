import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class AddTagDialog {
  //ANCHOR Variables
  List<TagBox> selectedTagBoxList = [];
  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();

  //ANCHOR Constructor
  AddTagDialog({this.selectedTagBoxList});

  //ANCHOR API
  static AddTagDialog dialog(List<TagBox> selectedTagBoxList) {
    return AddTagDialog(selectedTagBoxList: selectedTagBoxList);
  }

  //ANCHOR Tag duplicated
  Future<bool> _tagDuplicated(String tag) async {
    return await RepoDatabase.db.tagDuplicated(tag);
  }

  //ANCHOR Apply selection
  void _applySelection(BuildContext context) {
    selectedTagBoxList.clear();
    for (final tagBox in _displayedTagBoxList) {
      if (tagBox.selected) {
        tagBox.canSelect = false;
        selectedTagBoxList.add(tagBox);
      }
    }
    Navigator.of(context).pop(selectedTagBoxList);
  }

  //ANCHOR Initialize variables
  double _dynamicHeight = 38;
  Color _hintColor;
  bool _isError = false;
  void _initVariables(BuildContext context) {
    _hintColor = Theme.of(context).hintColor;
  }

  //ANCHOR Displayed tag box list
  List<TagBox> _displayedTagBoxList = [];

  Future<bool> _initTagBoxList() async {
    _displayedTagBoxList.clear();
    await RepoDatabase.db.getTagList().then((tagList) {
      for (final tag in tagList) {
        bool selected = false;
        for (final selectedTag in selectedTagBoxList) {
          if (tag['tag'] == selectedTag.displayedString) {
            selected = true;
            break;
          }
        }
        if (selected) {
          _displayedTagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: true,
          ));
        } else {
          _displayedTagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: false,
          ));
        }
      }
      _displayedTagBoxList
          .sort((a, b) => a.displayedString.compareTo(b.displayedString));
    });
    return true;
  }

  void _updateTagBoxList(String newTag) {
    _displayedTagBoxList.add(TagBox(
      displayedString: newTag,
      canSelect: true,
      selected: true,
    ));
    _displayedTagBoxList
        .sort((a, b) => a.displayedString.compareTo(b.displayedString));
    return;
  }

  //ANCHOR Dialog widget
  Widget _dialogWidget() {
    return StatefulBuilder(builder: (context, setState) {
      return AlertDialog(
        //ANCHOR Title
        title: Text(
          DisplayedString.zhtw['add tags'] ?? '',
          style: TextStyle(fontSize: 25, color: Colors.black),
        ),

        //ANCHOR Content
        contentPadding: EdgeInsets.fromLTRB(24, 15, 24, 5),
        content: NoOverscrollGlow(
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
                  children: _displayedTagBoxList,
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
                              String newTag = _inputController.text.toString();

                              if (_validationKey.currentState.validate()) {
                                _tagDuplicated(newTag).then((duplicated) async {
                                  if (duplicated) {
                                    setState(() {
                                      _isError = true;
                                      _dynamicHeight = 60;
                                      _hintColor = Theme.of(context).errorColor;
                                    });
                                  } else {
                                    setState(() {
                                      _dynamicHeight = 38;
                                      _hintColor =
                                          Theme.of(context).primaryColor;
                                      _isError = false;
                                    });

                                    //Validation pass
                                    await RepoDatabase.db
                                        .insertTagIntoList(newTag);

                                    setState(() {
                                      _updateTagBoxList(newTag);
                                      _inputController.clear();
                                    });
                                  }
                                });
                              } else {
                                setState(() {
                                  _isError = true;
                                  _dynamicHeight = 60;
                                  _hintColor = Theme.of(context).errorColor;
                                });
                              }
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
                                hintText: DisplayedString.zhtw['new tag'] ?? '',
                                hintStyle: TextStyle(color: _hintColor),
                                errorText: _isError
                                    ? (DisplayedString.zhtw['duplicated'] ?? '')
                                    : null),
                            controller: _inputController,
                            validator: (tag) {
                              if (tag.isEmpty) {
                                return DisplayedString.zhtw['tag error'] ?? '';
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
  }

  //ANCHOR Show dialog function
  Future<List<TagBox>> show(BuildContext context) async {
    _initVariables(context);
    return showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return FutureBuilder<void>(
          future: _initTagBoxList(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return _dialogWidget();
            } else {
              return Container();
            }
          },
        );
      },
    );
  }
}

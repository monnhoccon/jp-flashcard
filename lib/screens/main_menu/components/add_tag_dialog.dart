import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/services/repo_manager.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class AddTagDialog {
  //ANCHOR Variables
  List<TagBox> selectedTagBoxList = [];
  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _inputValue = TextEditingController();
  double _dynamicHeight = 38;
  Color _hintColor;
  bool _isError = false;

  AddTagDialog({this.selectedTagBoxList});

  void _initVariables(BuildContext context) {
    _hintColor = Theme.of(context).hintColor;
  }

  //ANCHOR Functions
  Future<bool> _tagDuplicated(String tag) async {
    return await RepoManager.db.duplicated(tag);
  }

  void _applySelection() {
    selectedTagBoxList.clear();
    for (final tagBox in _displayedTagBoxList) {
      if (tagBox.selected) {
        tagBox.canSelect = false;
        selectedTagBoxList.add(tagBox);
      }
    }
  }

  //ANCHOR Displayed tag box list
  List<TagBox> _displayedTagBoxList = [];

  Future<bool> _initTagBoxList() async {
    _displayedTagBoxList.clear();
    await RepoManager.db.getTagList().then((tagList) {
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
      return Dialog(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              //ANCHOR Cancel button
              Padding(
                padding: EdgeInsets.fromLTRB(24, 13, 10, 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      DisplayedString.zhtw['add tags'] ?? '',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    IconButton(
                      icon: Icon(Icons.clear),
                      onPressed: () {
                        Navigator.of(context).pop(null);
                      },
                    ),
                  ],
                ),
              ),
              //ANCHOR Displayed tag box list
              Padding(
                padding: EdgeInsets.fromLTRB(24, 10, 24, 0),
                child: Wrap(
                  direction: Axis.horizontal,
                  spacing: 5,
                  runSpacing: 5,
                  children: _displayedTagBoxList,
                ),
              ),
              //ANCHOR Add tag textfield and button
              Padding(
                padding: EdgeInsets.fromLTRB(24, 0, 10, 10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 5, 0, 0),
                        height: _dynamicHeight,
                        child: Form(
                            key: _validationKey,
                            child: TextFormField(
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
                                      width: 0,
                                      color: Colors.lightBlue[800],
                                    ),
                                  ),
                                  hintText:
                                      DisplayedString.zhtw['new tag'] ?? '',
                                  hintStyle: TextStyle(color: _hintColor),
                                  errorText: _isError
                                      ? (DisplayedString.zhtw['duplicated'] ??
                                          '')
                                      : null),
                              controller: _inputValue,
                              validator: (tag) {
                                if (tag.isEmpty) {
                                  return DisplayedString.zhtw['tag error'] ??
                                      '';
                                }
                                return null;
                              },
                            )),
                      ),
                    ),
                    ButtonTheme(
                      minWidth: 10,
                      child: FlatButton(
                          child: Text(DisplayedString.zhtw['add'] ?? ''),
                          onPressed: () {
                            String newTag = _inputValue.text.toString();

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
                                    _hintColor = Theme.of(context).primaryColor;
                                    _isError = false;
                                  });

                                  //Validation pass
                                  await RepoManager.db.insertTagIntoList(newTag);

                                  setState(() {
                                    _updateTagBoxList(newTag);
                                    _inputValue.clear();
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
                          }),
                    ),
                  ],
                ),
              ),
              //ANCHOR Apply button
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                    child: IconButton(
                      icon: Icon(Icons.check),
                      onPressed: () {
                        _applySelection();
                        Navigator.of(context).pop(selectedTagBoxList);
                      },
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  //ANCHOR Show dialog function
  Future<List<TagBox>> dialog(BuildContext context) async {
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
                  return CircularProgressIndicator();
                }
              });
        });
  }
}

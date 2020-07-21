import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'add_tag_dialog.dart';
import 'title_input.dart';

class AddRepoDialog {
  //ANCHOR Variables
  List<TagBox> selectedTagBoxList = [];
  List<Widget> displayedTagBoxList = [];
  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _titleInputValue = TextEditingController();

  //ANCHOR Show dialog function
  Future<RepoInfo> dialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            displayedTagBoxList = List.from(selectedTagBoxList);
            return AlertDialog(
              titlePadding: EdgeInsets.fromLTRB(24, 13, 10, 0),
              contentPadding: EdgeInsets.fromLTRB(24, 13, 24, 0),
              //ANCHOR Cancel Button
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(DisplayedString.zhtw['create repo'] ?? ''),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              content: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return false;
                },
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      //ANCHOR Title input field
                      TitleInput(
                          textController: _titleInputValue,
                          displayedString: DisplayedString.zhtw['title'] ?? '',
                          formKey: _validationKey,
                          errorMessage:
                              DisplayedString.zhtw['title error'] ?? ''),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text(DisplayedString.zhtw['tags'] ?? '',
                            style: Theme.of(context).textTheme.overline),
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        runSpacing: 5,
                        children: <Widget>[
                          ...displayedTagBoxList,
                          //ANCHOR Add tag button
                          Container(
                              padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
                              height: 25,
                              child: ButtonTheme(
                                minWidth: 5.0,
                                height: 28.0,
                                child: FlatButton(
                                  onPressed: () async {
                                    AddTagDialog addTagDialog = AddTagDialog(
                                        selectedTagBoxList: selectedTagBoxList);
                                    await addTagDialog
                                        .dialog(context)
                                        .then((value) {
                                      setState(() {
                                        if (value != null) {
                                          selectedTagBoxList = value;
                                        }
                                      });
                                    });
                                  },
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Icon(
                                        Icons.add,
                                        size: 15,
                                        color: Colors.white,
                                      ),
                                      SizedBox(width: 2),
                                      Text(
                                        DisplayedString.zhtw['add tags'] ?? '',
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                  color: Theme.of(context).primaryColor,
                                ),
                              ))
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              //ANCHOR Apply button
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    if (_validationKey.currentState.validate()) {
                      List<String> tagList = [];
                      for (final selectedTagBox in selectedTagBoxList) {
                        tagList.add(selectedTagBox.displayedString);
                      }
                      RepoInfo repoInfo = RepoInfo(
                        title: _titleInputValue.text.toString(),
                        tagList: tagList,
                      );
                      Navigator.of(context).pop(repoInfo);
                    }
                  },
                ),
              ],
            );
          });
        });
  }
}

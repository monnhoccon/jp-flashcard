import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/components/tag_box_list.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';

class AddTagDialog {
  RepoInfo repoInfo;
  AddTagDialog({this.repoInfo});
  static AddTagDialog dialog(RepoInfo repoInfo) {
    return AddTagDialog(repoInfo: repoInfo);
  }

  List<TagBox> selectedTagBoxList = [];

  void initSelectedTagBoxList() {
    selectedTagBoxList.clear();
    for (final tag in repoInfo.tagList) {
      selectedTagBoxList.add(
        TagBox(
          displayedString: tag,
          canSelect: true,
          selected: true,
        ),
      );
    }
  }

  GlobalKey<FormState> _validationKey = GlobalKey<FormState>();
  TextEditingController _inputController = TextEditingController();

  show(BuildContext context) async {
    TextEditingController textController = TextEditingController();
    double dynamicHeight = 38;
    Color hintColor = Theme.of(context).hintColor;
    bool isError = false;
    initSelectedTagBoxList();
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return ChangeNotifierProvider<TagBoxList>(
              create: (context) {
                return TagBoxList(selectedTagBoxList: selectedTagBoxList);
              },
              child: Dialog(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 13, 10, 0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              DisplayedString.zhtw['edit tags'] ?? '',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ],
                        ),
                      ),

                      //ANCHOR Tag box list
                      Consumer<TagBoxList>(
                        builder: (context, tagBoxList, child) {
                          return Padding(
                            padding: EdgeInsets.fromLTRB(24, 10, 24, 0),
                            child: Wrap(
                              direction: Axis.horizontal,
                              spacing: 5,
                              runSpacing: 5,
                              children: tagBoxList.tagBoxList,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: EdgeInsets.fromLTRB(24, 0, 10, 10),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                width: 150,
                                padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
                                height: dynamicHeight,
                                child: Form(
                                    key: _validationKey,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                          contentPadding:
                                              EdgeInsets.fromLTRB(15, 0, 10, 0),
                                          enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: BorderSide(
                                                width: 1.5,
                                                color: Colors.lightBlue[800]),
                                          ),
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(18),
                                            borderSide: BorderSide(
                                                width: 0,
                                                color: Colors.lightBlue[800]),
                                          ),
                                          hintText:
                                              DisplayedString.zhtw['new tag'] ??
                                                  '',
                                          hintStyle:
                                              TextStyle(color: hintColor),
                                          errorText: isError
                                              ? DisplayedString
                                                      .zhtw['duplicated'] ??
                                                  ''
                                              : null),
                                      controller: textController,
                                      validator: (tag) {
                                        if (tag.isEmpty) {
                                          return DisplayedString
                                                  .zhtw['tag error'] ??
                                              '';
                                        }
                                        return null;
                                      },
                                    )),
                              ),
                            ),
                            /*
                          ButtonTheme(
                            minWidth: 10,
                            child: FlatButton(
                                child: Text(DisplayedString.zhtw['add'] ?? ''),
                                onPressed: () async {
                                  String tag = textController.text.toString();
                                  if (_validationKey.currentState.validate()) {
                                    tagDuplicated(tag).then((duplicated) async {
                                      if (duplicated) {
                                        setState(() {
                                          isError = true;
                                          dynamicHeight = 60;
                                          hintColor =
                                              Theme.of(context).errorColor;
                                        });
                                      } else {
                                        setState(() {
                                          dynamicHeight = 38;
                                          hintColor =
                                              Theme.of(context).primaryColor;
                                          isError = false;
                                        });

                                        //Validation pass
                                        await RepoManager.db
                                            .insertTagIntoList(tag);
                                        await updateTagBoxList(tag, false);
                                        setState(() {
                                          textController.clear();
                                        });
                                      }
                                    });
                                  } else {
                                    setState(() {
                                      isError = true;
                                      dynamicHeight = 60;
                                      hintColor = Theme.of(context).errorColor;
                                    });
                                  }
                                }),
                          ),
                          */
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                            child: IconButton(
                              icon: Icon(Icons.check),
                              onPressed: () async {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }
}

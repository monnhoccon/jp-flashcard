import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/repo/repo_page.dart';
import 'package:jp_flashcard/screens/main_menu/components/tag_box.dart';
import 'package:jp_flashcard/services/database.dart';

// ignore: must_be_immutable
class RepoCard extends StatefulWidget {
  RepoInfo info;
  final bool displayTag;
  RepoCard({this.info, this.displayTag});

  @override
  _RepoCardState createState() => _RepoCardState();
}

class _RepoCardState extends State<RepoCard> {
  final Map _displayedStringZHTW = {
    'memorized': '已學習',
    'rename': '重新命名',
    'delete': '刪除',
    'edit repo': '編輯學習集',
    'edit tags': '編輯標籤',
    'delete alert title': '刪除學習集',
    'delete alert content': '你確定要刪除此學習集嗎？',
    'cancel': '取消',
    'confirm': '確認',
    'tag error': '請輸入標籤',
    'add': '新增',
    'new tag': '新標籤',
    'duplicated': '已有此標籤',
    'title error': '請輸入標題',
  };

  void deleteAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(_displayedStringZHTW['delete alert title']),
          content: Text(_displayedStringZHTW['delete alert content']),
          contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(_displayedStringZHTW['cancel'])),
            FlatButton(
                onPressed: () {
                  DBManager.db.deleteRepo(widget.info.repoId);
                  DBManager.db
                      .deleteTagFromRepo(widget.info.repoId, null, true);
                  Navigator.of(context).pop();
                },
                child: Text(_displayedStringZHTW['confirm']))
          ],
        ));
  }

  void renameDialog(BuildContext context) {
    TextEditingController textController = TextEditingController();
    showDialog(
        context: context,
        child: AlertDialog(
          title: Text(_displayedStringZHTW['rename']),
          content: Form(
              key: renameFormKey,
              child: ConstrainedBox(
                constraints: BoxConstraints(),
                child: TextFormField(
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(15, 0, 10, 0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(18),
                      borderSide:
                          BorderSide(width: 1.5, color: Colors.lightBlue[800]),
                    ),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                        borderSide: BorderSide(
                            width: 1.5, color: Colors.lightBlue[800])),
                  ),
                  controller: textController,
                  validator: (value) {
                    if (value.isEmpty) {
                      return _displayedStringZHTW['title error'] ?? '';
                    }
                    return null;
                  },
                ),
              )),
          contentPadding: EdgeInsets.fromLTRB(24, 20, 24, 10),
          actions: <Widget>[
            FlatButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(_displayedStringZHTW['cancel'])),
            FlatButton(
                onPressed: () {
                  if (renameFormKey.currentState.validate()) {
                    DBManager.db.renameRepo(
                        textController.text.toString(), widget.info.repoId);
                    Navigator.of(context).pop();
                  }
                },
                child: Text(_displayedStringZHTW['confirm']))
          ],
        ));
  }

  final List<Widget> tagBoxListOfRepo = [];
  final List<Widget> displayedTagList = [];

  @override
  Widget build(BuildContext context) {
    tagBoxListOfRepo.clear();
    for (final tag in widget.info.tags) {
      tagBoxListOfRepo.add(Transform.scale(
          scale: 0.9,
          child: Container(
              height: 31,
              child: TagBox(
                  displayedString: tag, canSelect: false, selected: true))));
    }
    displayedTagList.clear();
    displayedTagList.add(Padding(
      padding: EdgeInsets.fromLTRB(5, 0, 5, 0),
      child: Icon(
        Icons.label_outline,
        size: 15,
      ),
    ));
    for (final tag in widget.info.tags) {
      displayedTagList.add(Text(
        tag == widget.info.tags.last ? tag + ' ' : tag + ', ',
        style: TextStyle(fontSize: 12),
      ));
    }
    return Container(
      padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
      child: Card(
        child: InkWell(
          splashColor: Colors.blue.withAlpha(5),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return Repo(
                repoInfo: widget.info,
              );
            }));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 12, 0, 0),
                              child: Text(
                                widget.info.title ?? '',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(15, 8, 0, 12),
                              child: Text(
                                '${widget.info.numMemorized}/${widget.info.numTotal} 已學習',
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ]),
                    ),
                    PopupMenuButton<String>(
                      tooltip: _displayedStringZHTW['edit repo'] ?? '',
                      onSelected: (String result) {
                        if (result == 'delete') {
                          deleteAlertDialog(context);
                        } else if (result == 'rename') {
                          renameDialog(context);
                        } else if (result == 'edit tags') {
                          addTagDialog(context);
                        }
                      },
                      itemBuilder: (BuildContext context) =>
                          <PopupMenuEntry<String>>[
                        PopupMenuItem<String>(
                          value: 'rename',
                          child: Text(_displayedStringZHTW['rename']),
                        ),
                        PopupMenuItem<String>(
                          value: 'edit tags',
                          child: Text(_displayedStringZHTW['edit tags']),
                        ),
                        PopupMenuItem<String>(
                          value: 'delete',
                          child: Text(_displayedStringZHTW['delete']),
                        ),
                      ],
                    )
                  ]),
              widget.info.tags.isNotEmpty && widget.displayTag
                  ? Divider(
                      color: Colors.black,
                      height: 0,
                      thickness: 0.3,
                      indent: 15,
                      endIndent: 15,
                    )
                  : Container(),
              widget.info.tags.isNotEmpty && widget.displayTag
                  ? Container(
                      width: 200,
                      padding: EdgeInsets.fromLTRB(10, 7, 20, 10),
                      child: Wrap(
                        spacing: 0,
                        children: displayedTagList,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  List<TagBox> tagBoxList = [];

  updateTagBoxList(String newTag, bool init) async {
    List<TagBox> newTagBoxList = [];
    await DBManager.db.getTagList().then((tags) {
      for (final tag in tags) {
        bool selected = false;
        for (final selectedTag in widget.info.tags) {
          if (tag['tag'] == selectedTag) {
            selected = true;
            break;
          }
        }
        if (!init) {
          for (final tagBox in tagBoxList) {
            if (tag['tag'] == tagBox.displayedString && tagBox.selected) {
              selected = true;
              break;
            }
          }
        }
        if (tag['tag'] == newTag) selected = true;

        if (selected)
          newTagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: true,
          ));
        else
          newTagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: false,
          ));
      }
      setState(() {
        tagBoxList = newTagBoxList;
        tagBoxList
            .sort((a, b) => a.displayedString.compareTo(b.displayedString));
      });
    });
    return;
  }

  final addTagFormKey = GlobalKey<FormState>();

  final renameFormKey = GlobalKey<FormState>();

  updateTagBoxListOfRepo() {
    for (final tagBox in tagBoxList) {
      if (tagBox.selected) {
        DBManager.db
            .insertTagIntoRepo(widget.info.repoId, tagBox.displayedString);
      } else {
        DBManager.db.deleteTagFromRepo(
            widget.info.repoId, tagBox.displayedString, false);
      }
    }
  }

  addTagDialog(BuildContext context) async {
    TextEditingController textController = TextEditingController();
    double dynamicHeight = 38;
    Color hintColor = Theme.of(context).hintColor;
    bool isError = false;
    await updateTagBoxList(null, true);
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            return Dialog(
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
                            _displayedStringZHTW['edit tags'] ?? '',
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
                    Padding(
                      padding: EdgeInsets.fromLTRB(24, 10, 24, 0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        runSpacing: 5,
                        children: tagBoxList,
                      ),
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
                                  key: addTagFormKey,
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
                                            _displayedStringZHTW['new tag'] ??
                                                '',
                                        hintStyle: TextStyle(color: hintColor),
                                        errorText: isError
                                            ? _displayedStringZHTW[
                                                    'duplicated'] ??
                                                ''
                                            : null),
                                    controller: textController,
                                    validator: (tag) {
                                      if (tag.isEmpty) {
                                        return _displayedStringZHTW[
                                                'tag error'] ??
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
                                child: Text(_displayedStringZHTW['add'] ?? ''),
                                onPressed: () async {
                                  String tag = textController.text.toString();
                                  if (addTagFormKey.currentState.validate()) {
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
                                        await DBManager.db
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
                              updateTagBoxListOfRepo();
                              Navigator.of(context).pop();
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
        });
  }

  Future<bool> tagDuplicated(String tag) async {
    return await DBManager.db.duplicated(tag);
  }
}

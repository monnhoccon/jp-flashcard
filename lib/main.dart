import 'package:flutter/material.dart';
import 'package:jp_flashcard/screen/repo/add_flashcard.dart';
import 'package:jp_flashcard/screen/repo_menu/repo_menu.dart';
import 'package:jp_flashcard/screen/profile/profile.dart';
import 'dart:async';
import 'package:jp_flashcard/utils/database.dart';
import 'package:jp_flashcard/screen/main_menu/widgets/my_text_field.dart';
import 'package:jp_flashcard/screen/main_menu/widgets/tag_box.dart';
import 'package:jp_flashcard/utils/theme.dart';

void main() {
  runApp(MaterialApp(home: MyApp(), theme: MyTheme.theme));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;

  List<Widget> _bodySelected() => <Widget>[
        RepoMenu(),
        Profile(),
      ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  final formKey = GlobalKey<FormState>();
  final formKey2 = GlobalKey<FormState>();

  final Map displayedStringZHTW = {
    'create repo': '創建新學習集',
    'add tags': '新增標籤',
    'repos': '學習集',
    'title': '標題',
    'tags': '標籤',
    'description': '描述()',
    'title error': '請輸入標題',
    'tag error': '請輸入標籤',
    'add': '新增',
    'new tag': '新標籤',
    'duplicated': '已有此標籤'
  };
  Future<bool> tagDuplicated(String tag) async {
    return await DBManager.db.duplicated(tag);
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
                            displayedStringZHTW['add tags'],
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
                        runSpacing: 0,
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
                                  key: formKey2,
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
                                            displayedStringZHTW['new tag'],
                                        hintStyle: TextStyle(color: hintColor),
                                        errorText: isError
                                            ? displayedStringZHTW['duplicated']
                                            : null),
                                    controller: textController,
                                    validator: (tag) {
                                      if (tag.isEmpty) {
                                        return displayedStringZHTW['tag error'];
                                      }
                                      return null;
                                    },
                                  )),
                            ),
                          ),
                          ButtonTheme(
                            minWidth: 10,
                            child: FlatButton(
                                child: Text(displayedStringZHTW['add']),
                                onPressed: () async {
                                  String tag = textController.text.toString();

                                  if (formKey2.currentState.validate()) {
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
                              await updateSelectedTagBoxList();
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

  updateSelectedTagBoxList() {
    List<TagBox> newSelectedTagBoxList = [];
    for (final tagBox in tagBoxList) {
      if (tagBox.selected) {
        tagBox.canSelect = false;
        newSelectedTagBoxList.add(tagBox);
      }
    }
    setState(() {
      selectedTagBoxList = newSelectedTagBoxList;
    });
  }

  updateTagBoxList(String newTag, bool init) async {
    List<TagBox> newTagBoxList = [];
    await DBManager.db.getTagList().then((tags) {
      for (final tag in tags) {
        bool selected = false;
        for (final selectedTag in selectedTagBoxList) {
          if (tag['tag'] == selectedTag.displayedString) {
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

  List<TagBox> tagBoxList = [];

  List<TagBox> selectedTagBoxList = [];

  Future<String> createRepoDialog(BuildContext context) async {
    selectedTagBoxList.clear();
    TextEditingController textController = TextEditingController();
    return showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, setState) {
            List<Widget> newTagBoxList = List.from(selectedTagBoxList);
            newTagBoxList.add(Container(
                padding: EdgeInsets.fromLTRB(0, 9, 0, 0),
                height: 35,
                child: ButtonTheme(
                  minWidth: 5.0,
                  height: 28.0,
                  child: FlatButton(
                    onPressed: () async {
                      await addTagDialog(context);
                      setState(() {});
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
                          '新增標籤',
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    color: Theme.of(context).primaryColor,
                  ),
                )));
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(displayedStringZHTW['create repo']),
                  IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
              titlePadding: EdgeInsets.fromLTRB(24, 13, 10, 0),
              contentPadding: EdgeInsets.fromLTRB(24, 13, 24, 0),
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
                      MyTextField(
                          textController: textController,
                          displayedString: displayedStringZHTW['title'],
                          formKey: formKey,
                          errorMessage: displayedStringZHTW['title error']),
                      Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 5),
                        child: Text(displayedStringZHTW['tags'],
                            style: Theme.of(context).textTheme.overline),
                      ),
                      Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        runSpacing: 0,
                        children: newTagBoxList,
                      ),
                    ],
                  ),
                ),
              ),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.check),
                  onPressed: () {
                    if (formKey.currentState.validate()) {
                      Navigator.of(context).pop(textController.text.toString());
                    }
                  },
                ),
              ],
            );
          });
        });
  }

  void insertRepoDatabase(String newRepoTitle) async {
    List<String> tagList = [];
    for (final selectedTagBox in selectedTagBoxList) {
      tagList.add(selectedTagBox.displayedString);
    }
    await DBManager.db.insertRepo(newRepoTitle, tagList);
  }

  FloatingActionButton createRepoButton(context) {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          createRepoDialog(context).then((newRepoTitle) {
            setState(() {
              if (newRepoTitle != null) insertRepoDatabase(newRepoTitle);
            });
          });
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: _bodySelected().elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.amber[800],
          onTap: _onItemTapped,
        ),
        floatingActionButton: createRepoButton(context));
  }
}

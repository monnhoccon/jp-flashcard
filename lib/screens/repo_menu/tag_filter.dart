import 'package:flutter/material.dart';
import 'package:jp_flashcard/screens/main_menu/components/tag_box.dart';
import 'package:jp_flashcard/services/database.dart';

class TagFilter {
  //Variables
  List<String> filterTagList = [];
  List<TagBox> _tagBoxList = [];
  final Map _displayedStringZHTW = {
    'select tags': '選擇標籤',
    'clear': '清除',
    'select all': '全選'
  };

  //Constructor
  TagFilter({this.filterTagList});

  //Update Functions
  void _updateFilterTagList() {
    List<String> newSelectedTagList = [];
    for (final tagBox in _tagBoxList) {
      if (tagBox.selected) newSelectedTagList.add(tagBox.displayedString);
    }
    filterTagList = newSelectedTagList;
  }

  void _selectAll() {
    List<TagBox> newTagBoxList = [];
    for (final tagBox in _tagBoxList) {
      newTagBoxList.add(TagBox(
          displayedString: tagBox.displayedString,
          canSelect: true,
          selected: true));
      tagBox.selected = true;
    }
    _tagBoxList = newTagBoxList;
    _tagBoxList.sort((a, b) => a.displayedString.compareTo(b.displayedString));
  }

  void _clearAll() {
    List<TagBox> newTagBoxList = [];
    for (final tagBox in _tagBoxList) {
      newTagBoxList.add(TagBox(
          displayedString: tagBox.displayedString,
          canSelect: true,
          selected: false));
    }
    _tagBoxList = newTagBoxList;
    _tagBoxList.sort((a, b) => a.displayedString.compareTo(b.displayedString));
  }

  Future<void> _updateTagBoxList() async {
    List<TagBox> newTagBoxList = [];
    await DBManager.db.getTagList().then((tags) {
      for (final tag in tags) {
        bool selected = false;
        for (final selectedTag in filterTagList) {
          if (tag['tag'] == selectedTag) {
            selected = true;
            break;
          }
        }

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
      _tagBoxList = newTagBoxList;
      _tagBoxList
          .sort((a, b) => a.displayedString.compareTo(b.displayedString));
    });
    return;
  }

  //Dialog
  tagFilterDialog(BuildContext context) async {
    await _updateTagBoxList();
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
                            _displayedStringZHTW['select tags'] ?? '',
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
                      padding: EdgeInsets.fromLTRB(24, 0, 24, 0),
                      child: Wrap(
                        direction: Axis.horizontal,
                        spacing: 5,
                        runSpacing: 5,
                        children: _tagBoxList,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                          child: FlatButton(
                            child: Text(_displayedStringZHTW['clear'] ?? ''),
                            onPressed: () {
                              setState(() {
                                _clearAll();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                          child: FlatButton(
                            child:
                                Text(_displayedStringZHTW['select all'] ?? ''),
                            onPressed: () {
                              setState(() {
                                _selectAll();
                              });
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.fromLTRB(0, 0, 10, 10),
                          child: IconButton(
                            icon: Icon(Icons.check),
                            onPressed: () {
                              _updateFilterTagList();
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
}

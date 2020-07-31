import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';

class TagManager extends ChangeNotifier {
  TagManager({this.selectedTagList}) {
    _init = true;
    refresh();
  }

  bool _init;
  List<TagBox> tagBoxList = [];
  List<String> selectedTagList;

  Future<void> refresh() async {
    if (!_init) {
      applySelection();
    }
    _init = false;
    tagBoxList.clear();
    await RepoDatabase.db.getTagList().then((tagList) {
      for (final tag in tagList) {
        bool selected = false;
        for (final selectedTag in selectedTagList) {
          if (tag['tag'] == selectedTag) {
            selected = true;
            break;
          }
        }
        if (selected) {
          tagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: true,
          ));
        } else {
          tagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: false,
          ));
        }
      }
      tagBoxList.sort((a, b) => a.displayedString.compareTo(b.displayedString));
    });

    notifyListeners();
    return;
  }

  void createTag(String tag) async {
    await RepoDatabase.db.insertTagIntoList(tag);
    tagBoxList.add(TagBox(
      displayedString: tag,
      canSelect: true,
      selected: true,
    ));
    refresh();
    return;
  }

  void applySelection() {
    selectedTagList.clear();
    for (final tagBox in tagBoxList) {
      if (tagBox.selected) {
        selectedTagList.add(tagBox.displayedString);
      }
    }
    return;
  }
}

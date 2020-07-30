import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/services/repo_manager.dart';

class TagBoxList extends ChangeNotifier {
  List<TagBox> tagBoxList = [];
  List<TagBox> selectedTagBoxList = [];

  void refresh() async {
    tagBoxList.clear();
    await RepoManager.db.getTagList().then((tagList) {
      for (final tag in tagList) {
        bool selected = false;
        for (final selectedTag in selectedTagBoxList) {
          if (tag['tag'] == selectedTag) {
            selected = true;
            break;
          }
        }
        if (selected)
          tagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: true,
          ));
        else
          tagBoxList.add(TagBox(
            displayedString: tag['tag'],
            canSelect: true,
            selected: false,
          ));
      }
      tagBoxList.sort((a, b) => a.displayedString.compareTo(b.displayedString));
    });
    notifyListeners();
    return;
  }

  TagBoxList({this.selectedTagBoxList}) {
    refresh();
  }
}

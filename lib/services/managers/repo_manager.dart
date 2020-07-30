import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/repo_menu_page/components/repo_card.dart';
import 'package:jp_flashcard/screens/repo_menu_page/tag_filter.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortBy { increasing, decreasing }

class RepoManager with ChangeNotifier {
  List<RepoInfo> _repoInfoList = [];
  List<RepoCard> repoCardList = [];

  List<String> _filterTagList = [];

  var persistData;
  SortBy sortBy;
  Future<void> getPersistData() async {
    persistData = await SharedPreferences.getInstance();

    String sortByString = persistData.getString('sortBy') ?? 'increasing';
    if (sortByString == 'increasing') {
      sortBy = SortBy.increasing;
    } else if (sortByString == 'decreasing') {
      sortBy = SortBy.decreasing;
    }
    _filterTagList = persistData.getStringList('filterTagList') ?? [];
  }

  Future<void> refresh() async {
    _repoInfoList.clear();
    repoCardList.clear();
    await getPersistData();
    await RepoDatabase.db.getRepoInfoList().then(
      (resultRepoInfoList) async {
        _repoInfoList = resultRepoInfoList;
      },
    );
    for (final repoInfo in _repoInfoList) {
      bool filterPassed = false;
      if (_filterTagList.isEmpty) {
        filterPassed = true;
      }

      //Validate tag list
      for (final filterTag in _filterTagList) {
        if (repoInfo.tagList.contains(filterTag)) {
          filterPassed = true;
          break;
        }
      }

      if (!filterPassed) {
        continue;
      }

      repoCardList.add(new RepoCard(
        repoInfo: repoInfo,
      ));

      if (sortBy == SortBy.increasing) {
        repoCardList.sort((a, b) {
          return a.repoInfo.title.compareTo(b.repoInfo.title);
        });
      } else if (sortBy == SortBy.decreasing) {
        repoCardList.sort(
          (a, b) {
            return b.repoInfo.title.compareTo(a.repoInfo.title);
          },
        );
      }
    }
    notifyListeners();
    return;
  }

  void setSortBy(String result) {
    if (result == 'increasing') {
      sortBy = SortBy.increasing;
      persistData.setString('sortBy', 'increasing');
    } else if (result == 'decreasing') {
      sortBy = SortBy.decreasing;
      persistData.setString('sortBy', 'decreasing');
    }
    refresh();
    return;
  }

  void setFilterTagList(BuildContext context) {
    TagFilter.dialog(_filterTagList).show(context).then((value) {
      if (value != null) {
        persistData.setStringList('filterTagList', value);
      }
      refresh();
    });
    return;
  }

  RepoManager() {
    refresh();
    return;
  }
}

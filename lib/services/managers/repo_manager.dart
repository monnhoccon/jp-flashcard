import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/repo_menu_page/components/repo_card.dart';
import 'package:jp_flashcard/dialogs/tag_filter_dialog.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortBy { increasing, decreasing, original }

class RepoManager with ChangeNotifier {
  List<RepoInfo> _repoInfoList = [];
  List<RepoCard> repoCardList = [];

  List<String> _filterTagList = [];

  var persistData;
  SortBy sortBy;
  Future<void> getPersistData() async {
    persistData = await SharedPreferences.getInstance();

    String sortByString = persistData.getString('sortBy') ?? 'original';
    if (sortByString == 'increasing') {
      sortBy = SortBy.increasing;
    } else if (sortByString == 'decreasing') {
      sortBy = SortBy.decreasing;
    } else if (sortByString == 'original') {
      sortBy = SortBy.original;
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
    persistData.setString('sortBy', result);
    refresh();
    return;
  }

  void setFilterTagList(BuildContext context) {
    TagFilterDialog.dialog(_filterTagList).show(context).then((value) {
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

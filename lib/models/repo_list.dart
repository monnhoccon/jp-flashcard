import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/repo_menu/repo_card.dart';
import 'package:jp_flashcard/screens/repo_menu/sort_filter.dart';
import 'package:jp_flashcard/services/repo_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepoList with ChangeNotifier {
  List<RepoInfo> repoInfoList = [];
  List<RepoCard> repoCardList = [];

  List<String> filterTagList = [];

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
    filterTagList = persistData.getStringList('filterTagList') ?? [];
  }

  Future<void> refresh() async {
    repoInfoList.clear();
    repoCardList.clear();
    await getPersistData();
    await RepoManager.db.getRepoInfoList().then(
      (resultRepoInfoList) async {
        repoInfoList = resultRepoInfoList;
      },
    );
    for (final repoInfo in repoInfoList) {
      bool filterPassed = false;
      if (filterTagList.isEmpty) {
        filterPassed = true;
      }

      //Validate tag list
      for (final tag in repoInfo.tagList) {
        if (filterTagList.contains(tag)) {
          filterPassed = false;
          break;
        }
      }

      if (!filterPassed) {
        continue;
      }

      repoCardList.add(RepoCard(
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

  RepoList() {
    refresh();
    return;
  }
}

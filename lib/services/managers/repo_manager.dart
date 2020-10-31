import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/flashcard_info.dart';
import 'package:jp_flashcard/models/kanj_info.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/repo_menu/repo_card.dart';
import 'package:jp_flashcard/dialogs/tag_filter_dialog.dart';
import 'package:jp_flashcard/services/databases/flashcard_database.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';
import 'package:jp_flashcard/services/managers/flashcard_manager.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum SortBy { increasing, decreasing, original }

class RepoManager with ChangeNotifier {
  List<RepoInfo> _repoInfoList = [];
  List<RepoCard> repoCardList = [];

  List<String> _filterTagList = [];

  var persistData;
  SortBy sortBy;
  bool _init = false;
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
    _init = persistData.getBool('init') ?? true;
  }

  Future<void> refresh() async {
    _repoInfoList.clear();
    repoCardList.clear();
    await getPersistData();
    await RepoDatabase.db.getRepoInfoList().then(
      (resultRepoInfoList) {
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

  void createRepoByFile(BuildContext context, String path) async {
    if (!_init) {
      return;
    }
    String jsonString = await DefaultAssetBundle.of(context).loadString(path);
    final repo = jsonDecode(jsonString);
    RepoInfo repoInfo = RepoInfo(
      title: repo['title'],
      tagList: repo['tagList'].cast<String>(),
    );
    int repoId = await RepoDatabase.db.insertRepo(repoInfo);
    for (final tag in repoInfo.tagList) {
      await RepoDatabase.db.insertTagIntoList(tag);
    }
    for (final flashcard in repo['flashcardList']) {
      List<KanjiInfo> kanjiInfoList = [];
      for (final kanjiInfo in flashcard['kanji']) {
        kanjiInfoList.add(KanjiInfo(
          length: kanjiInfo['length'],
          furigana: kanjiInfo['furigana'],
          index: kanjiInfo['index'],
        ));
      }
      FlashcardInfo flashcardInfo = FlashcardInfo(
        word: flashcard['word'],
        definition: flashcard['definition'].cast<String>(),
        wordType: flashcard['wordType'].cast<String>(),
        favorite: flashcard['favorite'] == 1 ? true : false,
        progress: flashcard['progress'],
        completeDate: flashcard['completeDate'],
        kanji: kanjiInfoList,
      );
      await FlashcardDatabase.db(repoId).insertFlashcard(flashcardInfo);
    }

    await FlashcardManager.refreshRepoDatabase(repoId);
    _init = false;
    persistData.setBool('init', false);
    refresh();
  }

  RepoManager() {
    refresh();
    return;
  }
}

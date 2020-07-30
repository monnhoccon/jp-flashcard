import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/repo_manager.dart';

class RepoInfo extends ChangeNotifier {
  String title;
  List<String> tagList;
  int numTotal;
  int numMemorized;
  int repoId;

  RepoInfo({
    this.title,
    this.tagList,
    this.numTotal,
    this.numMemorized,
    this.repoId,
  });

  Future<void> updateTagList(List<String> newTagList) async {
    await RepoManager.db.updateTagListOfRepo(repoId, newTagList);
    tagList = newTagList;
    notifyListeners();
    return;
  }

  Future<void> updateRepoTitle(String newTitle) async {
    await RepoManager.db.updateRepoTitle(newTitle, repoId);
    title = newTitle;
    notifyListeners();
    return;
  }

  Future<void> deleteRepo() async {
    await RepoManager.db.deleteRepo(repoId);
    return;
  }

  void refresh(RepoInfo repoInfo) {
    repoId = repoInfo.repoId;
    title = repoInfo.title;
    tagList = repoInfo.tagList;
    numTotal = repoInfo.numTotal;
    numMemorized = repoInfo.numMemorized;
    //notifyListeners();
  }
}

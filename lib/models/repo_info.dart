import 'package:flutter/material.dart';
import 'package:jp_flashcard/services/databases/repo_database.dart';

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

  RepoInfo.from(RepoInfo repoInfo) {
    repoId = repoInfo.repoId;
    title = repoInfo.title;
    tagList = repoInfo.tagList;
    numTotal = repoInfo.numTotal;
    numMemorized = repoInfo.numMemorized;
  }

  Future<void> addToDatabse() async {
    await RepoDatabase.db.insertRepo(this);
    return;
  }

  Future<void> refresh() async {
    RepoInfo newRepoInfo = await RepoDatabase.db.getRepoInfo(repoId);
    repoId = newRepoInfo.repoId;
    title = newRepoInfo.title;
    tagList = newRepoInfo.tagList;
    numTotal = newRepoInfo.numTotal;
    numMemorized = newRepoInfo.numMemorized;
    notifyListeners();
    return;
  }

  Future<void> updateTagList(List<String> newTagList) async {
    await RepoDatabase.db.updateTagListOfRepo(repoId, newTagList);
    tagList = newTagList;
    return;
  }

  Future<void> updateRepoTitle(String newTitle) async {
    await RepoDatabase.db.updateRepoTitle(repoId, newTitle);
    title = newTitle;

    return;
  }

  Future<void> deleteRepo() async {
    await RepoDatabase.db.deleteRepo(repoId);
    return;
  }
}

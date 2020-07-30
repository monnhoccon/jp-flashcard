import 'package:jp_flashcard/services/databases/repo_database.dart';

class RepoInfo {
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

  Future<void> addToDatabse() async {
    await RepoDatabase.db.insertRepo(this);
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

  void refresh(RepoInfo repoInfo) {
    repoId = repoInfo.repoId;
    title = repoInfo.title;
    tagList = repoInfo.tagList;
    numTotal = repoInfo.numTotal;
    numMemorized = repoInfo.numMemorized;
    //notifyListeners();
  }
}

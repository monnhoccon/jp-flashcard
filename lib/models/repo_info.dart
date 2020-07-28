import 'package:flutter/material.dart';

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

  RepoInfo.fromRepoInfo(RepoInfo repoInfo) {
    repoId = repoInfo.repoId;
    title = repoInfo.title;
    tagList = repoInfo.tagList;
    numTotal = repoInfo.numTotal;
    numMemorized = repoInfo.numMemorized;
  }
}

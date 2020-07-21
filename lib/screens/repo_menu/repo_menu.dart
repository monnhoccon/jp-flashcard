import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/repo_menu/repo_card.dart';
import 'package:jp_flashcard/screens/repo_menu/sort_filter.dart';
import 'package:jp_flashcard/screens/repo_menu/tag_filter.dart';
import 'package:jp_flashcard/services/database.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RepoMenu extends StatefulWidget {
  @override
  _RepoMenuState createState() => _RepoMenuState();
}

class _RepoMenuState extends State<RepoMenu> {
  final Map _displayedStringZHTW = {
    'repository': '學習集',
    'sort by': '排序依據',
    'increasing': '標題: A 到 Z',
    'decreasing': '標題: Z 到 A',
  };

  final TextStyle h2TextStyle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  List<RepoCard> repoList = [];

  Future<dynamic> getTitle() async {
    final data = await DBManager.db.getRepoList();
    return data;
  }

  Future<dynamic> getTags(int repoId) async {
    final data = await DBManager.db.getTagsOfRepo(repoId);
    return data;
  }

  bool displayTag = true;
  SortBy sortBy = SortBy.increasing;
  Icon displayTagButtonIcon = Icon(Icons.label_outline);

  void updateRepoList() async {
    List<RepoCard> newRepoList = [];
    await getTitle().then((repoInfo) async {
      for (final info in repoInfo) {
        bool filterPassed = false;
        if (filterTagList.isEmpty) {
          filterPassed = true;
        }

        List<String> newTags = [];
        await getTags(info['repoId']).then((tags) {
          for (final tag in tags) {
            newTags.add(tag['tag']);
            for (final filterTag in filterTagList) {
              if (filterTag == tag['tag'] || filterPassed) {
                filterPassed = true;
                break;
              }
            }
          }
          newTags.sort();
        });

        if (!filterPassed) continue;
        RepoInfo newRepoInfo = RepoInfo(
            title: info['title'],
            repoId: info['repoId'],
            numMemorized: info['numMemorized'],
            numTotal: info['numTotal'],
            tags: newTags);
        newRepoList.add(RepoCard(info: newRepoInfo, displayTag: displayTag));

        if (sortBy == SortBy.increasing) {
          newRepoList.sort((a, b) {
            return a.info.title.compareTo(b.info.title);
          });
        } else if (sortBy == SortBy.decreasing) {
          newRepoList.sort((a, b) {
            return b.info.title.compareTo(a.info.title);
          });
        }
      }
    });
    setState(() {
      repoList = newRepoList;
    });
  }

  List<String> filterTagList = [];

  var persistData;
  void getPersistData() async {
    persistData = await SharedPreferences.getInstance();
    setState(() {
      displayTag = persistData.getBool('displayTag') ?? false;
      if (displayTag) displayTagButtonIcon = Icon(Icons.label);

      String sortByString = persistData.getString('sortBy') ?? 'increasing';
      if (sortByString == 'increasing') {
        sortBy = SortBy.increasing;
      } else if (sortByString == 'decreasing') {
        sortBy = SortBy.decreasing;
      }
      filterTagList = persistData.getStringList('filterTagList') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    updateRepoList();
    getPersistData();
  }

  @override
  Widget build(BuildContext context) {
    updateRepoList();
    return Container(
        child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppBar(
          title: Text(_displayedStringZHTW['repository']),
          actions: <Widget>[
            IconButton(
                icon: displayTagButtonIcon,
                onPressed: () {
                  setState(() {
                    if (!displayTag) {
                      displayTagButtonIcon = Icon(Icons.label);

                      displayTag = true;
                    } else {
                      displayTagButtonIcon = Icon(Icons.label_outline);
                      displayTag = false;
                    }
                    persistData.setBool('displayTag', displayTag);
                  });
                }),
            IconButton(
                icon: Icon(Icons.filter_list),
                onPressed: () async {
                  TagFilter tagFilter = TagFilter(filterTagList: filterTagList);
                  await tagFilter.tagFilterDialog(context);
                  setState(() {
                    filterTagList = tagFilter.filterTagList;
                    persistData.setStringList('filterTagList', filterTagList);
                  });
                }),
            PopupMenuButton<String>(
              offset: Offset(0, 250),
              tooltip: _displayedStringZHTW['sort by'] ?? '',
              icon: Icon(Icons.sort),
              onSelected: (String result) {
                setState(() {
                  if (result == 'increasing') {
                    sortBy = SortBy.increasing;
                    persistData.setString('sortBy', 'increasing');
                  } else if (result == 'decreasing') {
                    sortBy = SortBy.decreasing;
                    persistData.setString('sortBy', 'decreasing');
                  }
                });
              },
              itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
                PopupMenuItem<String>(
                  value: 'title',
                  enabled: false,
                  child: Text(
                    _displayedStringZHTW['sort by'] ?? '',
                    style: TextStyle(
                        color: Colors.black, fontWeight: FontWeight.bold),
                  ),
                ),
                PopupMenuDivider(
                  height: 0,
                ),
                PopupMenuItem<String>(
                  value: 'increasing',
                  child: Text(
                    _displayedStringZHTW['increasing'] ?? '',
                    style: TextStyle(
                        color: sortBy == SortBy.increasing
                            ? Theme.of(context).primaryColor
                            : Colors.black),
                  ),
                ),
                PopupMenuItem<String>(
                  value: 'decreasing',
                  child: Text(_displayedStringZHTW['decreasing'] ?? '',
                      style: TextStyle(
                          color: sortBy == SortBy.decreasing
                              ? Theme.of(context).primaryColor
                              : Colors.black)),
                ),
              ],
            )
          ],
        ),
        Expanded(
            child: NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (OverscrollIndicatorNotification overscroll) {
                  overscroll.disallowGlow();
                  return false;
                },
                child: ListView.builder(
                    itemCount: repoList.length,
                    itemBuilder: (context, index) {
                      return repoList[index];
                    }))),
      ],
    ));
  }
}

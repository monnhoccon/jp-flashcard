import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/models/repo_displaying_settings.dart';
import 'package:jp_flashcard/models/repo_list.dart';
import 'package:jp_flashcard/screens/repo_menu/sort_filter.dart';
import 'package:provider/provider.dart';

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

  SortBy sortBy = SortBy.increasing;

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RepoDisplayingSettings>(
          create: (context) {
            return RepoDisplayingSettings();
          },
        ),
        ChangeNotifierProvider<RepoList>(
          create: (context) {
            print('hi');
            return RepoList();
          },
        ),
      ],
      child: Builder(
        builder: (context) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              AppBar(
                title: Text(_displayedStringZHTW['repository']),
                actions: <Widget>[
                  Consumer<RepoDisplayingSettings>(
                    builder: (context, repoDisplayingSettings, child) {
                      return IconButton(
                        icon: repoDisplayingSettings.displayTag
                            ? Icon(Icons.label)
                            : Icon(Icons.label_outline),
                        onPressed: () {
                          repoDisplayingSettings.toggleTag();
                        },
                      );
                    },
                  ),
                  /*
                  IconButton(
                    icon: Icon(Icons.filter_list),
                    onPressed: () async {
                      TagFilter tagFilter =
                          TagFilter(filterTagList: filterTagList);
                      await tagFilter.tagFilterDialog(context);
                      setState(
                        () {
                          filterTagList = tagFilter.filterTagList;
                          persistData.setStringList(
                              'filterTagList', filterTagList);
                        },
                      );
                    },
                  ),
                  */
                  /*
                  PopupMenuButton<String>(
                    offset: Offset(0, 250),
                    tooltip: _displayedStringZHTW['sort by'] ?? '',
                    icon: Icon(Icons.sort),
                    onSelected: (String result) {
                      setState(
                        () {
                          if (result == 'increasing') {
                            sortBy = SortBy.increasing;
                            persistData.setString('sortBy', 'increasing');
                          } else if (result == 'decreasing') {
                            sortBy = SortBy.decreasing;
                            persistData.setString('sortBy', 'decreasing');
                          }
                        },
                      );
                    },
                    itemBuilder: (BuildContext context) =>
                        <PopupMenuEntry<String>>[
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
                  */
                  Consumer<RepoList>(builder: (context, repoList, child) {
                    return FlatButton(
                      onPressed: () {
                        repoList.refresh();
                      },
                      child: Icon(Icons.ac_unit),
                    );
                  }),
                ],
              ),
              Consumer<RepoList>(builder: (context, repoList, child) {
                return Expanded(
                  child: NoOverscrollGlow(
                    child: ListView.builder(
                      itemCount: repoList.repoCardList.length,
                      itemBuilder: (context, index) {
                        return repoList.repoCardList[index];
                      },
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}

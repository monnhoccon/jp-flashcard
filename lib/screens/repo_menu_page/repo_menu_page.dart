import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/no_overscroll_glow.dart';
import 'package:jp_flashcard/models/repo_displaying_settings.dart';
import 'package:jp_flashcard/dialogs/add_repo_dialog.dart';
import 'package:jp_flashcard/services/managers/repo_manager.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RepoMenuPage extends StatelessWidget {
  //ANCHOR Constructor
  RepoMenuPage();

  void _addRepo(BuildContext context, RepoManager repoManager) {
    AddRepoDialog.dialog().show(context).then((_) {
      repoManager.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    //ANCHOR Providers
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<RepoDisplayingSettings>(
          create: (context) {
            return RepoDisplayingSettings();
          },
        ),
        ChangeNotifierProvider<RepoManager>(
          create: (context) {
            return RepoManager();
          },
        ),
      ],

      //ANCHOR Repo menu page
      child: Consumer<RepoManager>(
        builder: (context, repoManager, child) {
          return Scaffold(
            //ANCHOR App bar
            appBar: AppBar(
              title: Text(DisplayedString.zhtw['repository'] ?? ''),
              actions: <Widget>[
                //ANCHOR Displayed tag toggle butoon
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

                //ANCHOR Tag filter button
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: () {
                    repoManager.setFilterTagList(context);
                  },
                ),

                //ANCHOR Sort by button
                PopupMenuButton<String>(
                  offset: Offset(0, 250),
                  tooltip: DisplayedString.zhtw['sort by'] ?? '',
                  icon: Icon(Icons.sort),
                  onSelected: (String result) {
                    repoManager.setSortBy(result);
                  },
                  itemBuilder: (BuildContext context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'title',
                        enabled: false,
                        child: Text(
                          DisplayedString.zhtw['sort by'] ?? '',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      PopupMenuDivider(
                        height: 0,
                      ),
                      PopupMenuItem<String>(
                        value: 'increasing',
                        child: Text(
                          DisplayedString.zhtw['increasing'] ?? '',
                          style: TextStyle(
                            color: repoManager.sortBy == SortBy.increasing
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'decreasing',
                        child: Text(
                          DisplayedString.zhtw['decreasing'] ?? '',
                          style: TextStyle(
                            color: repoManager.sortBy == SortBy.decreasing
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                      PopupMenuItem<String>(
                        value: 'original',
                        child: Text(
                          DisplayedString.zhtw['original'] ?? '',
                          style: TextStyle(
                            color: repoManager.sortBy == SortBy.original
                                ? Theme.of(context).primaryColor
                                : Colors.black,
                          ),
                        ),
                      ),
                    ];
                  },
                ),
              ],
            ),

            //ANCHOR Repo card list
            body: Consumer<RepoManager>(builder: (context, repoList, child) {
              return NoOverscrollGlow(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: ListView.builder(
                    itemCount: repoList.repoCardList.length + 1,
                    itemBuilder: (context, index) {
                      if (index == repoList.repoCardList.length) {
                        return Container(height: 50);
                      }
                      return repoList.repoCardList[index];
                    },
                  ),
                ),
              );
            }),

            //ANCHOR Add repo button
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              backgroundColor: Theme.of(context).primaryColor,
              onPressed: () {
                _addRepo(context, repoManager);
              },
            ),
          );
        },
      ),
    );
  }
}

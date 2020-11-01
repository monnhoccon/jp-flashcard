import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_displaying_settings.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:jp_flashcard/services/managers/repo_manager.dart';
import 'package:provider/provider.dart';

class RepoMenuAppBar extends StatelessWidget implements PreferredSizeWidget {

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    var repoManager = Provider.of<RepoManager>(context);

    return AppBar(
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
    );
  }
}

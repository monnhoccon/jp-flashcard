import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/repo_menu/displayed_tag_list.dart';
import 'package:jp_flashcard/services/managers/repo_manager.dart';
import 'package:jp_flashcard/dialogs/add_tag_dialog.dart';
import 'package:jp_flashcard/screens/repo_page/repo_page.dart';
import 'package:jp_flashcard/dialogs/rename_repo_dialog.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';
import '../../../../dialogs/delete_repo_dialog.dart';

// ignore: must_be_immutable
class RepoCard extends StatelessWidget {
  //ANCHOR Public variables
  RepoInfo repoInfo;

  //ANCHOR Constructor
  RepoCard({this.repoInfo});

  //ANCHOR Rename
  void _rename(BuildContext context) {
    RenameRepoDialog.dialog(repoInfo).show(context).then((_) {
      _repoManager.refresh();
    });
  }

  //ANCHOR Edit tag list
  void _editTagList(BuildContext context) {

    AddTagDialog.dialog(repoInfo.tagList)
        .show(context)
        .then((selectedTagList) async {
      if (selectedTagList == null) {
        return;
      } else {
        await repoInfo.updateTagList(selectedTagList);
        _repoManager.refresh();
      }
    });
  }

  //ANCHOR Delete
  void _delete(BuildContext context) {
    DeleteRepoDialog.dialog(repoInfo).show(context).then((_) {
      _repoManager.refresh();
    });
  }

  //ANCHOR Navigation
  void _navigateToRepoPage(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return RepoPage(repoInfo: repoInfo);
    })).then((_) {
      _repoManager.refresh();
    });
    return;
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Providers
    return Padding(
      padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
      child: Card(
        child: InkWell(
          radius: 0.1,
          onTap: () {
            _navigateToRepoPage(context);
          },
          child: repoCard(),
        ),
      ),
    );
  }

  RepoManager _repoManager;
  void _initVariables(BuildContext context) {
    _repoManager = Provider.of<RepoManager>(context, listen: false);
  }

  //ANCHOR Repo card
  Widget repoCard() {
    return Builder(
      builder: (context) {
        //ANCHOR Initialize
        _initVariables(context);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                //ANCHOR Repo info
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    //ANCHOR Title
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 12, 0, 0),
                      child: Text(
                        repoInfo.title ?? '',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ),

                    //ANCHOR Num total and num memorized
                    Padding(
                      padding: EdgeInsets.fromLTRB(15, 8, 0, 12),
                      child: Text(
                        '${repoInfo.numMemorized}/${repoInfo.numTotal} 已學習',
                        style: TextStyle(fontSize: 12),
                      ),
                    ),
                  ],
                ),

                //ANCHOR Popup settings button
                PopupMenuButton<String>(
                  tooltip: DisplayedString.zhtw['edit repo'] ?? '',
                  onSelected: (String result) {
                    if (result == 'rename') {
                      //ANCHOR Rename
                      _rename(context);
                    } else if (result == 'edit tag list') {
                      //ANCHOR Edit taglist
                      _editTagList(context);
                    } else if (result == 'delete') {
                      //ANCHOR Delete
                      _delete(context);
                    }
                  },
                  itemBuilder: (context) {
                    return <PopupMenuEntry<String>>[
                      PopupMenuItem<String>(
                        value: 'rename',
                        child: Text(DisplayedString.zhtw['rename']),
                      ),
                      PopupMenuItem<String>(
                        value: 'edit tag list',
                        child: Text(DisplayedString.zhtw['edit tag list']),
                      ),
                      PopupMenuItem<String>(
                        value: 'delete',
                        child: Text(DisplayedString.zhtw['delete']),
                      ),
                    ];
                  },
                )
              ],
            ),

            //ANCHOR Displayed tag box list
            DisplayedTagList(repoInfo: repoInfo),
          ],
        );
      },
    );
  }
}

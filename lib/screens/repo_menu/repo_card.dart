import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/models/repo_list.dart';
import 'package:jp_flashcard/screens/main_menu/components/add_tag_dialog.dart';
import 'package:jp_flashcard/screens/repo/repo_page.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/screens/repo_menu/components.dart/displayed_tag_list.dart';
import 'package:jp_flashcard/screens/repo_settings_page/components/rename_repo_dialog.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';
import 'delete_repo_dialog.dart';

// ignore: must_be_immutable
class RepoCard extends StatelessWidget {
  //ANCHOR Public variables
  RepoInfo repoInfo;

  //ANCHOR Constructor
  RepoCard({this.repoInfo});

  //ANCHOR Update selected tag box list
  List<TagBox> _selectedTagBoxList = [];

  _updateSelectedTagBoxList() {
    _selectedTagBoxList.clear();
    _selectedTagBoxList = repoInfo.tagList.map((tag) {
      return TagBox(displayedString: tag);
    }).toList();
  }

  //ANCHOR Rename
  void rename(BuildContext context) {
    RenameRepoDialog.dialog(repoInfo).show(context).then((_) {
      _repoList.refresh();
    });
  }

  //ANCHOR Edit tag list
  void editTagList(BuildContext context) {
    _updateSelectedTagBoxList();
    AddTagDialog addTagDialog =
        AddTagDialog(selectedTagBoxList: _selectedTagBoxList);
    addTagDialog.dialog(context).then((selectedTagBoxList) {
      if (selectedTagBoxList == null) {
        return;
      } else {
        List<String> newTagList = selectedTagBoxList.map((e) {
          return e.displayedString;
        }).toList();
        repoInfo.updateTagList(newTagList);
      }
    });
  }

  //ANCHOR Delete
  void delete(BuildContext context) {
    DeleteRepoDialog.dialog(repoInfo).show(context).then((_) {
      _repoList.refresh();
    });
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Providers
    return ChangeNotifierProvider<RepoInfo>(
      create: (context) {
        return repoInfo;
      },
      child: Padding(
        padding: EdgeInsets.fromLTRB(15, 1, 15, 1),
        child: Card(
          child: InkWell(
            splashColor: Colors.blue.withAlpha(5),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) {
                return RepoPage(repoInfo: repoInfo);
              }));
            },
            child: repoCard(),
          ),
        ),
      ),
    );
  }

  RepoList _repoList;
  void _initVariables(BuildContext context) {
    _repoList = Provider.of<RepoList>(context);
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
                      rename(context);
                    } else if (result == 'edit tag list') {
                      //ANCHOR Edit taglist
                      editTagList(context);
                    } else if (result == 'delete') {
                      //ANCHOR Delete
                      delete(context);
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
            DisplayedTagBoxList(),
          ],
        );
      },
    );
  }
}

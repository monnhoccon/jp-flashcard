import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/tag_box.dart';
import 'package:jp_flashcard/dialogs/add_tag_dialog.dart';
import 'package:jp_flashcard/dialogs/delete_repo_dialog.dart';
import 'package:jp_flashcard/dialogs/reset_progress_dialog.dart';
import 'package:jp_flashcard/models/quiz_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/dialogs/rename_repo_dialog.dart';
import 'package:jp_flashcard/screens/repo_settings_page/components/setting_button.dart';
import 'package:jp_flashcard/services/databases/flashcard_database.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RepoSettingsPage extends StatelessWidget {
  //ANCHOR Public variables
  final RepoInfo repoInfo;

  //ANCHOR Constructor
  RepoSettingsPage({this.repoInfo});

  //ANCHOR Rename
  void _rename(BuildContext context) {
    RenameRepoDialog.dialog(repoInfo).show(context);
  }

  //ANCHOR Edit tag list
  void _editTagList(BuildContext context) {
    List<TagBox> selectedTagBoxList = repoInfo.tagList.map((tag) {
      return TagBox(displayedString: tag);
    }).toList();
    AddTagDialog.dialog(selectedTagBoxList)
        .show(context)
        .then((selectedTagBoxList) async {
      if (selectedTagBoxList == null) {
        return;
      } else {
        List<String> newTagList = selectedTagBoxList.map((tag) {
          return tag.displayedString;
        }).toList();
        await repoInfo.updateTagList(newTagList);
      }
    });
  }

  //ANCHOR Reset progress
  void _resetProgress(context) {
    ResetProgressDialog.dialog(repoInfo).show(context);
  }

  //ANCHOR Delete
  void _delete(BuildContext context) async {
    await DeleteRepoDialog.dialog(repoInfo).show(context);
    Navigator.of(context).popUntil((route) => route.isFirst);
  }

  @override
  //ANCHOR Builder
  Widget build(BuildContext context) {
    //ANCHOR Providers
    return ChangeNotifierProvider<QuizSettings>(
      create: (context) {
        return QuizSettings();
      },

      //ANCHOR Quiz settings page
      child: Scaffold(
        appBar: AppBar(
          title: Text(DisplayedString.zhtw['repo settings'] ?? ''),
        ),
        body: Padding(
          padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
          child: Consumer<QuizSettings>(
            builder: (context, quizSettings, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  //ANCHOR Rename button
                  SettingButton(
                    displayedString: DisplayedString.zhtw['rename'],
                    onPressed: () {
                      _rename(context);
                    },
                  ),

                  //ANCHOR Edit tag list button
                  SettingButton(
                    displayedString: DisplayedString.zhtw['edit tag list'],
                    onPressed: () {
                      _editTagList(context);
                    },
                  ),

                  //ANCHOR Reset progress
                  SettingButton(
                    displayedString: DisplayedString.zhtw['reset progress'],
                    onPressed: () {
                      _resetProgress(context);
                    },
                  ),

                  //ANCHOR Delete button
                  SettingButton(
                    displayedString: DisplayedString.zhtw['delete'],
                    onPressed: () {
                      _delete(context);
                    },
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

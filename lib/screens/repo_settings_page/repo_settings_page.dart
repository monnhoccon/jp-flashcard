import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/quiz_settings.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/repo_settings_page/components/button_divider.dart';
import 'package:jp_flashcard/dialogs/rename_repo_dialog.dart';
import 'package:jp_flashcard/screens/repo_settings_page/components/setting_button.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class RepoSettingsPage extends StatelessWidget {
  //ANCHOR Public variables
  final RepoInfo repoInfo;

  //ANCHOR Constructor
  RepoSettingsPage({this.repoInfo});

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
          padding: EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Consumer<QuizSettings>(
            builder: (context, quizSettings, child) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ButtonDivider(),
                  SettingButton(
                    displayedString: DisplayedString.zhtw['rename'],
                    onPressed: () {
                      RenameRepoDialog.dialog(repoInfo).show(context);
                    },
                  ),
                  ButtonDivider(),
                  SettingButton(
                    displayedString: DisplayedString.zhtw['edit tags'],
                    onPressed: () {
                      //AddTagDialog.dialog(repoInfo).show(context);
                    },
                  ),
                  ButtonDivider(),
                  SettingButton(
                    displayedString: DisplayedString.zhtw['delete'],
                    onPressed: () {},
                  ),
                  ButtonDivider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

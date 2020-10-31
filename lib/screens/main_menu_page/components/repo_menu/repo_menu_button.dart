import 'package:flutter/material.dart';
import 'package:jp_flashcard/dialogs/add_repo_dialog.dart';
import 'package:jp_flashcard/services/managers/repo_manager.dart';
import 'package:provider/provider.dart';

class RepoMenuButton extends StatelessWidget {
  void _addRepo(BuildContext context, RepoManager repoManager) {
    AddRepoDialog.dialog().show(context).then((_) {
      repoManager.refresh();
    });
  }

  @override
  Widget build(BuildContext context) {
    var repoManager = Provider.of<RepoManager>(context);
    return FloatingActionButton(
      child: Icon(Icons.add),
      backgroundColor: Theme.of(context).primaryColor,
      onPressed: () async {
        _addRepo(context, repoManager);
      },
    );
  }
}

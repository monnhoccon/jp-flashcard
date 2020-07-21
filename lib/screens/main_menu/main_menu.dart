import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_info.dart';
import 'package:jp_flashcard/screens/main_menu/components/add_repo_dialog.dart';
import 'package:jp_flashcard/screens/main_menu/components/add_tag_dialog.dart';
import 'package:jp_flashcard/screens/repo_menu/repo_menu.dart';
import 'package:jp_flashcard/screens/profile/profile.dart';
import 'dart:async';
import 'package:jp_flashcard/services/database.dart';
import 'package:jp_flashcard/screens/main_menu/components/title_input.dart';
import 'package:jp_flashcard/components/tag_box.dart';

class MainMenu extends StatefulWidget {
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  int _selectedIndex = 0;

  List<Widget> _bodySelected() {
    return <Widget>[
      RepoMenu(),
      Profile(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  FloatingActionButton createRepoButton(context) {
    if (_selectedIndex == 0) {
      return FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).primaryColor,
        onPressed: () {
          AddRepoDialog addRepoDialog = AddRepoDialog();
          addRepoDialog.dialog(context).then((repoInfo) {
            setState(() {
              if (repoInfo != null) {
                print(repoInfo.tagList);
                DBManager.db.insertRepo(repoInfo.title, repoInfo.tagList);
              }
            });
          });
        },
      );
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Center(
          child: _bodySelected().elementAt(_selectedIndex),
        ),
        bottomNavigationBar: BottomNavigationBar(
          items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              title: Text('Home'),
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Profile'),
            ),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Theme.of(context).primaryColor,
          onTap: _onItemTapped,
        ),
        floatingActionButton: createRepoButton(context));
  }
}

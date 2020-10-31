import 'package:flutter/material.dart';
import 'package:jp_flashcard/models/repo_displaying_settings.dart';
import 'package:jp_flashcard/models/user.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/profile/profile_body.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/repo_menu/repo_menu_appbar.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/repo_menu/repo_menu_body.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/repo_menu/repo_menu_button.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/statistics/statistcs_appbar.dart';
import 'package:jp_flashcard/screens/main_menu_page/components/statistics/statistics_body.dart';
import 'package:jp_flashcard/services/managers/repo_manager.dart';
import 'package:provider/provider.dart';

import 'components/profile/profile_appbar.dart';

// ignore: must_be_immutable
class MainMenuPage extends StatefulWidget {
  //ANCHOR Constructor
  MainMenuPage({user});
  User user;
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  List<Widget> _appbar = <Widget>[
    RepoMenuAppBar(),
    StatisticsAppBar(),
    ProfileAppBar(),
  ];
  List<Widget> _button = <Widget>[
    RepoMenuButton(),
    Container(),
    Container(),
  ];
  List<Widget> _body = <Widget>[
    RepoMenuBody(),
    StatisticsBody(),
    ProfileBody(),
  ];

  int _selectedIndex = 0;

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
      child: Scaffold(
        //ANCHOR App bar
        appBar: _appbar.elementAt(_selectedIndex),

        body: _body.elementAt(_selectedIndex),

        floatingActionButton: _button.elementAt(_selectedIndex),

        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.home,
                  color: _selectedIndex == 0
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 0;
                  });
                },
                splashRadius: 0.1,
              ),
              IconButton(
                icon: Icon(
                  Icons.insert_chart,
                  color: _selectedIndex == 1
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 1;
                  });
                },
                splashRadius: 0.1,
              ),
              IconButton(
                icon: Icon(
                  Icons.person,
                  color: _selectedIndex == 2
                      ? Theme.of(context).primaryColor
                      : Colors.grey[400],
                ),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
                splashRadius: 0.1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

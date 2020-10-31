import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:jp_flashcard/screens/login/login.dart';
import 'package:jp_flashcard/screens/main_menu_page/main_menu_page.dart';
import 'package:jp_flashcard/services/auth.dart';
import 'package:jp_flashcard/services/theme.dart';
import 'package:provider/provider.dart';
import 'models/user.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(StreamProvider.value(
    value: Auth().user,
    child: MaterialApp(
      home: Builder(builder: (context) {
        final user = Provider.of<User>(context);

        if (user == null) {
          return LoginScreen();
        } else {
          return MainMenuPage(user: user);
        }
      }),
      theme: MyTheme.theme,
    ),
  ));
}

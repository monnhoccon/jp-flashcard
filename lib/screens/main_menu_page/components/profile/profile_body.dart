import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/sign_button/constant.dart';
import 'package:jp_flashcard/components/sign_button/create_button.dart';
import 'package:jp_flashcard/models/user.dart';
import 'package:jp_flashcard/services/auth.dart';
import 'package:jp_flashcard/services/displayed_string.dart';
import 'package:provider/provider.dart';

class ProfileBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Container(
      child: Padding(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.fromLTRB(15, 25, 15, 10),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: EdgeInsets.fromLTRB(0, 0, 5, 0),
                    child: CircleAvatar(
                      backgroundImage: user.photoURL != ""
                          ? NetworkImage(user.photoURL ?? "")
                          : AssetImage('assets/default_avatar.png'),
                      backgroundColor: Colors.transparent,
                      radius: 25,
                    ),
                  ),
                  !user.isAnon
                      ? Padding(
                          padding: EdgeInsets.fromLTRB(15, 0, 0, 0),
                          child: Text(
                            user.displayName,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : SignInButton(
                          btnColor: Colors.transparent,
                          btnText: DisplayedString.zhtw['google sign in'] ?? '',
                          elevation: 0,
                          buttonType: ButtonType.google,
                          buttonSize: ButtonSize.small,
                          onPressed: () async {
                            dynamic result = await Auth().signInWithGoogle();
                            if (result == null) {
                              print('sign in error');
                            }
                          },
                        ),
                ],
              ),
            ),
            !user.isAnon
                ? ListTile(
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(DisplayedString.zhtw['email'] ?? ''),
                        Text(user.email ?? ''),
                      ],
                    ),
                    onTap: () {},
                  )
                : Container(),
            Divider(
              thickness: 1,
              indent: 17,
              endIndent: 17,
              color: Colors.grey[400],
            ),
            ListTile(
              title: Text(DisplayedString.zhtw['language'] ?? ''),
              onTap: () {},
            ),
            ListTile(
              title: Text(DisplayedString.zhtw['theme'] ?? ''),
              onTap: () {},
            ),
            ListTile(
              title: Text(DisplayedString.zhtw['help'] ?? ''),
              onTap: () {},
            ),
            Divider(
              thickness: 1,
              indent: 17,
              endIndent: 17,
              color: Colors.grey[400],
            ),
            !user.isAnon
                ? ListTile(
                    title: Text(
                      DisplayedString.zhtw['sign out'] ?? '',
                      style: TextStyle(color: Colors.red[600]),
                    ),
                    onTap: () async {
                      dynamic result = await Auth().signOut();
                      if (result == null) {
                        print("sign out error");
                      }
                    },
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

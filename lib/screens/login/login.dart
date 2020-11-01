import 'package:flutter/material.dart';
import 'package:jp_flashcard/components/sign_button/constant.dart';
import 'package:jp_flashcard/components/sign_button/create_button.dart';
import 'package:jp_flashcard/services/auth.dart';
import 'package:jp_flashcard/services/displayed_string.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Container(
        width: screenWidth,
        height: screenHeight,
        color: Colors.grey[100],
        child: Center(
          child: Padding(
            padding:
                EdgeInsets.fromLTRB(0, screenHeight / 4, 0, screenHeight / 12),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage('assets/images/icon.png'),
                  backgroundColor: Colors.transparent,
                  radius: 40,
                ),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SignInButton(
                      btnColor: Theme.of(context).primaryColor,
                      btnText: DisplayedString.zhtw['google sign in'] ?? '',
                      btnTextColor: Colors.white,
                      elevation: 0,
                      buttonType: ButtonType.whiteGoogle,
                      buttonSize: ButtonSize.whiteGoogle,
                      onPressed: () async {
                        dynamic result = await Auth().signInWithGoogle();
                        if (result == null) {
                          print('sign in error');
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    FlatButton(
                      child: Text(
                        DisplayedString.zhtw['or get started'] ?? '',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      onPressed: () async {
                        await Auth().signInAnon();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

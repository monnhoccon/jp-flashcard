import 'package:flutter/material.dart';

class User extends ChangeNotifier{
  User({this.uid, this.displayName, this.email, this.photoURL, this.isAnon});
  bool isAnon;
  String displayName;
  String uid;
  String email;
  String photoURL;
}

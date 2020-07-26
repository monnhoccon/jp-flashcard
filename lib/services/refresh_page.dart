import 'package:flutter/material.dart';

class RefreshPage with ChangeNotifier {
  RefreshPage();

  void refresh() {
    notifyListeners();
  }
}

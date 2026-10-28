import 'package:flutter/material.dart';

class MainViewmodel extends ChangeNotifier {



  int currentIndex = 0;

  void navigateToPages(int index) {
    currentIndex = index;
    notifyListeners();
  }
}

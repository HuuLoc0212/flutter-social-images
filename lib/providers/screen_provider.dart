import 'package:flutter/cupertino.dart';

class ScreenProvider with ChangeNotifier {
  int _currentTab = 0;

  changeTab(int index) {
    _currentTab = index;
    notifyListeners();
  }

  get currentTab => _currentTab;
}

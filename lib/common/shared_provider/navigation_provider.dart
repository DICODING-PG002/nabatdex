import 'package:flutter/material.dart';

/// Provider untuk switch navigasi bottom navbar berdasarkan index item nya
class NavigationProvider with ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    _selectedIndex = index;
    notifyListeners();
  }
}

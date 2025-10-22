import 'package:flutter/material.dart';

class JournalRefreshProvider with ChangeNotifier {
  void notifyJournalUpdate() {
    notifyListeners();
  }
}


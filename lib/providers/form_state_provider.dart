import 'package:flutter/material.dart';

class FormStateProvider with ChangeNotifier {
  String? title;
  String? description;

  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
  }
}

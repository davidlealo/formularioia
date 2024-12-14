import 'package:flutter/material.dart';

class FormStateProvider extends ChangeNotifier {
  String? title;
  String? description;
  String? activity1;
  String? activity2;
  String? activity3;
  String? activity4;
  String? date1;
  String? date2;
  String? date3;
  String? date4;
  String? comments;

  // Método para actualizar el título
  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners(); // Notifica a los widgets que están escuchando
  }

  // Método para actualizar la descripción
  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners(); // Notifica a los widgets que están escuchando
  }
}

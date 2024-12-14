import 'package:flutter/material.dart';

class FormStateProvider extends ChangeNotifier {
  String? title;
  String? description;

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

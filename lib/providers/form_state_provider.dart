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

  // Método para obtener una propiedad por nombre
  String? getProperty(String propertyName) {
    switch (propertyName) {
      case "title":
        return title;
      case "description":
        return description;
      case "activity1":
        return activity1;
      case "activity2":
        return activity2;
      case "activity3":
        return activity3;
      case "activity4":
        return activity4;
      case "date1":
        return date1;
      case "date2":
        return date2;
      case "date3":
        return date3;
      case "date4":
        return date4;
      case "comments":
        return comments;
      default:
        print("Propiedad no válida solicitada: $propertyName");
        return null;
    }
  }

  // Método para establecer una propiedad por nombre
  void setProperty(String propertyName, String value) {
    print("Actualizando propiedad $propertyName a: $value");
    switch (propertyName) {
      case "title":
        title = value;
        break;
      case "description":
        description = value;
        break;
      case "activity1":
        activity1 = value;
        break;
      case "activity2":
        activity2 = value;
        break;
      case "activity3":
        activity3 = value;
        break;
      case "activity4":
        activity4 = value;
        break;
      case "date1":
        date1 = value;
        break;
      case "date2":
        date2 = value;
        break;
      case "date3":
        date3 = value;
        break;
      case "date4":
        date4 = value;
        break;
      case "comments":
        comments = value;
        break;
      default:
        print("Propiedad no válida: $propertyName");
        return;
    }
    notifyListeners();
    _printFormState();
  }

  // Métodos específicos para actualizar campos individuales
  void updateTitle(String newTitle) {
    print("Método updateTitle llamado con valor: $newTitle");
    title = newTitle;
    notifyListeners();
    _printFormState();
  }

  void updateDescription(String newDescription) {
    print("Método updateDescription llamado con valor: $newDescription");
    description = newDescription;
    notifyListeners();
    _printFormState();
  }

  void updateActivity(String activityName, String newDescription) {
    print("Método updateActivity llamado para $activityName con valor: $newDescription");
    switch (activityName) {
      case "activity1":
        activity1 = newDescription;
        break;
      case "activity2":
        activity2 = newDescription;
        break;
      case "activity3":
        activity3 = newDescription;
        break;
      case "activity4":
        activity4 = newDescription;
        break;
      default:
        print("Actividad no válida: $activityName");
        return;
    }
    notifyListeners();
    _printFormState();
  }

  void updateDate(String dateName, String newDate) {
    print("Método updateDate llamado para $dateName con valor: $newDate");
    switch (dateName) {
      case "date1":
        date1 = newDate;
        break;
      case "date2":
        date2 = newDate;
        break;
      case "date3":
        date3 = newDate;
        break;
      case "date4":
        date4 = newDate;
        break;
      default:
        print("Fecha no válida: $dateName");
        return;
    }
    notifyListeners();
    _printFormState();
  }

  void updateComments(String newComments) {
    print("Método updateComments llamado con valor: $newComments");
    comments = newComments;
    notifyListeners();
    _printFormState();
  }

  // Método privado para imprimir el estado completo del formulario
  void _printFormState() {
    print("---- Estado del formulario actualizado ----");
    print("Título: $title");
    print("Descripción: $description");
    print("Actividad 1: $activity1 (Fecha: $date1)");
    print("Actividad 2: $activity2 (Fecha: $date2)");
    print("Actividad 3: $activity3 (Fecha: $date3)");
    print("Actividad 4: $activity4 (Fecha: $date4)");
    print("Comentarios: $comments");
    print("------------------------------------------");
  }
}

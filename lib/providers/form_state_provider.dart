import 'dart:developer' as developer; // Importa dart:developer
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
        return null;
    }
  }

  // Método para establecer una propiedad por nombre
  void setProperty(String propertyName, String value) {
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
        developer.log("Propiedad no válida: $propertyName", name: "FormStateProvider");
        return;
    }
    notifyListeners();
    _logFormState();
  }

  // Métodos específicos para actualizar campos individuales
  void updateTitle(String newTitle) {
    title = newTitle;
    notifyListeners();
    _logFormState();
  }

  void updateDescription(String newDescription) {
    description = newDescription;
    notifyListeners();
    _logFormState();
  }

  void updateActivity(String activityName, String newDescription) {
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
        developer.log("Actividad no válida: $activityName", name: "FormStateProvider");
        return;
    }
    notifyListeners();
    _logFormState();
  }

  void updateDate(String dateName, String newDate) {
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
        developer.log("Fecha no válida: $dateName", name: "FormStateProvider");
        return;
    }
    notifyListeners();
    _logFormState();
  }

  void updateComments(String newComments) {
    comments = newComments;
    notifyListeners();
    _logFormState();
  }

  // Método privado para imprimir el estado completo del formulario
  void _logFormState() {
    developer.log("Estado del formulario actualizado:", name: "FormStateProvider");
    developer.log("Título: $title", name: "FormStateProvider");
    developer.log("Descripción: $description", name: "FormStateProvider");
    developer.log("Actividad 1: $activity1 (Fecha: $date1)", name: "FormStateProvider");
    developer.log("Actividad 2: $activity2 (Fecha: $date2)", name: "FormStateProvider");
    developer.log("Actividad 3: $activity3 (Fecha: $date3)", name: "FormStateProvider");
    developer.log("Actividad 4: $activity4 (Fecha: $date4)", name: "FormStateProvider");
    developer.log("Comentarios: $comments", name: "FormStateProvider");
    developer.log("-----------------------------", name: "FormStateProvider");
  }
}

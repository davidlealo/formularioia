import 'package:flutter/material.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> activityControllers = List.generate(4, (_) => TextEditingController());
  final TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Escucha los cambios desde el estado global
    FormStateProvider.addListener(updateFormFields);
  }

  void updateFormFields() {
    setState(() {
      titleController.text = FormStateProvider.title ?? '';
      descriptionController.text = FormStateProvider.description ?? '';
      // Otros campos se actualizan aquí
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(8.0),
      children: [
        TextField(
          controller: titleController,
          decoration: InputDecoration(labelText: 'Título'),
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Descripción'),
        ),
        for (int i = 0; i < 4; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Actividad ${i + 1}'),
              TextField(
                controller: activityControllers[i],
                decoration: InputDecoration(labelText: 'Descripción'),
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Fecha'),
              ),
            ],
          ),
        TextField(
          controller: commentsController,
          decoration: InputDecoration(labelText: 'Comentarios'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    FormStateProvider.removeListener(updateFormFields);
    super.dispose();
  }
}

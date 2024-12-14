import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:formularioia/providers/form_state_provider.dart';

class FormWidget extends StatefulWidget {
  @override
  _FormWidgetState createState() => _FormWidgetState();
}

class _FormWidgetState extends State<FormWidget> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final List<TextEditingController> activityControllers =
      List.generate(4, (_) => TextEditingController());
  final TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Escucha los cambios desde el estado global y actualiza los campos
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    formState.addListener(updateFormFields);
  }

  void updateFormFields() {
    // Obtén el estado actualizado y actualiza los campos del formulario
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    setState(() {
      titleController.text = formState.title ?? '';
      descriptionController.text = formState.description ?? '';
      // Puedes agregar lógica para las actividades si es necesario
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
          onChanged: (value) {
            Provider.of<FormStateProvider>(context, listen: false)
                .updateTitle(value);
          },
        ),
        TextField(
          controller: descriptionController,
          decoration: InputDecoration(labelText: 'Descripción'),
          onChanged: (value) {
            Provider.of<FormStateProvider>(context, listen: false)
                .updateDescription(value);
          },
        ),
        for (int i = 0; i < 4; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Actividad ${i + 1}'),
              TextField(
                controller: activityControllers[i],
                decoration: InputDecoration(labelText: 'Descripción'),
                // Lógica adicional para actualizar actividades aquí
              ),
              TextField(
                decoration: InputDecoration(labelText: 'Fecha'),
                // Lógica adicional para actualizar fechas aquí
              ),
            ],
          ),
        TextField(
          controller: commentsController,
          decoration: InputDecoration(labelText: 'Comentarios'),
          // Lógica para actualizar comentarios si es necesario
        ),
      ],
    );
  }

  @override
  void dispose() {
    // Elimina el listener al destruir el widget
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    formState.removeListener(updateFormFields);
    super.dispose();
  }
}

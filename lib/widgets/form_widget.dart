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
  final List<TextEditingController> dateControllers =
      List.generate(4, (_) => TextEditingController());
  final TextEditingController commentsController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Escucha los cambios en el estado del formulario
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    formState.addListener(updateFormFields);

    // Inicializa los campos del formulario con los valores actuales
    updateFormFields();
  }

  void updateFormFields() {
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    setState(() {
      titleController.text = formState.title ?? '';
      descriptionController.text = formState.description ?? '';
      commentsController.text = formState.comments ?? '';

      for (int i = 0; i < 4; i++) {
        activityControllers[i].text =
            formState.getProperty('activity${i + 1}') ?? '';
        dateControllers[i].text =
            formState.getProperty('date${i + 1}') ?? '';
      }
    });
  }

  @override
  void dispose() {
    // Limpia los controladores de texto
    titleController.dispose();
    descriptionController.dispose();
    commentsController.dispose();
    for (final controller in activityControllers) {
      controller.dispose();
    }
    for (final controller in dateControllers) {
      controller.dispose();
    }

    // Remueve el listener del estado del formulario
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    formState.removeListener(updateFormFields);

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16.0),
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(
            labelText: 'Título',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            Provider.of<FormStateProvider>(context, listen: false)
                .updateTitle(value);
          },
        ),
        const SizedBox(height: 16.0),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(
            labelText: 'Descripción',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            Provider.of<FormStateProvider>(context, listen: false)
                .updateDescription(value);
          },
        ),
        const SizedBox(height: 16.0),
        for (int i = 0; i < 4; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('Actividad ${i + 1}'),
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: activityControllers[i],
                decoration: const InputDecoration(
                  labelText: 'Descripción',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  Provider.of<FormStateProvider>(context, listen: false)
                      .setProperty('activity${i + 1}', value);
                },
              ),
              const SizedBox(height: 8.0),
              TextField(
                controller: dateControllers[i],
                decoration: const InputDecoration(
                  labelText: 'Fecha',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  Provider.of<FormStateProvider>(context, listen: false)
                      .setProperty('date${i + 1}', value);
                },
              ),
              const SizedBox(height: 16.0),
            ],
          ),
        const SizedBox(height: 16.0),
        TextField(
          controller: commentsController,
          decoration: const InputDecoration(
            labelText: 'Comentarios',
            border: OutlineInputBorder(),
          ),
          onChanged: (value) {
            Provider.of<FormStateProvider>(context, listen: false)
                .updateComments(value);
          },
        ),
      ],
    );
  }
}

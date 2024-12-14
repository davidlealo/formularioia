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
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    formState.addListener(updateFormFields);
    updateFormFields(); // Inicializa los valores al construir el widget
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
        dateControllers[i].text = formState.getProperty('date${i + 1}') ?? '';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(8.0),
      children: [
        TextField(
          controller: titleController,
          decoration: const InputDecoration(labelText: 'Título'),
          onChanged: (value) {
            Provider.of<FormStateProvider>(context, listen: false)
                .updateTitle(value);
          },
        ),
        TextField(
          controller: descriptionController,
          decoration: const InputDecoration(labelText: 'Descripción'),
          onChanged: (value) {
            Provider.of<FormStateProvider>(context, listen: false)
                .updateDescription(value);
          },
        ),
        for (int i = 0; i < 4; i++)
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: Text('Actividad ${i + 1}'),
              ),
              TextField(
                controller: activityControllers[i],
                decoration: const InputDecoration(labelText: 'Descripción'),
                onChanged: (value) {
                  Provider.of<FormStateProvider>(context, listen: false)
                      .setProperty('activity${i + 1}', value);
                },
              ),
              TextField(
                controller: dateControllers[i],
                decoration: const InputDecoration(labelText: 'Fecha'),
                onChanged: (value) {
                  Provider.of<FormStateProvider>(context, listen: false)
                      .setProperty('date${i + 1}', value);
                },
              ),
            ],
          ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: TextField(
            controller: commentsController,
            decoration: const InputDecoration(labelText: 'Comentarios'),
            onChanged: (value) {
              Provider.of<FormStateProvider>(context, listen: false)
                  .updateComments(value);
            },
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    final formState = Provider.of<FormStateProvider>(context, listen: false);
    formState.removeListener(updateFormFields);
    super.dispose();
  }
}

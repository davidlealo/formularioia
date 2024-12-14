import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Importa Provider
import 'package:formularioia/providers/form_state_provider.dart';

class ChatWidget extends StatefulWidget {
  @override
  _ChatWidgetState createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  final TextEditingController _controller = TextEditingController();
  List<String> messages = [];
  
  void sendMessage(String message) async {
    setState(() {
      messages.add("You: $message");
    });

    // Simular respuesta de la API de Mistral
    final response = await sendToMistralAPI(message);
    setState(() {
      messages.add("Bot: $response");
    });

    // Analiza el mensaje y actualiza el formulario
    parseMessageAndUpdateForm(response);
  }

  Future<String> sendToMistralAPI(String message) async {
    // Simula una llamada a la API de Mistral
    await Future.delayed(Duration(seconds: 1)); // Simula latencia
    return "¡Título identificado: Proyecto X!";
  }

  void parseMessageAndUpdateForm(String response) {
    // Lógica para extraer datos relevantes y actualizar el formulario.
    if (response.contains("Título identificado")) {
      String title = response.split(": ")[1];

      // Obtén la instancia del FormStateProvider y actualiza el título
      final formState = Provider.of<FormStateProvider>(context, listen: false);
      formState.updateTitle(title); // Actualiza el título en el proveedor
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: messages.length,
            itemBuilder: (context, index) {
              return ListTile(title: Text(messages[index]));
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type your message',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.isNotEmpty) {
                    sendMessage(_controller.text);
                    _controller.clear();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}

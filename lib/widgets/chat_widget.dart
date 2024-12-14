import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
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

    try {
      // Llama al servicio de Mistral
      final response = await sendToMistralAPI(message);

      setState(() {
        messages.add("Bot: $response");
      });

      // Analiza la respuesta y actualiza el formulario
      parseMessageAndUpdateForm(response);
    } catch (e) {
      setState(() {
        messages.add("Bot: Error al procesar el mensaje.");
      });
      print("Error: $e");
    }
  }

  Future<String> sendToMistralAPI(String message) async {
  try {
    final apiKey = dotenv.env['API_KEY'];
    if (apiKey == null || apiKey.isEmpty) {
      print("Error: API_KEY no está configurada en el archivo .env");
      return "Error: API_KEY no está configurada.";
    }

    final apiUrl = "https://api.mistral.ai/v1/chat/completions";

    // Contexto del formulario actual
    final formState = Provider.of<FormStateProvider>(context, listen: false);

    final prompt = '''
Eres un asistente que ayuda a personalizar un formulario. Actualmente, el formulario tiene los siguientes campos:

- Título: ${formState.title ?? "Sin definir"}
- Descripción: ${formState.description ?? "Sin definir"}

El usuario te ha enviado este mensaje: "$message".

Tu tarea es actualizar los campos relevantes en función de la solicitud del usuario. Responde en este formato:
- "Campo actualizado: [nombre del campo], Nuevo valor: [valor actualizado]"

Por ejemplo:
Usuario: "Cambia el título a Proyecto X."
Tú: "Campo actualizado: Título, Nuevo valor: Proyecto X."
''';

    final body = jsonEncode({
      "messages": [
        {"role": "system", "content": "Eres un asistente experto en formularios."},
        {"role": "user", "content": prompt}
      ],
      "model": "mistral-large-latest",
    });

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $apiKey",
      },
      body: body,
    );

    print("HTTP Status Code: ${response.statusCode}");
    print("HTTP Response Body: ${response.body}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data.containsKey("choices") && data["choices"][0]["message"]["content"] != null) {
        return data["choices"][0]["message"]["content"];
      } else {
        return "Error: Formato de respuesta inesperado.";
      }
    } else {
      return "Error: Falló la llamada a la API (Código ${response.statusCode}).";
    }
  } catch (e) {
    print("Error al llamar a la API de Mistral: $e");
    return "Error: Ocurrió un problema al procesar tu solicitud.";
  }
}


  void parseMessageAndUpdateForm(String response) {
  final formState = Provider.of<FormStateProvider>(context, listen: false);

  // Busca actualizaciones específicas de campos en la respuesta del bot
  final titleRegex = RegExp(r'Campo actualizado: Título, Nuevo valor: (.+)');
  final descriptionRegex =
      RegExp(r'Campo actualizado: Descripción, Nuevo valor: (.+)');

  final titleMatch = titleRegex.firstMatch(response);
  final descriptionMatch = descriptionRegex.firstMatch(response);

  if (titleMatch != null) {
    final newTitle = titleMatch.group(1);
    formState.updateTitle(newTitle!);
  }

  if (descriptionMatch != null) {
    final newDescription = descriptionMatch.group(1);
    formState.updateDescription(newDescription!);
  }

  // Imprime los valores actualizados para depuración
  print("Título actualizado a: ${formState.title}");
  print("Descripción actualizada a: ${formState.description}");
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
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  maxLines: null, // Permite múltiples líneas
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Type your message',
                  ),
                  onSubmitted: (value) {
                    if (value.trim().isNotEmpty) {
                      sendMessage(value.trim());
                      _controller.clear();
                    }
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.send),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    sendMessage(_controller.text.trim());
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

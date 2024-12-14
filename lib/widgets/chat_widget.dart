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
      // Obtén la API Key desde el archivo .env
      final apiKey = dotenv.env['API_KEY'];

      // Verifica que la API Key está configurada
      if (apiKey == null || apiKey.isEmpty) {
        print("Error: API_KEY no está configurada en el archivo .env");
        return "Error: API_KEY no está configurada.";
      }

      // URL de la API de Mistral
      final apiUrl = "https://api.mistral.ai/v1/chat/completions";

      // Cuerpo de la solicitud
      final body = jsonEncode({
        "model": "mistral-large-latest", // Modelo especificado
        "messages": [
          {
            "role": "user", // Define el rol como "user"
            "content": message // El mensaje del usuario
          }
        ]
      });

      // Realiza la solicitud POST a la API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $apiKey",
        },
        body: body,
      );

      // Imprime el estado de la respuesta para depuración
      print("HTTP Status Code: ${response.statusCode}");
      print("HTTP Response Body: ${response.body}");

      if (response.statusCode == 200) {
        // Decodifica la respuesta JSON
        final data = jsonDecode(response.body);

        // Extrae el contenido de la respuesta
        if (data.containsKey("choices") && data["choices"].isNotEmpty) {
          return data["choices"][0]["message"]["content"];
        } else {
          return "Error: Respuesta inesperada del modelo.";
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
    final titleRegex = RegExp(r'Título identificado: (.+)');
    final descriptionRegex = RegExp(r'Descripción actualizada a: (.+)');

    final titleMatch = titleRegex.firstMatch(response);
    final descriptionMatch = descriptionRegex.firstMatch(response);

    final formState = Provider.of<FormStateProvider>(context, listen: false);

    // Actualiza el título si se encuentra en la respuesta
    if (titleMatch != null) {
      final title = titleMatch.group(1);
      formState.updateTitle(title!);
    }

    // Actualiza la descripción si se encuentra en la respuesta
    if (descriptionMatch != null) {
      final description = descriptionMatch.group(1);
      formState.updateDescription(description!);
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

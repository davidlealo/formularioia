import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:formularioia/providers/form_state_provider.dart';

class MistralService {
  final String apiUrl = 'https://api.mistral.ai/v1/chat/completions';

  // Función para construir el prompt dinámico
  String _buildPrompt(String userMessage, FormStateProvider formState) {
    return '''
Eres un asistente que ayuda a personalizar un formulario. El formulario tiene los siguientes campos:

1. Título: ${formState.title ?? "Sin definir"}
2. Descripción: ${formState.description ?? "Sin definir"}
3. Actividades:
   - Actividad 1: ${formState.activity1 ?? "Sin definir"} (${formState.date1 ?? "Sin fecha"})
   - Actividad 2: ${formState.activity2 ?? "Sin definir"} (${formState.date2 ?? "Sin fecha"})
   - Actividad 3: ${formState.activity3 ?? "Sin definir"} (${formState.date3 ?? "Sin fecha"})
   - Actividad 4: ${formState.activity4 ?? "Sin definir"} (${formState.date4 ?? "Sin fecha"})
4. Comentarios: ${formState.comments ?? "Sin definir"}

Tu tarea es interpretar las instrucciones del usuario para actualizar los campos del formulario. Responde de la siguiente manera:
- Campo actualizado: [nombre del campo]
- Nuevo valor: [valor proporcionado por el usuario]

Ejemplo:
Usuario: "Quiero que el título sea 'Nuevo Proyecto'."
Tú: "Campo actualizado: Título, Nuevo valor: Nuevo Proyecto."

Aquí está la solicitud del usuario:
"$userMessage"
''';
  }

  // Función para enviar el mensaje a Mistral
  Future<String> sendMessage(String userMessage, FormStateProvider formState) async {
    try {
      // Obtén la API key desde las variables de entorno
      final apiKey = dotenv.env['API_KEY'];

      // Verifica si la API key está configurada
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key is not defined in .env file');
      }

      // Construye el prompt
      final prompt = _buildPrompt(userMessage, formState);

      // Construye el cuerpo de la solicitud
      final requestBody = jsonEncode({
        "messages": [
          {"role": "system", "content": "Eres un asistente experto en formularios."},
          {"role": "user", "content": prompt}
        ],
        "model": "mistral-large-latest",
      });

      // Realiza la solicitud HTTP POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: requestBody,
      );

      // Log para depuración
      print("HTTP Status Code: ${response.statusCode}");
      print("HTTP Response Body: ${response.body}");

      // Procesa la respuesta de la API
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);

        // Verifica si hay contenido en la respuesta
        if (responseData['choices'] != null &&
            responseData['choices'][0]['message']['content'] != null) {
          return responseData['choices'][0]['message']['content'];
        } else {
          throw Exception('Unexpected response format from API');
        }
      } else {
        throw Exception(
            'API call failed with status code ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('Error en la llamada a Mistral: $e');
      return 'Error: No se pudo procesar tu solicitud. Intenta nuevamente.';
    }
  }
}

import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:formularioia/providers/form_state_provider.dart';

class MistralService {
  final String apiUrl = 'https://api.mistral.com/v1/chat';

  Future<String> sendMessage(String userMessage, FormStateProvider formState) async {
    try {
      // Obtén la API key desde las variables de entorno
      final apiKey = dotenv.env['API_KEY'];

      // Verifica si la API key está configurada
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key is not defined in .env file');
      }

      // Prompt para guiar a Mistral
      final prompt = '''
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

      // Realiza la solicitud a la API
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey', // Incluye la API key en los headers
        },
        body: json.encode({'message': prompt}),
      );

      // Manejo de la respuesta
      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Verifica si la respuesta contiene el campo esperado
        if (data.containsKey('response')) {
          return data['response'];
        } else {
          throw Exception('Unexpected response format: ${response.body}');
        }
      } else {
        throw Exception(
            'Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      // Captura y devuelve cualquier error
      return 'Error: $e';
    }
  }
}

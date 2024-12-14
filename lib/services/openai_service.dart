import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> sendMessage(String userMessage, String prompt) async {
    try {
      // Obtén la API key desde las variables de entorno
      final apiKey = dotenv.env['OPENAI_API_KEY'];

      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('OpenAI API key is not defined in .env file');
      }

      // Construir el cuerpo de la solicitud
      final body = {
        "model": "gpt-3.5-turbo", // Modelo de OpenAI
        "messages": [
          {"role": "system", "content": prompt}, // Prompt inicial
          {"role": "user", "content": userMessage} // Mensaje del usuario
        ],
        "temperature": 0.7
      };

      // Realiza la solicitud a la API de OpenAI
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: json.encode(body),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        // Devuelve la respuesta del asistente
        return data['choices'][0]['message']['content'];
      } else {
        throw Exception('Failed to send message: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}

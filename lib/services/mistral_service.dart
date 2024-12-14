import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class MistralService {
  final String apiUrl = 'https://api.mistral.com/v1/chat';

  Future<String> sendMessage(String message) async {
    try {
      // Obtén la API key desde las variables de entorno
      final apiKey = dotenv.env['API_KEY'];

      // Verifica si la API key está configurada
      if (apiKey == null || apiKey.isEmpty) {
        throw Exception('API key is not defined in .env file');
      }

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey', // Incluye la API key en los headers
        },
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to send message: ${response.statusCode}');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}

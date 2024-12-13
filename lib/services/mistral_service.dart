import 'dart:convert';
import 'package:http/http.dart' as http;

class MistralService {
  final String apiUrl = 'https://api.mistral.com/v1/chat';

  Future<String> sendMessage(String message) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({'message': message}),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['response'];
      } else {
        throw Exception('Failed to send message');
      }
    } catch (e) {
      return 'Error: $e';
    }
  }
}

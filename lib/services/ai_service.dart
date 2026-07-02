import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/constants.dart';

class AiService {
  final String _baseUrl = AppConstants.baseUrl;

  Future<String> planTrip({
    required String query,
    required String locale,
  }) async {
    final uri = Uri.parse('$_baseUrl/api/v1/ai/plan');
    final response = await http
        .post(
          uri,
          headers: {'Content-Type': 'application/json'},
          body: json.encode({
            'query': query,
            'locale': locale,
          }),
        )
        .timeout(const Duration(seconds: 60));

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      return data['result'] as String? ?? '';
    } else {
      throw Exception('AI service error: ${response.statusCode}');
    }
  }
}

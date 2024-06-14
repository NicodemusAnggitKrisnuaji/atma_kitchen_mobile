import 'dart:convert';
import 'package:http/http.dart' as http;

class UserClient {
  static String url = '10.0.2.2:8000';
  static String endpoint = '/api/login';

  static Future<Map<String, dynamic>> login(
      String email, String password) async {
    try {
      var response = await http.post(
        Uri.http(url, endpoint),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );

      // Print status code and body for debugging purposes
      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        if (response.body.isNotEmpty) {
          var decodedResponse = jsonDecode(response.body);
          if (decodedResponse is Map<String, dynamic>) {
            return decodedResponse;
          } else {
            return Future.error('Unexpected response format');
          }
        } else {
          return Future.error('Login failed: response body is empty');
        }
      } else {
        return Future.error(
            'Login failed with status: ${response.statusCode}, body: ${response.body}');
      }
    } catch (e) {
      print(e);
      return Future.error(e.toString());
    }
  }
}

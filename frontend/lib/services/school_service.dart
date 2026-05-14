import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/school.dart';

class SchoolService {
  // Change this URL to your deployed backend URL when deploying
  static const String _baseUrl = 'http://localhost:3000';

  /// Fetches all schools from the backend API.
  Future<List<School>> getAllSchools() async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/schools'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        final List<dynamic> data = body['data'];
        return data.map((json) => School.fromJson(json)).toList();
      } else {
        throw Exception(
          'Failed to load schools. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }

  /// Fetches a single school by its ID.
  Future<School> getSchoolById(int id) async {
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/schools/$id'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> body = jsonDecode(response.body);
        return School.fromJson(body['data']);
      } else if (response.statusCode == 404) {
        throw Exception('School not found.');
      } else {
        throw Exception(
          'Failed to load school. Status code: ${response.statusCode}',
        );
      }
    } catch (e) {
      throw Exception('Network error: $e');
    }
  }
}

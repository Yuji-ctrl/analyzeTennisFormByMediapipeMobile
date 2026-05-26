import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class AnalysisApiService {
  static String get _baseUrl {
    if (kIsWeb) {
      return 'http://localhost:8000';
    }
    if (Platform.isAndroid) {//実機もエミュレータも両方OK（少なくともiOSでないことを保証するだけ）
      return 'http://127.0.0.1:8000';
    }
    return 'http://127.0.0.1:8000';
  }

  static Future<Map<String, dynamic>> healthCheck() async {
    try {
      final response = await http
          .get(Uri.parse('$_baseUrl/health'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Health check failed: ${response.statusCode}');
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } on TimeoutException {
      throw Exception('Health check timeout: $_baseUrl/health');
    } on SocketException catch (e) {
      throw Exception('Socket error: $e');
    }
  }

  static Future<Map<String, dynamic>> echo(String message) async {
    try {
      final response = await http
          .post(
            Uri.parse('$_baseUrl/echo'),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({'message': message}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode != 200) {
        throw Exception('Echo failed: ${response.statusCode}');
      }

      return jsonDecode(response.body) as Map<String, dynamic>;
    } on TimeoutException {
      throw Exception('Echo timeout: $_baseUrl/echo');
    } on SocketException catch (e) {
      throw Exception('Socket error: $e');
    }
  }
}
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class IpService {
  static Future<String> obtenerIpPublica() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ipify.org?format=json'),
        headers: {'Content-Type': 'application/json'},
      );
      
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['ip'] ?? 'IP no disponible';
      } else {
        return 'IP no disponible';
      }
    } catch (e) {
      if (kDebugMode) {
        debugPrint('Error obteniendo IP: $e');
      }
      return 'IP no disponible';
    }
  }
}
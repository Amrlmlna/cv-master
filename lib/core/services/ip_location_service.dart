import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class IpLocationService {
  static const String _apiUrl = 'http://ip-api.com/json';

  Future<String?> getCountryCode() async {
    try {
      final response = await http.get(Uri.parse(_apiUrl)).timeout(
        const Duration(seconds: 5),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return data['countryCode'] as String?;
      }
    } catch (e) {
      debugPrint('Error fetching IP location: $e');
    }
    return null;
  }
}

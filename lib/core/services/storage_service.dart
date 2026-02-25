import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import '../config/api_config.dart';

class StorageService {
  static String get _uploadUrl => '${ApiConfig.baseUrl}/user/photo';

  Future<String?> uploadProfilePhoto(File file, String userId) async {
    try {
      final request = http.MultipartRequest('POST', Uri.parse(_uploadUrl));
      
      // Add Firebase Auth headers
      final headers = await ApiConfig.getAuthHeaders();
      // Remove Content-Type from getAuthHeaders because MultipartRequest sets it automatically
      headers.remove('Content-Type');
      request.headers.addAll(headers);

      // Add file
      final fileStream = http.ByteStream(file.openRead());
      final length = await file.length();
      
      final multipartFile = http.MultipartFile(
        'photo', 
        fileStream, 
        length,
        filename: 'profile.jpg',
      );
      
      request.files.add(multipartFile);

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final downloadUrl = data['photoUrl'];
        debugPrint('Profile photo uploaded via backend: $downloadUrl');
        return downloadUrl;
      } else {
        debugPrint('Failed to upload photo via backend: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      debugPrint('Error uploading profile photo via backend: $e');
      return null;
    }
  }

  Future<void> deleteProfilePhoto(String userId) async {
    // Note: Backend implementation for photo deletion can be added if needed.
    // For now, we mainly care about successful uploads.
    debugPrint('Profile photo deletion requested for $userId (Not yet implemented in backend)');
  }
}

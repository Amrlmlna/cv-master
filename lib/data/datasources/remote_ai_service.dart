import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import '../../domain/entities/cv_data.dart';
import '../../domain/entities/job_input.dart';
import '../../domain/entities/user_profile.dart';

class RemoteAIService {
  // Use 10.0.2.2 for Android Emulator, 192.168.1.5 for local network
  static const String baseUrl = 'http://192.168.1.5:3000/api/cv';

  Future<CVData> generateCV({
    required UserProfile profile,
    required JobInput jobInput,
    required String styleId,
  }) async {
    final url = Uri.parse('$baseUrl/generate');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'profile': profile.toJson(),
          'jobInput': jobInput.toJson(),
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final summary = data['generatedSummary'] as String;
        final tailoredSkills = List<String>.from(data['tailoredSkills']);

        return CVData(
          id: const Uuid().v4(),
          userProfile: profile.copyWith(
            skills: tailoredSkills, // Use AI suggested skills
            experience: profile.experience, // Preserved
            education: profile.education, // Preserved
          ),
          generatedSummary: summary,
          tailoredSkills: tailoredSkills,
          styleId: styleId,
          createdAt: DateTime.now(),
          jobTitle: jobInput.jobTitle,
        );
      } else {
        throw Exception('Failed to generate CV: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }

  Future<String> rewriteContent(String originalText) async {
    final url = Uri.parse('$baseUrl/rewrite');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'originalText': originalText,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['rewrittenText'] as String;
      } else {
        throw Exception('Failed to rewrite content: ${response.body}');
      }
    } catch (e) {
      throw Exception('Network Error: $e');
    }
  }
}

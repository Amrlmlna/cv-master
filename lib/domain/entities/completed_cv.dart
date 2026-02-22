import 'dart:convert';

class CompletedCV {
  final String id;
  final String jobTitle;
  final String templateId;
  final String pdfPath;
  final String? thumbnailPath;
  final DateTime generatedAt;

  const CompletedCV({
    required this.id,
    required this.jobTitle,
    required this.templateId,
    required this.pdfPath,
    this.thumbnailPath,
    required this.generatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'jobTitle': jobTitle,
    'templateId': templateId,
    'pdfPath': pdfPath,
    'thumbnailPath': thumbnailPath,
    'generatedAt': generatedAt.toIso8601String(),
  };

  factory CompletedCV.fromJson(Map<String, dynamic> json) => CompletedCV(
    id: json['id'] as String,
    jobTitle: json['jobTitle'] as String,
    templateId: json['templateId'] as String,
    pdfPath: json['pdfPath'] as String,
    thumbnailPath: json['thumbnailPath'] as String?,
    generatedAt: DateTime.parse(json['generatedAt'] as String),
  );

  static List<CompletedCV> listFromJsonString(String jsonString) {
    final list = jsonDecode(jsonString) as List;
    return list.map((e) => CompletedCV.fromJson(e as Map<String, dynamic>)).toList();
  }

  static String listToJsonString(List<CompletedCV> cvs) {
    return jsonEncode(cvs.map((e) => e.toJson()).toList());
  }
}

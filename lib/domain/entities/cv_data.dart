import 'package:equatable/equatable.dart';
import 'user_profile.dart'; // Import existing entities

class CVData extends Equatable {
  final String id;
  final UserProfile userProfile;
  final String generatedSummary;
  final List<String> tailoredSkills;
  final String styleId;
  final DateTime createdAt;
  final String jobTitle;
  final String language;

  const CVData({
    required this.id,
    required this.userProfile,
    required this.generatedSummary,
    required this.tailoredSkills,
    required this.styleId,
    required this.createdAt,
    required this.jobTitle,
    this.language = 'id',
  });

  CVData copyWith({
    String? id,
    UserProfile? userProfile,
    String? generatedSummary,
    List<String>? tailoredSkills,
    String? styleId,
    DateTime? createdAt,
    String? jobTitle,
    String? language,
  }) {
    return CVData(
      id: id ?? this.id,
      userProfile: userProfile ?? this.userProfile,
      generatedSummary: generatedSummary ?? this.generatedSummary,
      tailoredSkills: tailoredSkills ?? this.tailoredSkills,
      styleId: styleId ?? this.styleId,
      createdAt: createdAt ?? this.createdAt,
      jobTitle: jobTitle ?? this.jobTitle,
      language: language ?? this.language,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userProfile': userProfile.toJson(),
      'generatedSummary': generatedSummary,
      'tailoredSkills': tailoredSkills,
      'styleId': styleId,
      'createdAt': createdAt.toIso8601String(),
      'jobTitle': jobTitle,
      'language': language,
    };
  }

  factory CVData.fromJson(Map<String, dynamic> json) {
    return CVData(
      id: json['id'] as String,
      userProfile: UserProfile.fromJson(json['userProfile'] as Map<String, dynamic>),
      generatedSummary: json['generatedSummary'] as String,
      tailoredSkills: (json['tailoredSkills'] as List<dynamic>).map((e) => e as String).toList(),
      styleId: json['styleId'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      jobTitle: json['jobTitle'] as String? ?? 'Untitled Job', // Fallback for old data
      language: json['language'] as String? ?? 'id', // Fallback
    );
  }

  @override
  List<Object?> get props => [id, userProfile, generatedSummary, tailoredSkills, styleId, createdAt, jobTitle, language];
}

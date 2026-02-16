import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../../drafts/providers/draft_provider.dart';
import '../../profile/providers/profile_provider.dart';
import 'dart:math';

/// Calculate user level based on profile data and CV count
String calculateUserLevel(UserProfile? profile, List<dynamic> drafts) {
  int score = 0;
  
  if (profile == null) {
    return "Rookie Job Seeker";
  }
  
  // Profile completion (0-40 points)
  final completion = calculateProfileCompletion(profile);
  score += (completion / 100 * 40).round();
  
  // CV count (0-30 points) - 10 points per CV, max 30
  score += min(drafts.length * 10, 30);
  
  // Experience weight (0-30 points) - 5 points per experience, max 30
  score += min(profile.experience.length * 5, 30);
  
  // Determine level
  if (score < 30) return "Rookie Job Seeker";
  if (score < 70) return "Mid-Level Professional";
  return "Expert Career Builder";
}


/// Calculate profile completion percentage
int calculateProfileCompletion(UserProfile? profile) {
  if (profile == null) return 0;
  
  int completed = 0;
  int total = 6; // Total sections to complete
  
  // Personal Info (required fields)
  if (profile.fullName.isNotEmpty) completed++;
  if (profile.email.isNotEmpty) completed++;
  if (profile.phoneNumber != null && profile.phoneNumber!.isNotEmpty) completed++;
  
  // Experience
  if (profile.experience.isNotEmpty) completed++;
  
  // Education
  if (profile.education.isNotEmpty) completed++;
  
  // Skills
  if (profile.skills.isNotEmpty) completed++;
  
  // Certifications
  if (profile.certifications.isNotEmpty) completed++;
  
  return ((completed / total) * 100).round();
}

/// Provider for user level
final userLevelProvider = Provider<String>((ref) {
  final profile = ref.watch(masterProfileProvider);
  final draftsAsync = ref.watch(draftsProvider);
  
  final drafts = draftsAsync.when(
    data: (data) => data,
    loading: () => [],
    error: (_, __) => [],
  );
  
  return calculateUserLevel(profile, drafts);
});

/// Provider for profile completion percentage
final profileCompletionProvider = Provider<int>((ref) {
  final profile = ref.watch(masterProfileProvider);
  return calculateProfileCompletion(profile);
});

/// Provider for quick stats
final profileStatsProvider = Provider<Map<String, int>>((ref) {
  final profile = ref.watch(masterProfileProvider);
  final draftsAsync = ref.watch(draftsProvider);
  
  final cvCount = draftsAsync.when(
    data: (data) => data.length,
    loading: () => 0,
    error: (_, __) => 0,
  );
  
  return {
    'cvCount': cvCount,
    'experienceCount': profile?.experience.length ?? 0,
    'educationCount': profile?.education.length ?? 0,
    'skillsCount': profile?.skills.length ?? 0,
  };
});

/// Provider for weekly activity (CVs created per day for current week)
/// Returns a List<int> of size 7, where index 0 is Monday and 6 is Sunday.
final weeklyActivityProvider = Provider<List<int>>((ref) {
  final draftsAsync = ref.watch(draftsProvider);
  
  return draftsAsync.when(
    data: (drafts) {
      final now = DateTime.now();
      // Find the most recent Monday
      final monday = now.subtract(Duration(days: now.weekday - 1));
      final startOfWeek = DateTime(monday.year, monday.month, monday.day);
      final endOfWeek = startOfWeek.add(const Duration(days: 7));
      
      final activity = List<int>.filled(7, 0);
      
      for (final draft in drafts) {
        if (draft.createdAt.isAfter(startOfWeek) && draft.createdAt.isBefore(endOfWeek)) {
          // weekday is 1-7 (Mon-Sun), we want 0-6 index
          final index = draft.createdAt.weekday - 1;
          if (index >= 0 && index < 7) {
            activity[index]++;
          }
        }
      }
      
      return activity;
    },
    loading: () => List<int>.filled(7, 0),
    error: (_, __) => List<int>.filled(7, 0),
  );
});

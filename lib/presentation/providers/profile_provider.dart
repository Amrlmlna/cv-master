import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../domain/entities/user_profile.dart';

// Provides the "Master" profile data (persisted across sessions ideally)
final masterProfileProvider = StateNotifierProvider<MasterProfileNotifier, UserProfile?>((ref) {
  return MasterProfileNotifier();
});

class MasterProfileNotifier extends StateNotifier<UserProfile?> {
  MasterProfileNotifier() : super(null);

  // Initialize with some dummy data for testing if empty, or load from storage
  // In a real app, this would be an async 'load()' method
  void loadProfile() {
    // Simulating loading a saved profile (if any)
    // For now, we start null so user has to enter it once.
    // Or we could seed it for demo.
  }

  void saveProfile(UserProfile profile) {
    state = profile;
    // TODO: Persist to SharedPreferences or Local Database
  }

  void updatePersonalInfo({
    required String fullName,
    required String email,
    required String phoneNumber,
    required String location,
  }) {
    final current = state ?? const UserProfile(
      fullName: '', 
      email: '',
      experience: [],
      education: [],
      skills: [],
    );

    state = current.copyWith(
      fullName: fullName,
      email: email,
      phoneNumber: phoneNumber,
      location: location,
    );
    // TODO: Auto-save
  }

  void updateExperience(List<Experience> experience) {
     if (state == null) return;
     state = state!.copyWith(experience: experience);
     // TODO: Auto-save
  }

  void updateEducation(List<Education> education) {
     if (state == null) return;
     state = state!.copyWith(education: education);
     // TODO: Auto-save
  }
  
  void updateSkills(List<String> skills) {
     if (state == null) return;
     state = state!.copyWith(skills: skills);
     // TODO: Auto-save
  }
}

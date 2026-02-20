import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import '../../auth/providers/auth_state_provider.dart';
import '../providers/profile_provider.dart';

class ProfileState {
  final UserProfile? initialProfile;
  final UserProfile currentProfile;
  final bool isSaving;

  ProfileState({
    required this.initialProfile,
    required this.currentProfile,
    this.isSaving = false,
  });

  bool get hasChanges {
    if (initialProfile == null) {
      // If no initial profile, check if current profile has any data
      return currentProfile.fullName.isNotEmpty ||
          currentProfile.email.isNotEmpty ||
          (currentProfile.phoneNumber?.isNotEmpty ?? false) ||
          (currentProfile.location?.isNotEmpty ?? false) ||
          currentProfile.experience.isNotEmpty ||
          currentProfile.education.isNotEmpty ||
          currentProfile.skills.isNotEmpty ||
          currentProfile.certifications.isNotEmpty;
    }
    return initialProfile != currentProfile;
  }

  ProfileState copyWith({
    UserProfile? initialProfile,
    UserProfile? currentProfile,
    bool? isSaving,
  }) {
    return ProfileState(
      initialProfile: initialProfile ?? this.initialProfile,
      currentProfile: currentProfile ?? this.currentProfile,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}

class ProfileController extends StateNotifier<ProfileState> {
  final Ref ref;

  ProfileController(this.ref)
      : super(ProfileState(
          initialProfile: null,
          currentProfile: const UserProfile(
            fullName: '',
            email: '',
            experience: [],
            education: [],
            skills: [],
            certifications: [],
          ),
        )) {
    _init();
  }

  void _init() {
    final masterProfile = ref.read(masterProfileProvider);
    if (masterProfile != null) {
      state = ProfileState(
        initialProfile: masterProfile,
        currentProfile: masterProfile,
      );
    }
    
    // Listen to master profile changes to keep sync if it changes externally
    ref.listen(masterProfileProvider, (previous, next) {
      if (next != null && next != state.initialProfile) {
        // Only update if we are not in the middle of editing? 
        // Or should we overwrite? Usually if master changes, we should update initial.
        // If user has unsaved changes, we might have a conflict, but for now let's simple sync.
        if (!state.hasChanges) {
           state = state.copyWith(
            initialProfile: next,
            currentProfile: next,
          );
        } else {
           // Just update initial so hasChanges calculation is correct against new master?
           // Or keep old initial? Let's update initial.
           state = state.copyWith(initialProfile: next);
        }
      }
    });
  }

  void updateName(String name) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(fullName: name),
    );
  }

  void updateEmail(String email) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(email: email),
    );
  }

  void updatePhone(String phone) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(phoneNumber: phone),
    );
  }

  void updateLocation(String location) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(location: location),
    );
  }

  void updateExperience(List<Experience> experience) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(experience: experience),
    );
  }

  void updateEducation(List<Education> education) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(education: education),
    );
  }

  void updateSkills(List<String> skills) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(skills: skills),
    );
  }

  void updateCertifications(List<Certification> certifications) {
    state = state.copyWith(
      currentProfile: state.currentProfile.copyWith(certifications: certifications),
    );
  }

  void importProfile(UserProfile importedProfile) {
    final current = state.currentProfile;
    
    final newProfile = current.copyWith(
      fullName: current.fullName.isEmpty ? importedProfile.fullName : current.fullName,
      email: current.email.isEmpty ? importedProfile.email : current.email,
      phoneNumber: (current.phoneNumber == null || current.phoneNumber!.isEmpty) 
          ? importedProfile.phoneNumber 
          : current.phoneNumber,
      location: (current.location == null || current.location!.isEmpty)
          ? importedProfile.location
          : current.location,
      experience: [...current.experience, ...importedProfile.experience],
      education: [...current.education, ...importedProfile.education],
      skills: {...current.skills, ...importedProfile.skills}.toList(),
      certifications: [...current.certifications, ...importedProfile.certifications],
    );

    state = state.copyWith(currentProfile: newProfile);
  }

  Future<bool> saveProfile() async {
    if (state.currentProfile.fullName.isEmpty) {
      return false; // Validation failed
    }

    state = state.copyWith(isSaving: true);
    try {
      await ref.read(masterProfileProvider.notifier).saveProfile(state.currentProfile);
      // Update initial to match current after save
      state = state.copyWith(
        initialProfile: state.currentProfile,
        isSaving: false,
      );
      return true;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      rethrow;
    }
  }

  Future<void> deleteAccount() async {
    state = state.copyWith(isSaving: true);
    try {
      await ref.read(authRepositoryProvider).deleteAccount();
      await ref.read(masterProfileProvider.notifier).clearProfile();
    } finally {
      state = state.copyWith(isSaving: false);
    }
  }

  void discardChanges() {
    state = state.copyWith(
      currentProfile: state.initialProfile,
    );
  }
}

final profileControllerProvider = StateNotifierProvider.autoDispose<ProfileController, ProfileState>((ref) {
  return ProfileController(ref);
});

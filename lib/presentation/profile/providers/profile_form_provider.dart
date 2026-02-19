import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/entities/user_profile.dart';
import 'profile_form_state.dart';
import 'profile_provider.dart';
import '../../auth/providers/auth_state_provider.dart';

class ProfileFormNotifier extends StateNotifier<ProfileFormState> {
  final Ref _ref;

  ProfileFormNotifier(this._ref) : super(ProfileFormState.initial()) {
    _initFromMaster();
  }

  void _initFromMaster() {
    final master = _ref.read(masterProfileProvider);
    if (master != null) {
      state = state.copyWith(
        profile: master,
        isInitialLoad: false,
      );
    }
  }

  void updateProfile(UserProfile newProfile) {
    state = state.copyWith(profile: newProfile, isInitialLoad: false);
  }

  void updatePersonalInfo({
    String? fullName,
    String? email,
    String? phoneNumber,
    String? location,
  }) {
    state = state.copyWith(
      profile: state.profile.copyWith(
        fullName: fullName,
        email: email,
        phoneNumber: phoneNumber,
        location: location,
      ),
      isInitialLoad: false,
    );
  }

  void updateExperience(List<Experience> experience) {
    state = state.copyWith(
      profile: state.profile.copyWith(experience: experience),
      isInitialLoad: false,
    );
  }

  void updateEducation(List<Education> education) {
    state = state.copyWith(
      profile: state.profile.copyWith(education: education),
      isInitialLoad: false,
    );
  }

  void updateSkills(List<String> skills) {
    state = state.copyWith(
      profile: state.profile.copyWith(skills: skills),
      isInitialLoad: false,
    );
  }

  void updateCertifications(List<Certification> certifications) {
    state = state.copyWith(
      profile: state.profile.copyWith(certifications: certifications),
      isInitialLoad: false,
    );
  }

  void setSaving(bool value) => state = state.copyWith(isSaving: value);

  Future<void> saveProfile() async {
    setSaving(true);
    try {
      await _ref.read(masterProfileProvider.notifier).saveProfile(state.profile);
    } finally {
      setSaving(false);
    }
  }

  Future<void> deleteAccount() async {
    setSaving(true);
    try {
      await _ref.read(authRepositoryProvider).deleteAccount();
      await _ref.read(masterProfileProvider.notifier).clearProfile();
    } finally {
      setSaving(false);
    }
  }

  bool hasChanges() {
    final master = _ref.read(masterProfileProvider);
    if (master == null) {
      return state.profile.fullName.isNotEmpty ||
          state.profile.experience.isNotEmpty ||
          state.profile.education.isNotEmpty;
    }
    return state.profile != master;
  }
}

final profileFormStateProvider = StateNotifierProvider<ProfileFormNotifier, ProfileFormState>((ref) {
  return ProfileFormNotifier(ref);
});

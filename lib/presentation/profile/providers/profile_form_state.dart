import 'package:equatable/equatable.dart';
import '../../../domain/entities/user_profile.dart';

class ProfileFormState extends Equatable {
  final UserProfile profile;
  final bool isSaving;
  final bool isInitialLoad;

  const ProfileFormState({
    required this.profile,
    this.isSaving = false,
    this.isInitialLoad = true,
  });

  factory ProfileFormState.initial() {
    return const ProfileFormState(
      profile: UserProfile(
        fullName: '',
        email: '',
        experience: [],
        education: [],
        certifications: [],
        skills: [],
      ),
    );
  }

  ProfileFormState copyWith({
    UserProfile? profile,
    bool? isSaving,
    bool? isInitialLoad,
  }) {
    return ProfileFormState(
      profile: profile ?? this.profile,
      isSaving: isSaving ?? this.isSaving,
      isInitialLoad: isInitialLoad ?? this.isInitialLoad,
    );
  }

  @override
  List<Object?> get props => [profile, isSaving, isInitialLoad];
}

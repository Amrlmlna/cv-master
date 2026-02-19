import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/user_profile.dart';
import '../providers/profile_unsaved_changes_provider.dart';
import '../widgets/personal_info_form.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../widgets/experience_list_form.dart';
import '../widgets/education_list_form.dart';
import '../widgets/skills_input_form.dart';
import '../widgets/certification_list_form.dart';
import '../widgets/section_card.dart';
import '../widgets/profile_action_buttons.dart';
import '../widgets/danger_zone.dart';
import '../../../core/utils/custom_snackbar.dart';
import '../widgets/profile_header.dart';
import '../widgets/delete_account_dialog.dart';
import '../providers/profile_form_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(() => _updatePersonal());
    _emailController.addListener(() => _updatePersonal());
    _phoneController.addListener(() => _updatePersonal());
    _locationController.addListener(() => _updatePersonal());
  }

  void _updatePersonal() {
    ref.read(profileFormStateProvider.notifier).updatePersonalInfo(
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      _loadInitial();
      _isInit = false;
    }
  }

  void _loadInitial() {
    final formProfile = ref.read(profileFormStateProvider).profile;
    _nameController.text = formProfile.fullName;
    _emailController.text = formProfile.email;
    _phoneController.text = formProfile.phoneNumber ?? '';
    _locationController.text = formProfile.location ?? '';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }



  void _handleImportSuccess(UserProfile importedProfile) {
    // Merge logic remains but triggered on the notifier
    final current = ref.read(profileFormStateProvider).profile;
    
    final merged = current.copyWith(
      fullName: current.fullName.isEmpty ? importedProfile.fullName : null,
      email: current.email.isEmpty ? importedProfile.email : null,
      phoneNumber: (current.phoneNumber == null || current.phoneNumber!.isEmpty) ? importedProfile.phoneNumber : null,
      location: (current.location == null || current.location!.isEmpty) ? importedProfile.location : null,
      experience: [...current.experience, ...importedProfile.experience],
      education: [...current.education, ...importedProfile.education],
      certifications: [...current.certifications, ...importedProfile.certifications],
      skills: {...current.skills, ...importedProfile.skills}.toList(),
    );

    ref.read(profileFormStateProvider.notifier).updateProfile(merged);
    _loadInitial(); // Re-sync controllers

    CustomSnackBar.showSuccess(
      context,
      AppLocalizations.of(context)!.importSuccessMessage(
        importedProfile.experience.length,
        importedProfile.education.length,
        importedProfile.skills.length,
      ),
    );
  }

  Future<void> _saveProfile() async {
    if (_nameController.text.isEmpty) {
      CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.fillNameError);
      return;
    }

    try {
      await ref.read(profileFormStateProvider.notifier).saveProfile();
      if (mounted) {
        CustomSnackBar.showSuccess(context, AppLocalizations.of(context)!.profileSavedSuccess);
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.profileSaveError(e.toString()));
      }
    }
  }

  Future<void> _confirmAccountDeletion() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => const DeleteAccountDialog(),
    );

    if (result == true) {
      _performDeletion();
    }
  }

  Future<void> _performDeletion() async {
    try {
      await ref.read(profileFormStateProvider.notifier).deleteAccount();
      if (mounted) {
        CustomSnackBar.showSuccess(context, 'Account successfully deleted. Goodbye!');
        context.go('/');
      }
    } catch (e) {
      if (mounted) {
        CustomSnackBar.showError(context, 'Failed to delete account: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final formState = ref.watch(profileFormStateProvider);
    final hasChanges = ref.read(profileFormStateProvider.notifier).hasChanges();
    
    // Sync unsaved changes provider for any listeners
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        ref.read(profileUnsavedChangesProvider.notifier).state = hasChanges;
      }
    });

    return Scaffold(
      body: PopScope(
        canPop: !hasChanges || formState.isSaving,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          final shouldPop = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(AppLocalizations.of(context)!.saveChangesTitle),
              content: Text(AppLocalizations.of(context)!.saveChangesMessage),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: Text(AppLocalizations.of(context)!.exitWithoutSaving, style: const TextStyle(color: Colors.red)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: Text(AppLocalizations.of(context)!.stayHere),
                ),
              ],
            ),
          ) ?? false;
          
          if (shouldPop && mounted) {
            Navigator.of(context).pop();
          }
        },
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Column(
              children: [
                ProfileHeader(onImportSuccess: _handleImportSuccess),

                SectionCard(
                  title: AppLocalizations.of(context)!.personalInfo,
                  icon: Icons.person_outline,
                  child: PersonalInfoForm(
                    nameController: _nameController,
                    emailController: _emailController,
                    phoneController: _phoneController,
                    locationController: _locationController,
                  ),
                ),
                
                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.experience,
                  icon: Icons.work_outline,
                  child: ExperienceListForm(
                    experiences: formState.profile.experience,
                    onChanged: (val) => ref.read(profileFormStateProvider.notifier).updateExperience(val),
                  ),
                ),

                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.educationHistory,
                  icon: Icons.school_outlined,
                  child: EducationListForm(
                    education: formState.profile.education,
                    onChanged: (val) => ref.read(profileFormStateProvider.notifier).updateEducation(val),
                  ),
                ),

                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.certifications,
                  icon: Icons.card_membership,
                  child: CertificationListForm(
                    certifications: formState.profile.certifications,
                    onChanged: (val) => ref.read(profileFormStateProvider.notifier).updateCertifications(val),
                  ),
                ),

                const SizedBox(height: 24),

                SectionCard(
                  title: AppLocalizations.of(context)!.skills,
                  icon: Icons.code,
                  child: SkillsInputForm(
                    skills: formState.profile.skills,
                    onChanged: (val) => ref.read(profileFormStateProvider.notifier).updateSkills(val),
                  ),
                ),

                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Legal Information'),
                  subtitle: const Text('Privacy Policy and Terms'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/legal'),
                ),

                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 24),
                
                DangerZone(
                  isSaving: formState.isSaving,
                  onConfirmDeletion: _confirmAccountDeletion,
                ),

                const SizedBox(height: 32),

                ProfileActionButtons(
                  onSave: _saveProfile,
                  canSave: hasChanges && !formState.isSaving,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

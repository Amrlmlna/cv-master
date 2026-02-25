import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/location_picker.dart';
import '../providers/profile_provider.dart';
import '../../../core/services/storage_service.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class PersonalInfoForm extends ConsumerStatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;
  final TextEditingController locationController;

  const PersonalInfoForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.locationController,
  });

  @override
  ConsumerState<PersonalInfoForm> createState() => _PersonalInfoFormState();
}

class _PersonalInfoFormState extends ConsumerState<PersonalInfoForm> {
  final _picker = ImagePicker();
  final _storageService = StorageService();
  bool _isUploading = false;

  Future<void> _pickAndUploadImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 75,
      );

      if (image == null) return;

      setState(() => _isUploading = true);

      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please login to upload photo')),
          );
        }
        return;
      }

      final downloadUrl = await _storageService.uploadProfilePhoto(
        File(image.path),
        user.uid,
      );

      if (downloadUrl != null && mounted) {
        ref.read(profileControllerProvider.notifier).updatePhoto(downloadUrl);
      }
    } finally {
      if (mounted) {
        setState(() => _isUploading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final photoUrl = ref.watch(profileControllerProvider).currentProfile.photoUrl;

    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              GestureDetector(
                onTap: _pickAndUploadImage,
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.grey[850],
                  backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                  child: photoUrl == null && !_isUploading
                      ? const Icon(Icons.person, size: 50, color: Colors.grey)
                      : null,
                ),
              ),
              if (_isUploading)
                const Positioned.fill(
                  child: Center(
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: _pickAndUploadImage,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, size: 20, color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        CustomTextFormField(
          controller: widget.nameController,
          labelText: AppLocalizations.of(context)!.fullName,
          prefixIcon: Icons.person_outline,
          validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
          textInputAction: TextInputAction.next,
          isDark: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: widget.emailController,
          labelText: AppLocalizations.of(context)!.email,
          prefixIcon: Icons.email_outlined,
          validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.next,
          isDark: true,
        ),
        const SizedBox(height: 16),
        CustomTextFormField(
          controller: widget.phoneController,
          labelText: AppLocalizations.of(context)!.phoneNumber,
          prefixIcon: Icons.phone_outlined,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          isDark: true,
        ),
        const SizedBox(height: 16),
        LocationPicker(
          controller: widget.locationController,
          isDark: true,
        ),
      ],
    );
  }
}

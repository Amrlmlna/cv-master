import 'package:flutter/material.dart';
import '../../../domain/entities/user_profile.dart';
import 'import_cv_button.dart';

class ProfileHeader extends StatelessWidget {
  final Function(UserProfile) onImportSuccess;

  const ProfileHeader({
    super.key,
    required this.onImportSuccess,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 16),
        // Add User Avatar here if needed in the future
        const CircleAvatar(
          radius: 40,
          backgroundColor: Colors.white10,
          child: Icon(Icons.person, size: 40, color: Colors.white54),
        ),
        const SizedBox(height: 24),
        ImportCVButton(
          onImportSuccess: onImportSuccess,
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}

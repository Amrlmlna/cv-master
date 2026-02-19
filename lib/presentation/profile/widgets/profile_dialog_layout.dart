import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ProfileDialogLayout extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback onSave;
  final bool isSaveEnabled;

  const ProfileDialogLayout({
    super.key,
    required this.title,
    required this.child,
    required this.onSave,
    this.isSaveEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E), // Dark Card
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text(
        title,
        style: const TextStyle(
          color: Colors.white, 
          fontWeight: FontWeight.w900, 
          fontSize: 18, 
          letterSpacing: 1.0,
        ),
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: child,
        ),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), 
          style: TextButton.styleFrom(foregroundColor: Colors.white54),
          child: Text(AppLocalizations.of(context)!.cancelAllCaps),
        ),
        ElevatedButton(
          onPressed: isSaveEnabled ? onSave : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          child: Text(
            AppLocalizations.of(context)!.saveAllCaps, 
            style: const TextStyle(fontWeight: FontWeight.bold)
          ),
        ),
      ],
    );
  }
}

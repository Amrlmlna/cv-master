import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class UnsavedChangesDialog extends StatelessWidget {
  final VoidCallback onSave;
  final VoidCallback onDiscard;

  const UnsavedChangesDialog({
    super.key,
    required this.onSave,
    required this.onDiscard,
  });

  static Future<bool?> show(
    BuildContext context, {
    required VoidCallback onSave,
    required VoidCallback onDiscard,
  }) {
    return showDialog<bool>(
      context: context,
      builder: (context) =>
          UnsavedChangesDialog(onSave: onSave, onDiscard: onDiscard),
    );
  }

  @override
  Widget build(BuildContext context) {
    final localization = AppLocalizations.of(context)!;

    return AlertDialog(
      backgroundColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        localization.saveChangesTitle,
        style: GoogleFonts.inter(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: 20,
        ),
      ),
      content: Text(
        localization.saveChangesMessage,
        style: GoogleFonts.inter(color: Colors.white70, fontSize: 15),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      actions: [
        Row(
          children: [
            Expanded(
              child: TextButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  onDiscard();
                },
                style: TextButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: Text(
                  localization.exitWithoutSaving,
                  style: GoogleFonts.inter(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context, true);
                  onSave();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  localization.save,
                  style: GoogleFonts.inter(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class SummarySection extends StatelessWidget {
  final TextEditingController controller;
  final bool isDark;

  const SummarySection({
    super.key,
    required this.controller,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextFormField(
          controller: controller,
          maxLines: 5,
          decoration: InputDecoration(
            hintText: AppLocalizations.of(context)!.summaryHint,
            filled: true,
            fillColor: isDark ? Colors.grey[800] : Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return AppLocalizations.of(context)!.summaryEmpty;
            }
            return null;
          },
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import 'education_dialog.dart';
import 'profile_section_list.dart';
import 'profile_entry_card.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class EducationListForm extends StatelessWidget {
  final List<Education> education;
  final Function(List<Education>) onChanged;
  final bool isDark;

  const EducationListForm({
    super.key,
    required this.education,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = isDark || Theme.of(context).brightness == Brightness.dark;

    return ProfileSectionList<Education>(
      items: education,
      title: AppLocalizations.of(context)!.educationHistory,
      emptyMessage: AppLocalizations.of(context)!.noEducation,
      isDark: effectiveIsDark,
      onChanged: onChanged,
      onAdd: (existing) => showDialog<Education>(
        context: context,
        builder: (context) => EducationDialog(existing: existing),
      ),
      itemBuilder: (edu, index, onEdit, onDelete) => ProfileEntryCard(
        title: edu.schoolName,
        subtitle: '${edu.degree}\n${edu.startDate} - ${edu.endDate ?? AppLocalizations.of(context)!.present}',
        onTap: onEdit,
        onDelete: onDelete,
        isDark: effectiveIsDark,
      ),
    );
  }
}

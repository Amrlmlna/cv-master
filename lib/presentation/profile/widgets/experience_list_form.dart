import 'package:flutter/material.dart';
import '../../../../domain/entities/user_profile.dart';
import 'experience_dialog.dart';
import 'profile_section_list.dart';
import 'profile_entry_card.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class ExperienceListForm extends StatelessWidget {
  final List<Experience> experiences;
  final Function(List<Experience>) onChanged;
  final bool isDark;

  const ExperienceListForm({
    super.key,
    required this.experiences,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = isDark || Theme.of(context).brightness == Brightness.dark;

    return ProfileSectionList<Experience>(
      items: experiences,
      title: AppLocalizations.of(context)!.workExperience,
      emptyMessage: AppLocalizations.of(context)!.noExperience,
      isDark: effectiveIsDark,
      onChanged: onChanged,
      onAdd: (existing) => showDialog<Experience>(
        context: context,
        builder: (context) => ExperienceDialog(existing: existing),
      ),
      itemBuilder: (exp, index, onEdit, onDelete) => ProfileEntryCard(
        title: exp.jobTitle,
        subtitle: '${exp.companyName}\n${exp.startDate} - ${exp.endDate ?? AppLocalizations.of(context)!.present}',
        onTap: onEdit,
        onDelete: onDelete,
        isDark: effectiveIsDark,
      ),
    );
  }
}

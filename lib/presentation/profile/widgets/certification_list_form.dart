import 'package:flutter/material.dart';
import '../../../../domain/entities/certification.dart';
import 'certification_dialog.dart';
import 'profile_section_list.dart';
import 'profile_entry_card.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class CertificationListForm extends StatelessWidget {
  final List<Certification> certifications;
  final Function(List<Certification>) onChanged;
  final bool isDark;

  const CertificationListForm({
    super.key,
    required this.certifications,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = isDark || Theme.of(context).brightness == Brightness.dark;

    return ProfileSectionList<Certification>(
      items: certifications,
      title: AppLocalizations.of(context)!.certificationsLicenses,
      emptyMessage: AppLocalizations.of(context)!.noCertifications,
      isDark: effectiveIsDark,
      onChanged: onChanged,
      onAdd: (existing) => showDialog<Certification>(
        context: context,
        builder: (context) => CertificationDialog(existing: existing),
      ),
      itemBuilder: (cert, index, onEdit, onDelete) => ProfileEntryCard(
        title: cert.name,
        subtitle: '${cert.issuer} • ${cert.date.year}',
        onTap: onEdit,
        onDelete: onDelete,
        isDark: effectiveIsDark,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../../../domain/entities/certification.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'profile_dialog_layout.dart';
import '../../common/widgets/custom_text_form_field.dart';

class CertificationDialog extends StatefulWidget {
  final Certification? existing;

  const CertificationDialog({super.key, this.existing});

  @override
  State<CertificationDialog> createState() => _CertificationDialogState();
}

class _CertificationDialogState extends State<CertificationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameCtrl;
  late TextEditingController _issuerCtrl;
  late TextEditingController _dateCtrl;
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    _issuerCtrl = TextEditingController(text: widget.existing?.issuer ?? '');
    if (widget.existing != null) {
      _selectedDate = widget.existing!.date;
    }
    _dateCtrl = TextEditingController(text: _formatDate(_selectedDate));
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _issuerCtrl.dispose();
    _dateCtrl.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateCtrl.text = _formatDate(_selectedDate);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileDialogLayout(
      title: widget.existing == null 
          ? AppLocalizations.of(context)!.addCertification 
          : AppLocalizations.of(context)!.editCertification,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          final cert = Certification(
            id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            name: _nameCtrl.text,
            issuer: _issuerCtrl.text,
            date: _selectedDate,
          );
          Navigator.pop(context, cert);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CustomTextFormField(
              controller: _nameCtrl,
              labelText: AppLocalizations.of(context)!.certificationName,
              hintText: 'AWS Certified Solutions Architect',
              isDark: true,
              validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _issuerCtrl,
              labelText: AppLocalizations.of(context)!.issuer,
              hintText: 'Amazon Web Services',
              isDark: true,
              validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
            ),
            const SizedBox(height: 16),
            
            CustomTextFormField(
              controller: _dateCtrl,
              labelText: AppLocalizations.of(context)!.dateLabel,
              hintText: AppLocalizations.of(context)!.selectDate,
              isDark: true,
              readOnly: true,
              prefixIcon: Icons.calendar_today,
              onTap: () => _pickDate(context),
              validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
            ),
          ],
        ),
      ),
    );
  }
}

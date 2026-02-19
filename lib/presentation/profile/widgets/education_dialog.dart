import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../../domain/entities/user_profile.dart';
import '../../common/widgets/custom_text_form_field.dart';
import '../../common/widgets/university_picker.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'profile_dialog_layout.dart';

class EducationDialog extends StatefulWidget {
  final Education? existing;

  const EducationDialog({super.key, this.existing});

  @override
  State<EducationDialog> createState() => _EducationDialogState();
}

class _EducationDialogState extends State<EducationDialog> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _schoolCtrl;
  late TextEditingController _degreeCtrl;
  late TextEditingController _startCtrl;
  late TextEditingController _endCtrl;

  @override
  void initState() {
    super.initState();
    _schoolCtrl = TextEditingController(text: widget.existing?.schoolName);
    _degreeCtrl = TextEditingController(text: widget.existing?.degree);
    _startCtrl = TextEditingController(text: widget.existing?.startDate);
    _endCtrl = TextEditingController(text: widget.existing?.endDate);
  }

  @override
  void dispose() {
    _schoolCtrl.dispose();
    _degreeCtrl.dispose();
    _startCtrl.dispose();
    _endCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1980),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.white,
              onPrimary: Colors.black,
              surface: const Color(0xFF1E1E1E),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      controller.text = DateFormat('MMM yyyy').format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ProfileDialogLayout(
      title: widget.existing == null 
          ? AppLocalizations.of(context)!.addEducation 
          : AppLocalizations.of(context)!.editEducation,
      onSave: () {
        if (_formKey.currentState!.validate()) {
          final edu = Education(
            id: widget.existing?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
            schoolName: _schoolCtrl.text,
            degree: _degreeCtrl.text,
            startDate: _startCtrl.text,
            endDate: _endCtrl.text.isEmpty ? null : _endCtrl.text,
          );
          Navigator.pop(context, edu);
        }
      },
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            UniversityPicker(
              controller: _schoolCtrl,
              isDark: true,
            ),
            const SizedBox(height: 16),
            CustomTextFormField(
              controller: _degreeCtrl,
              labelText: AppLocalizations.of(context)!.degree,
              hintText: AppLocalizations.of(context)!.degreeHint,
              isDark: true,
              validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: CustomTextFormField(
                    controller: _startCtrl,
                    labelText: AppLocalizations.of(context)!.startDate,
                    hintText: AppLocalizations.of(context)!.year,
                    isDark: true,
                    readOnly: true,
                    prefixIcon: Icons.calendar_today,
                    onTap: () => _pickDate(_startCtrl),
                    validator: (v) => v!.isEmpty ? AppLocalizations.of(context)!.requiredField : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: CustomTextFormField(
                    controller: _endCtrl,
                    labelText: AppLocalizations.of(context)!.endDate,
                    hintText: AppLocalizations.of(context)!.year,
                    isDark: true,
                    readOnly: true,
                    prefixIcon: Icons.event,
                    onTap: () => _pickDate(_endCtrl),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

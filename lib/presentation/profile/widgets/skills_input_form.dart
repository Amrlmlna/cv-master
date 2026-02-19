import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../common/widgets/custom_text_form_field.dart';

class SkillsInputForm extends StatefulWidget {
  final List<String> skills;
  final Function(List<String>) onChanged;
  final bool isDark;

  const SkillsInputForm({
    super.key,
    required this.skills,
    required this.onChanged,
    this.isDark = false,
  });

  @override
  State<SkillsInputForm> createState() => _SkillsInputFormState();
}

class _SkillsInputFormState extends State<SkillsInputForm> {
  final _controller = TextEditingController();

  void _addSkill() {
    final text = _controller.text.trim();
    if (text.isNotEmpty && !widget.skills.contains(text)) {
      final newList = List<String>.from(widget.skills)..add(text);
      widget.onChanged(newList);
      _controller.clear();
    }
  }

  void _removeSkill(String skill) {
    final newList = List<String>.from(widget.skills)..remove(skill);
    widget.onChanged(newList);
  }

  @override
  Widget build(BuildContext context) {
    final effectiveIsDark = widget.isDark || Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: _controller,
                labelText: AppLocalizations.of(context)!.addSkill,
                hintText: AppLocalizations.of(context)!.skillHint,
                isDark: effectiveIsDark,
                onFieldSubmitted: (_) => _addSkill(),
              ),
            ),
            const SizedBox(width: 8),
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: IconButton.filled(
                onPressed: _addSkill,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(
                  backgroundColor: effectiveIsDark ? Colors.white : Theme.of(context).primaryColor,
                  foregroundColor: effectiveIsDark ? Colors.black : Colors.white,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (widget.skills.isEmpty)
          Text(
            AppLocalizations.of(context)!.noSkills, 
            style: TextStyle(color: effectiveIsDark ? Colors.white54 : Colors.grey)
          )
        else
          Wrap(
            spacing: 8.0,
            runSpacing: 8.0,
            children: widget.skills.map((skill) => Chip(
              label: Text(skill),
              backgroundColor: effectiveIsDark ? const Color(0xFF2C2C2C) : Colors.grey[200],
              labelStyle: TextStyle(color: effectiveIsDark ? Colors.white : Colors.black),
              deleteIconColor: Colors.red,
              onDeleted: () => _removeSkill(skill),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              side: BorderSide.none,
            )).toList(),
          ),
      ],
    );
  }
}

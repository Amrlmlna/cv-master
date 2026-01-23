import 'package:flutter/material.dart';
import '../../profile/widgets/skills_input_form.dart';

class OnboardingSkillsStep extends StatelessWidget {
  final List<String> skills;
  final ValueChanged<List<String>> onChanged;

  const OnboardingSkillsStep({
    super.key,
    required this.skills,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skill Kamu Apa Aja?',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Tulis semua keahlianmu. AI akan menonjolkan skill yang paling sesuai dengan kebutuhan posisi yang kamu tuju.',
             style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 32),
          SkillsInputForm(
            skills: skills,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

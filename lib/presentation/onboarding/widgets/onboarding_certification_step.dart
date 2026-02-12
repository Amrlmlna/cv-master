import 'package:flutter/material.dart';
import '../../../domain/entities/certification.dart';
import '../../profile/widgets/certification_list_form.dart';

class OnboardingCertificationStep extends StatelessWidget {
  final List<Certification> certifications;
  final ValueChanged<List<Certification>> onChanged;

  const OnboardingCertificationStep({
    super.key,
    required this.certifications,
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
            'Sertifikasi & Lisensi',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
          ),
          const SizedBox(height: 8),
          const Text(
            'Masukkan sertifikasi, lisensi, atau penghargaan yang relevan. Ini bisa jadi nilai tambah besar.',
             style: TextStyle(color: Colors.grey, height: 1.5),
          ),
          const SizedBox(height: 32),
          CertificationListForm(
            certifications: certifications,
            onChanged: onChanged,
            isDark: true,
          ),
        ],
      ),
    );
  }
}

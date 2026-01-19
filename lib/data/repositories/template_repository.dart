import '../../domain/entities/cv_template.dart';

class TemplateRepository {
  /// The central registry of all available templates.
  /// To add a new template, simply add a new [CVTemplate] object to this list.
  static final List<CVTemplate> _allTemplates = [
    const CVTemplate(
      id: 'ATS',
      name: 'ATS-Friendly',
      description: 'Optimized for Applicant Tracking Systems. Simple and clean.',
      thumbnailPath: 'assets/templates/ats_preview.png', // Placeholder path
      tags: ['Simple', 'Professional'],
    ),
    const CVTemplate(
      id: 'Modern',
      name: 'Modern Tech',
      description: 'Sleek design with subtle accents, perfect for startups and tech roles.',
      thumbnailPath: 'assets/templates/modern_preview.png',
      tags: ['Tech', 'Sleek'],
    ),
    const CVTemplate(
      id: 'Creative',
      name: 'Creative Bold',
      description: 'Stand out with bold typography and unique layout.',
      thumbnailPath: 'assets/templates/creative_preview.png',
      isPremium: true,
      tags: ['Design', 'Bold'],
    ),
     const CVTemplate(
      id: 'Executive',
      name: 'Executive Suite',
      description: 'Professional and authoritative design for leadership roles.',
      thumbnailPath: 'assets/templates/executive_preview.png',
      isPremium: true,
      tags: ['Leadership', 'Formal'],
    ),
  ];

  static List<CVTemplate> getAllTemplates() {
    return _allTemplates;
  }

  static CVTemplate getTemplateById(String id) {
    return _allTemplates.firstWhere(
      (t) => t.id == id,
      orElse: () => _allTemplates.first,
    );
  }
}

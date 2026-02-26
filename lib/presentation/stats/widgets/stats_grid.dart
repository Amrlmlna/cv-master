import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class StatsGrid extends StatelessWidget {
  final Map<String, int> stats;
  final bool isDark;

  const StatsGrid({super.key, required this.stats, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final items = [
      {
        'label': AppLocalizations.of(context)!.totalCVs,
        'value': stats['cvCount'].toString(),
        'icon': Icons.description_outlined,
      },
      {
        'label': AppLocalizations.of(context)!.skills,
        'value': stats['skillsCount'].toString(),
        'icon': Icons.bolt_outlined,
      },
      {
        'label': AppLocalizations.of(context)!.experience,
        'value': stats['experienceCount'].toString(),
        'icon': Icons.work_outline,
      },
      {
        'label': AppLocalizations.of(context)!.educationHistory,
        'value': stats['educationCount'].toString(),
        'icon': Icons.school_outlined,
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E1E1E) : Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isDark ? Colors.white10 : Colors.grey.shade200,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(
                item['icon'] as IconData,
                size: 24,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item['value'] as String,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    item['label'] as String,
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.white54 : Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

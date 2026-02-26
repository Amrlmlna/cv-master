import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/locale_provider.dart';

class LanguageSelector extends ConsumerWidget {
  final String? manualLocaleOverride;
  final Function(String) onLocaleChanged;

  const LanguageSelector({
    super.key,
    required this.manualLocaleOverride,
    required this.onLocaleChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final globalLocale = ref.watch(localeNotifierProvider).languageCode;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[900] : Colors.grey[200],
        borderRadius: BorderRadius.circular(26),
      ),
      padding: const EdgeInsets.all(4),
      child: Row(
        children: [
          _buildLangOption(context, 'en', 'English', globalLocale),
          _buildLangOption(context, 'id', 'Bahasa Indonesia', globalLocale),
        ],
      ),
    );
  }

  Widget _buildLangOption(
    BuildContext context,
    String code,
    String label,
    String globalLocale,
  ) {
    final isSelected = (manualLocaleOverride ?? globalLocale) == code;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () => onLocaleChanged(code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? Colors.white : Colors.black)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(22),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected
                  ? (isDark ? Colors.black : Colors.white)
                  : (isDark ? Colors.white54 : Colors.black54),
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              fontSize: 13,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../home/providers/user_level_provider.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../widgets/user_level_card.dart';
import '../widgets/activity_chart.dart';
import '../widgets/stats_grid.dart';

class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userLevelKey = ref.watch(userLevelProvider);
    final stats = ref.watch(profileStatsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Helper to get localized user level
    String getLocalizedLevel(String key) {
      final l10n = AppLocalizations.of(context)!;
      switch (key) {
        case 'userLevelRookie': return l10n.userLevelRookie;
        case 'userLevelMid': return l10n.userLevelMid;
        case 'userLevelExpert': return l10n.userLevelExpert;
        default: return key;
      }
    }


    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.careerAnalytics),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. User Level Card
            UserLevelCard(level: getLocalizedLevel(userLevelKey), isDark: isDark),

            const SizedBox(height: 24),

            // 2. Activity Chart
            Text(
              AppLocalizations.of(context)!.activityOverview,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),
            ActivityChart(isDark: isDark),
            const SizedBox(height: 24),

            // 3. Stats Grid
            Text(
              AppLocalizations.of(context)!.keyMetrics,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 16),
            StatsGrid(stats: stats, isDark: isDark),
          ],
        ),
      ),
    );
  }
}

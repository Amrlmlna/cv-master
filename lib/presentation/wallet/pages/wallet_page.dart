import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import '../../templates/providers/template_provider.dart';

class WalletPage extends ConsumerWidget {
  const WalletPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final templatesAsync = ref.watch(templatesProvider);

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              Text(
                AppLocalizations.of(context)!.wallet,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                ),
              ),
              const SizedBox(height: 32),

              // Credit balance card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.white12),
                  color: Colors.white.withValues(alpha: 0.04),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.creditBalance,
                      style: TextStyle(
                        fontSize: 13,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        templatesAsync.when(
                          data: (templates) {
                            final totalCredits = templates.isNotEmpty
                                ? templates.first.userCredits
                                : 0;
                            return Text(
                              '$totalCredits',
                              style: const TextStyle(
                                fontSize: 48,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1,
                              ),
                            );
                          },
                          loading: () => const Text(
                            '—',
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, height: 1),
                          ),
                          error: (_, __) => const Text(
                            '0',
                            style: TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, height: 1),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Text(
                            AppLocalizations.of(context)!.credits,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.grey[400],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Placeholder for future: usage history, purchase buttons, etc.
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.receipt_long_outlined, size: 48, color: Colors.grey[700]),
                      const SizedBox(height: 16),
                      Text(
                        AppLocalizations.of(context)!.usageHistoryComingSoon,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

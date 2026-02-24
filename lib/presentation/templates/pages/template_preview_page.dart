import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../cv/providers/cv_download_provider.dart';
import '../providers/template_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../../core/services/payment_service.dart';
import '../../auth/utils/auth_guard.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class TemplatePreviewPage extends ConsumerStatefulWidget {
  const TemplatePreviewPage({super.key});

  @override
  ConsumerState<TemplatePreviewPage> createState() => _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends ConsumerState<TemplatePreviewPage> {
  String? _manualLocaleOverride;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _handleDownload() async {
    final creationState = ref.read(cvCreationProvider);
    final selectedStyleId = creationState.selectedStyle;
    final templates = ref.read(templatesProvider).value ?? [];
    final template = templates.firstWhere(
      (t) => t.id == selectedStyleId,
      orElse: () => templates.first,
    );

    if (template.isLocked) {
      if (mounted) {
        if (!AuthGuard.check(context,
            featureTitle: AppLocalizations.of(context)!.authWallBuyCredits,
            featureDescription: AppLocalizations.of(context)!.authWallBuyCreditsDesc)) return;

        final purchased = await PaymentService.presentPaywall();
        if (purchased) {
          ref.invalidate(templatesProvider);
        }
      }
      return;
    }

    final globalLocale = ref.read(localeNotifierProvider).languageCode;
    final effectiveLocale = _manualLocaleOverride ?? globalLocale;

    await ref.read(cvDownloadProvider.notifier).attemptDownload(
      context: context,
      styleId: selectedStyleId,
      locale: effectiveLocale,
    );
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(templatesProvider);
    final creationState = ref.watch(cvCreationProvider);
    final downloadState = ref.watch(cvDownloadProvider);
    final globalLocale = ref.watch(localeNotifierProvider).languageCode;
    final effectiveLocale = _manualLocaleOverride ?? globalLocale;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF121212) : Colors.grey[50],
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.previewCV),
        centerTitle: true,
      ),
      body: templatesAsync.when(
        data: (templates) {
          final template = templates.firstWhere(
            (t) => t.id == creationState.selectedStyle,
            orElse: () => templates.isNotEmpty ? templates.first : throw Exception('No template selected'),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AspectRatio(
                  aspectRatio: 0.7,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(16),
                      child: CachedNetworkImage(
                        imageUrl: template.thumbnailUrl,
                        cacheKey: template.id,
                        fit: BoxFit.cover,
                        memCacheHeight: 600,
                        maxHeightDiskCache: 800,
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.black),
                        ),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Language Selection
                Text(
                  AppLocalizations.of(context)!.cvLanguage,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, letterSpacing: 1),
                ),
                const SizedBox(height: 12),
                _buildLanguageSelector(),
                const SizedBox(height: 100), // Space for bottom button
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(AppLocalizations.of(context)!.templateLoadError(err.toString())),
              ElevatedButton(
                onPressed: () => ref.refresh(templatesProvider),
                child: Text(AppLocalizations.of(context)!.retry),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1A1A1A) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: SafeArea(
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: downloadState.status == DownloadStatus.generating ? null : _handleDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
              ),
              child: downloadState.status == DownloadStatus.generating
                ? const CircularProgressIndicator()
                : Text(
                    AppLocalizations.of(context)!.exportPdf,
                    style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1.2),
                  ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanguageSelector() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          _buildLangOption('en', 'English'),
          _buildLangOption('id', 'Bahasa Indonesia'),
        ],
      ),
    );
  }

  Widget _buildLangOption(String code, String label) {
    final globalLocale = ref.watch(localeNotifierProvider).languageCode;
    final isSelected = (_manualLocaleOverride ?? globalLocale) == code;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _manualLocaleOverride = code),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? Colors.black : Colors.transparent,
            borderRadius: BorderRadius.circular(26),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black54,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ),
      ),
    );
  }
}

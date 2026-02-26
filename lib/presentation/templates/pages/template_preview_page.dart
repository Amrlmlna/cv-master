import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../cv/providers/cv_generation_provider.dart';
import '../../cv/providers/cv_download_provider.dart';
import '../providers/template_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../../core/providers/locale_provider.dart';
import '../../../../core/services/payment_service.dart';
import '../../auth/utils/auth_guard.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

import '../widgets/template_carousel_preview.dart';
import '../widgets/language_selector.dart';
import '../widgets/photo_toggle_settings.dart';

class TemplatePreviewPage extends ConsumerStatefulWidget {
  const TemplatePreviewPage({super.key});

  @override
  ConsumerState<TemplatePreviewPage> createState() =>
      _TemplatePreviewPageState();
}

class _TemplatePreviewPageState extends ConsumerState<TemplatePreviewPage> {
  String? _manualLocaleOverride;
  bool _usePhoto = true;
  bool _isUploading = false;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
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
        if (!AuthGuard.check(
          context,
          featureTitle: AppLocalizations.of(context)!.authWallBuyCredits,
          featureDescription: AppLocalizations.of(
            context,
          )!.authWallBuyCreditsDesc,
        ))
          return;

        final purchased = await PaymentService.presentPaywall();
        if (purchased) {
          ref.invalidate(templatesProvider);
        }
      }
      return;
    }

    final globalLocale = ref.read(localeNotifierProvider).languageCode;
    final effectiveLocale = _manualLocaleOverride ?? globalLocale;

    await ref
        .read(cvDownloadProvider.notifier)
        .attemptDownload(
          context: context,
          styleId: selectedStyleId,
          locale: effectiveLocale,
          usePhoto: _usePhoto,
        );
  }

  @override
  Widget build(BuildContext context) {
    final templatesAsync = ref.watch(templatesProvider);
    final creationState = ref.watch(cvCreationProvider);
    final downloadState = ref.watch(cvDownloadProvider);
    final photoUrl = ref
        .watch(profileControllerProvider)
        .currentProfile
        .photoUrl;
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
            orElse: () => templates.isNotEmpty
                ? templates.first
                : throw Exception('No template selected'),
          );

          return SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TemplateCarouselPreview(
                  previewUrls: template.previewUrls,
                  thumbnailUrl: template.thumbnailUrl,
                  supportsPhoto: template.supportsPhoto,
                  usePhoto: _usePhoto,
                  pageController: _pageController,
                  onPageChanged: (index) {
                    if (template.supportsPhoto &&
                        template.previewUrls.length > 1) {
                      setState(() => _usePhoto = (index == 1));
                    }
                  },
                ),
                const SizedBox(height: 32),

                Text(
                  AppLocalizations.of(context)!.cvLanguage,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 12),
                LanguageSelector(
                  manualLocaleOverride: _manualLocaleOverride,
                  onLocaleChanged: (code) =>
                      setState(() => _manualLocaleOverride = code),
                ),
                const SizedBox(height: 24),

                if (template.supportsPhoto) ...[
                  Text(
                    AppLocalizations.of(context)!.photoSettings,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 12),
                  PhotoToggleSettings(
                    photoUrl: photoUrl,
                    usePhoto: _usePhoto,
                    onUploadingChanged: (val) =>
                        setState(() => _isUploading = val),
                    onToggleChanged: (val) {
                      setState(() => _usePhoto = val);
                      if (template.supportsPhoto &&
                          template.previewUrls.length > 1) {
                        _pageController.animateToPage(
                          val ? 1 : 0,
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                        );
                      }
                    },
                  ),
                ],
                const SizedBox(height: 100),
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
              Text(
                AppLocalizations.of(context)!.templateLoadError(err.toString()),
              ),
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
              onPressed:
                  (downloadState.status == DownloadStatus.generating ||
                      _isUploading)
                  ? null
                  : _handleDownload,
              style: ElevatedButton.styleFrom(
                backgroundColor: isDark ? Colors.white : Colors.black,
                foregroundColor: isDark ? Colors.black : Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              child: downloadState.status == DownloadStatus.generating
                  ? const CircularProgressIndicator()
                  : Text(
                      AppLocalizations.of(context)!.exportPdf,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.2,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

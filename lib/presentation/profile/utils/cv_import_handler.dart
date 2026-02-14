import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_import_provider.dart';
import '../../common/widgets/app_loading_screen.dart';
import '../../../core/utils/custom_snackbar.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class CVImportHandler {
  static void showImportDialog({
    required BuildContext context,
    required WidgetRef ref,
    required Function(UserProfile) onImportSuccess,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(AppLocalizations.of(context)!.importCVTitle),
        content: Text(AppLocalizations.of(context)!.importCVMessage),
        actions: [
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromImage(context, ref, ImageSource.camera, onImportSuccess);
            },
            icon: const Icon(Icons.camera_alt),
            label: Text(AppLocalizations.of(context)!.camera),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromImage(context, ref, ImageSource.gallery, onImportSuccess);
            },
            icon: const Icon(Icons.photo_library),
            label: Text(AppLocalizations.of(context)!.gallery),
          ),
          TextButton.icon(
            onPressed: () {
              Navigator.pop(dialogContext);
              _importFromPDF(context, ref, onImportSuccess);
            },
            icon: const Icon(Icons.picture_as_pdf),
            label: Text(AppLocalizations.of(context)!.pdfFile),
          ),
        ],
      ),
    );
  }

  static Future<void> _importFromImage(
    BuildContext context,
    WidgetRef ref,
    ImageSource source,
    Function(UserProfile) onImportSuccess,
  ) async {
    bool loadingShown = false;

    final result = await ref.read(cvImportProvider.notifier).importFromImage(
      source,
      onProcessingStart: () {
        if (!loadingShown) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (ctx, _, __) => AppLoadingScreen(
                badge: AppLocalizations.of(context)!.importingCVBadge,
                messages: [
                  AppLocalizations.of(context)!.readingCV,
                  AppLocalizations.of(context)!.extractingData,
                  AppLocalizations.of(context)!.compilingProfile,
                ],
              ),
            ),
          );
        }
      },
    );

    if (loadingShown && context.mounted) {
      Navigator.pop(context);
    }

    _handleResult(context, ref, result, onImportSuccess);
  }

  static Future<void> _importFromPDF(
    BuildContext context,
    WidgetRef ref,
    Function(UserProfile) onImportSuccess,
  ) async {
    bool loadingShown = false;

    final result = await ref.read(cvImportProvider.notifier).importFromPDF(
      onProcessingStart: () {
        if (!loadingShown) {
          loadingShown = true;
          Navigator.of(context).push(
            PageRouteBuilder(
              opaque: false,
              barrierDismissible: false,
              pageBuilder: (ctx, _, __) => AppLoadingScreen(
                badge: AppLocalizations.of(context)!.importingCVBadge,
                messages: [
                  AppLocalizations.of(context)!.readingPDF,
                  AppLocalizations.of(context)!.extractingData,
                  AppLocalizations.of(context)!.compilingProfile,
                ],
              ),
            ),
          );
        }
      },
    );

    if (loadingShown && context.mounted) {
      Navigator.pop(context);
    }

    _handleResult(context, ref, result, onImportSuccess);
  }

  static void _handleResult(
    BuildContext context,
    WidgetRef ref,
    CVImportState result,
    Function(UserProfile) onImportSuccess,
  ) {
    if (!context.mounted) return;

    switch (result.status) {
      case CVImportStatus.success:
        if (result.extractedProfile != null) {
          onImportSuccess(result.extractedProfile!);
        }
        break;
      case CVImportStatus.cancelled:
        // User cancelled, do nothing
        break;
      case CVImportStatus.noText:
        CustomSnackBar.showWarning(context, AppLocalizations.of(context)!.noTextFoundInCV);
        break;
      case CVImportStatus.error:
        CustomSnackBar.showError(context, AppLocalizations.of(context)!.importFailedMessage);
        break;
      default:
        break;
    }
  }
}

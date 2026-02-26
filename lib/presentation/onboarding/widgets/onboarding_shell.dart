import 'package:flutter/material.dart';
import 'package:clever/l10n/generated/app_localizations.dart';

class OnboardingShell extends StatelessWidget {
  final int currentPage;
  final int totalSteps;
  final Widget child;

  const OnboardingShell({
    super.key,
    required this.currentPage,
    required this.totalSteps,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Center(
          child: Container(
            margin: const EdgeInsets.only(top: 16, bottom: 24),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[700],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                currentPage == totalSteps - 1
                    ? AppLocalizations.of(context)!.youreAllSet
                    : AppLocalizations.of(context)!.dropYourDetails,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w900,
                  color: Colors.white,
                  letterSpacing: 1.2,
                  fontFamily: 'Montserrat',
                ),
              ),
              const SizedBox(height: 12),
              if (currentPage == 0) ...[
                Text(
                  AppLocalizations.of(context)!.onboardingSubtitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[400],
                    height: 1.5,
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ],
          ),
        ),

        if (currentPage > 0)
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24.0,
              vertical: 8.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _getStepLabel(context, currentPage, totalSteps),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[500],
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                  value: (currentPage + 1) / totalSteps,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),

        Expanded(child: child),
      ],
    );
  }

  String _getStepLabel(BuildContext context, int page, int total) {
    final l10n = AppLocalizations.of(context)!;
    final labels = {
      0: l10n.stepPersonalInfo,
      1: l10n.stepImportCV,
      2: l10n.stepExperience,
      3: l10n.stepEducation,
      4: l10n.stepCertifications,
      5: l10n.stepSkills,
      6: l10n.stepFinish,
    };
    final label = labels[page] ?? '';
    return '${page + 1} / $total — $label';
  }
}

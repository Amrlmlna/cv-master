import 'package:posthog_flutter/posthog_flutter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../presentation/onboarding/pages/onboarding_welcome_page.dart';
import '../../presentation/onboarding/pages/onboarding_page.dart';
import '../../presentation/onboarding/providers/onboarding_provider.dart';
import '../../presentation/home/pages/home_page.dart';
import '../../presentation/dashboard/pages/main_wrapper_page.dart';

import '../../presentation/jobs/pages/job_list_page.dart';
import '../../presentation/drafts/pages/drafts_page.dart';
import '../../presentation/profile/pages/profile_page.dart';
import '../../presentation/cv/pages/job_input_page.dart';
import '../../presentation/cv/pages/user_data_form_page.dart';
import '../../presentation/stats/pages/stats_page.dart';
import '../../presentation/wallet/pages/wallet_page.dart';
import '../../presentation/templates/pages/style_selection_page.dart';
import '../../presentation/templates/pages/template_preview_page.dart';
import '../../presentation/support/pages/help_page.dart';
import '../../presentation/support/pages/feedback_page.dart';
import '../../presentation/notification/pages/notification_page.dart';
import '../../presentation/legal/pages/legal_page.dart';
import '../../presentation/common/pages/error_page.dart';
import '../../presentation/auth/pages/login_page.dart';
import '../../presentation/auth/pages/signup_page.dart';
import '../../domain/entities/tailored_cv_result.dart';
import '../../domain/entities/job_input.dart';
import 'package:clever/l10n/generated/app_localizations.dart';
import 'app_routes.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

CustomTransitionPage<void> _buildPage(Widget child, GoRouterState state) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 250),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curve = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOut,
      );
      return FadeTransition(
        opacity: curve,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.04),
            end: Offset.zero,
          ).animate(curve),
          child: child,
        ),
      );
    },
  );
}

final routerProvider = Provider<GoRouter>((ref) {
  final onboardingCompleted = ref.watch(onboardingProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.home,
    redirect: (context, state) {
      final isGoingToOnboarding = state.uri.toString().startsWith(
        AppRoutes.onboarding,
      );
      if (!onboardingCompleted && !isGoingToOnboarding) {
        return AppRoutes.onboarding;
      }

      if (onboardingCompleted && isGoingToOnboarding) {
        return AppRoutes.home;
      }

      return null;
    },
    observers: [PosthogObserver()],
    routes: [
      // Auth Routes
      GoRoute(
        path: AppRoutes.login,
        pageBuilder: (context, state) => _buildPage(const LoginPage(), state),
      ),
      GoRoute(
        path: AppRoutes.signup,
        pageBuilder: (context, state) => _buildPage(const SignupPage(), state),
      ),

      GoRoute(
        path: AppRoutes.error,
        pageBuilder: (context, state) {
          final args = state.extra as ErrorPageArgs?;
          return _buildPage(
            ErrorPage(
              args:
                  args ??
                  ErrorPageArgs(
                    title: AppLocalizations.of(context)!.unknownError,
                    message: AppLocalizations.of(context)!.unknownErrorDesc,
                  ),
            ),
            state,
          );
        },
      ),

      // Onboarding Flow
      GoRoute(
        path: AppRoutes.onboarding,
        pageBuilder: (context, state) =>
            _buildPage(const OnboardingWelcomePage(), state),
        routes: [
          GoRoute(
            path: 'form', // Relative to /onboarding
            pageBuilder: (context, state) =>
                _buildPage(const OnboardingPage(), state),
          ),
        ],
      ),

      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return MainWrapperPage(navigationShell: navigationShell);
        },
        branches: [
          // Branch 0: Home
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const HomePage(),
                routes: [
                  GoRoute(
                    path: 'preview',
                    parentNavigatorKey: _rootNavigatorKey,
                    redirect: (context, state) => AppRoutes.home,
                  ),
                ],
              ),
            ],
          ),
          // Branch 1: Drafts (My CVs)
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.drafts,
                builder: (context, state) => const DraftsPage(),
              ),
            ],
          ),
          // Branch 2: Wallet
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.wallet,
                builder: (context, state) => const WalletPage(),
              ),
            ],
          ),
          // Branch 3: Profile
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const ProfilePage(),
                routes: [
                  GoRoute(
                    path: 'help',
                    parentNavigatorKey: _rootNavigatorKey,
                    pageBuilder: (context, state) =>
                        _buildPage(const HelpPage(), state),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),

      GoRoute(
        path: AppRoutes.notifications,
        pageBuilder: (context, state) =>
            _buildPage(const NotificationPage(), state),
      ),

      GoRoute(
        path: AppRoutes.feedback,
        pageBuilder: (context, state) =>
            _buildPage(const FeedbackPage(), state),
      ),
      GoRoute(
        path: AppRoutes.legal,
        pageBuilder: (context, state) =>
            _buildPage(const LegalPage(), state),
      ),
      GoRoute(
        path: AppRoutes.jobs,
        pageBuilder: (context, state) =>
            _buildPage(const JobListPage(), state),
      ),
      GoRoute(
        path: AppRoutes.stats,
        pageBuilder: (context, state) =>
            _buildPage(const StatsPage(), state),
      ),

      GoRoute(
        path: AppRoutes.createJobInput,
        pageBuilder: (context, state) {
          final jobInput = state.extra as JobInput?;
          return _buildPage(
            JobInputPage(initialJobInput: jobInput),
            state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createUserData,
        pageBuilder: (context, state) {
          final tailoredResult = state.extra as TailoredCVResult?;
          return _buildPage(
            UserDataFormPage(tailoredResult: tailoredResult),
            state,
          );
        },
      ),
      GoRoute(
        path: AppRoutes.createStyleSelection,
        pageBuilder: (context, state) =>
            _buildPage(const StyleSelectionPage(), state),
      ),
      GoRoute(
        path: AppRoutes.createTemplatePreview,
        pageBuilder: (context, state) =>
            _buildPage(const TemplatePreviewPage(), state),
      ),
    ],
  );
});

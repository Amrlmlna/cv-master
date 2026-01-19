import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'presentation/providers/onboarding_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Check onboarding status before app starts to prevent flash
  final prefs = await SharedPreferences.getInstance();
  final onboardingCompleted = prefs.getBool('onboarding_completed') ?? false;

  runApp(ProviderScope(
    overrides: [
      // Initialize provider with the stored value
      onboardingProvider.overrideWith((ref) {
        // Manually set the state implementation is tricky with StateNotifierProvider overrides sometimes if not just passing value.
        // Better: OnboardingNotifier can accept initial value.
        // Let's modify OnboardingNotifier constructor instead.
        return OnboardingNotifier(initialState: onboardingCompleted);
      }),
    ],
    child: const MyApp(),
  ));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Job-Specific CV Builder',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      routerConfig: router,
    );
  }
}

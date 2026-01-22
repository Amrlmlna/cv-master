import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../../legal/pages/legal_page.dart';
import '../providers/onboarding_provider.dart';
import '../../profile/providers/profile_provider.dart';

import '../widgets/onboarding_personal_step.dart';
import '../widgets/onboarding_experience_step.dart';
import '../widgets/onboarding_education_step.dart';
import '../widgets/onboarding_skills_step.dart';
import '../widgets/onboarding_final_step.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();

  // Temporary State for data collection
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();

  void _showLegalModal(BuildContext context, String title, String content) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          children: [
            // Handle bar
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 12, bottom: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            // Title
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                  fontFamily: 'Outfit',
                ),
              ),
            ),
            const Divider(),
            // Content
            Expanded(
              child: Markdown(
                data: content,
                padding: const EdgeInsets.all(24),
              ),
            ),
          ],
        ),
      ),
    );
  }
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _skills = [];

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // We return just the content, assuming the parent provides the scaffold/sheet structure
    // But to respect the 'scroll' behavior request, the parent (Sheet) needs a ScrollController?
    // User wants the SHEET to scroll, but the content inside (PageView) is not scrollable.
    // So the Sheet scrolls UP/DOWN, revealing this content.
    // This content should fill the available space in the sheet.
    
    return Column(
          children: [
            // Handle Bar for Sheet
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 16, bottom: 24),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[700], // Darker handle for dark sheet
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // Header "Kenalan Dulu Yuk" (Visible when sheet is collapsed/minimized)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Text(
                      _currentPage == 4 ? 'YOU\'RE ALL SET!' : 'DROP YOUR DETAILS.',
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900, // Extra Bold
                        color: Colors.white,
                        letterSpacing: 1.2,
                        fontFamily: 'Montserrat', // If available, or default
                      ),
                    ),
                    const SizedBox(height: 12),
                    if (_currentPage == 0) ...[
                      Text(
                        'Isi data sekali, generate ribuan CV tanpa ngetik ulang. Hemat waktu, fokus "grinding".',
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
            
            // Progress Bar (Only show if we start filling)
            if (_currentPage > 0)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 8.0),
              child: LinearProgressIndicator(
                value: (_currentPage + 1) / 5,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            ),
            
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.6, // Adjusted: Compact size
              child: Form(
                key: _formKey, 
                child: PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(), // Prevent swipe
                  children: [

                    OnboardingPersonalStep(
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      locationController: _locationController,
                    ),
                    OnboardingExperienceStep(
                      experiences: _experiences,
                      onChanged: (val) => setState(() => _experiences = val),
                    ),
                    OnboardingEducationStep(
                      education: _education,
                      onChanged: (val) => setState(() => _education = val),
                    ),
                    OnboardingSkillsStep(
                      skills: _skills,
                      onChanged: (val) => setState(() => _skills = val),
                    ),
                    const OnboardingFinalStep(),
                  ],
                ),
              ),
            ),
            
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
              child: Column(
                children: [
                  // Terms & Conditions Text (Only on Final Step)
                  if (_currentPage == 4) ...[
                     Padding(
                       padding: const EdgeInsets.only(bottom: 12.0),
                       child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          style: const TextStyle(fontSize: 12, color: Colors.white38, fontFamily: 'Outfit'),
                          children: [
                            const TextSpan(
                              text: 'Dengan menekan "MULAI SEKARANG", kamu setuju dengan ',
                            ),
                            TextSpan(
                              text: 'Syarat & Ketentuan',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _showLegalModal(context, 'Terms of Service', kTermsOfService);
                                },
                            ),
                            const TextSpan(text: ' dan '),
                            TextSpan(
                              text: 'Kebijakan Privasi',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  _showLegalModal(context, 'Privacy Policy', kPrivacyPolicy);
                                },
                            ),
                            const TextSpan(text: ' kami.'),
                          ],
                        ),
                                           ),
                     ),
                  ],

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _nextPage,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16), // Softer corners
                        ),
                      ),
                      child: Text(
                        _currentPage == 4 ? 'MULAI SEKARANG' : 'NEXT STEP',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16, 
                          letterSpacing: 1.0
                        ),
                      ),
                    ),
                  ),
                  
                  if (_currentPage > 0) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: _prevPage,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white54,
                      ),
                      child: const Text('Back', style: TextStyle(fontSize: 14)),
                    ),
                  ] else ...[
                     const SizedBox(height: 24), // Spacer to keep balance if no back button
                  ]
                ],
              ),
            ),
          ],
        );
  }

  void _nextPage() {
    // Validation Logic
    if (_currentPage == 0) {
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Tolong isi nama lengkap dulu ya.')));
        return;
      }
    }

    if (_currentPage < 4) {
      _pageController.nextPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentPage++;
      });
    } else {
      _finishOnboarding();
    }
  }

  void _prevPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(duration: const Duration(milliseconds: 300), curve: Curves.easeInOut);
      setState(() {
        _currentPage--;
      });
    }
  }

  Future<void> _finishOnboarding() async {
    // 1. Save to Master Profile
    final masterProfile = UserProfile(
      fullName: _nameController.text,
      email: _emailController.text,
      phoneNumber: _phoneController.text,
      location: _locationController.text,
      experience: _experiences,
      education: _education,
      skills: _skills,
    );
    
    ref.read(masterProfileProvider.notifier).saveProfile(masterProfile);

    // 2. Mark Onboarding as Complete
    await ref.read(onboardingProvider.notifier).completeOnboarding();
    
    // 3. Navigate Home
    if (mounted) {
      context.go('/');
    }
  }
}

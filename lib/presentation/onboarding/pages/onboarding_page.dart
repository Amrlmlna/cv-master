import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/onboarding_provider.dart';
import '../../profile/providers/profile_provider.dart';

import '../widgets/onboarding_personal_step.dart';
import '../widgets/onboarding_experience_step.dart';
import '../widgets/onboarding_education_step.dart';
import '../widgets/onboarding_skills_step.dart';
import '../widgets/onboarding_final_step.dart';

import '../utils/image_sequence_loader.dart';
import '../widgets/onboarding_background.dart';

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentFrame = 0;
  int _currentPage = 0;
  final _formKey = GlobalKey<FormState>();

  // Temporary State for data collection
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  List<Experience> _experiences = [];
  List<Education> _education = [];
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    // Start pre-caching images immediately
    ImageSequenceLoader.precacheSequence(context);

    _pageController.addListener(_onScroll);
  }

  void _onScroll() {
    if (!_pageController.hasClients) return;
    
    // Calculate total pages (5 pages -> indices 0 to 4)
    const int totalPages = 5;
    
    // Get current progress (0.0 to 4.0)
    final double page = _pageController.page ?? 0.0;
    
    // Normalize to 0.0 - 1.0 range
    final double progress = (page / (totalPages - 1)).clamp(0.0, 1.0);
    
    // Map to frame count (0 to 122)
    final int frameIndex = (progress * (ImageSequenceLoader.totalFrames - 1)).round();
    
    if (frameIndex != _currentFrame) {
      setState(() {
        _currentFrame = frameIndex;
      });
    }
  }

  @override
  void dispose() {
    _pageController.removeListener(_onScroll);
    _pageController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  // Validate current page before allowing move to next
  bool _validateCurrentPage(int pageIndex) {
    if (pageIndex == 0) {
      if (_nameController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Nama lengkap wajib diisi ya!')),
        );
        return false;
      }
    }
    return true;
  }

  void _onPageChanged(int index) {
    // If user tried to go forward
    if (index > _currentPage) {
       if (!_validateCurrentPage(_currentPage)) {
         // If invalid, bounce back
         _pageController.animateToPage(
           _currentPage, 
           duration: const Duration(milliseconds: 300), 
           curve: Curves.easeOut,
         );
         return;
       }
    }
    
    setState(() {
      _currentPage = index;
    });

    // Auto-complete if reached end? No, explicit button on final step is better.
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false, // Prevent background from squishing
      body: Stack(
        children: [
          // Layer 1: Animated Background
          OnboardingBackground(frameIndex: _currentFrame),

          // Layer 2: Overlay for readability (Gradient)
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.3),
                  Colors.black.withValues(alpha: 0.7),
                ],
              ),
            ),
          ),

          // Layer 3: Content
          SafeArea(
            child: Form(
              key: _formKey,
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.vertical,
                onPageChanged: _onPageChanged,
                children: [
                  _buildGlassStep(
                    OnboardingPersonalStep(
                      nameController: _nameController,
                      emailController: _emailController,
                      phoneController: _phoneController,
                      locationController: _locationController,
                    ),
                  ),
                  _buildGlassStep(
                    OnboardingExperienceStep(
                      experiences: _experiences,
                      onChanged: (val) => setState(() => _experiences = val),
                    ),
                  ),
                  _buildGlassStep(
                    OnboardingEducationStep(
                      education: _education,
                      onChanged: (val) => setState(() => _education = val),
                    ),
                  ),
                  _buildGlassStep(
                    OnboardingSkillsStep(
                      skills: _skills,
                      onChanged: (val) => setState(() => _skills = val),
                    ),
                  ),
                  _buildGlassStep(
                     OnboardingFinalStep(
                       onFinish: _finishOnboarding, // Pass the callback
                     ),
                  ),
                ],
              ),
            ),
          ),
          
          // Layer 4: Navigation Hint (Chevron) - Hide on last page
          if (_currentPage < 4)
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: IconButton(
                  onPressed: () {
                    _pageController.nextPage(
                      duration: const Duration(milliseconds: 600),
                      curve: Curves.easeInOut,
                    );
                  },
                  icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 40),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildGlassStep(Widget child) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 40),
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.9), // Slightly transparent white card
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: child,
      ),
    );
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

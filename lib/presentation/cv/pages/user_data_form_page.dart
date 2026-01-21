import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../domain/entities/user_profile.dart';
import '../providers/cv_generation_provider.dart';
import '../../profile/providers/profile_provider.dart';
import '../../profile/widgets/education_list_form.dart';
import '../../profile/widgets/experience_list_form.dart';
import '../../profile/widgets/skills_input_form.dart';
import '../../profile/widgets/personal_info_form.dart';

class UserDataFormPage extends ConsumerStatefulWidget {
  final UserProfile? tailoredProfile;
  const UserDataFormPage({super.key, this.tailoredProfile});

  @override
  ConsumerState<UserDataFormPage> createState() => _UserDataFormPageState();
}

class _UserDataFormPageState extends ConsumerState<UserDataFormPage> {
  final _formKey = GlobalKey<FormState>();
  bool _updateMasterProfile = true;

  // Personal Info Controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _locationController = TextEditingController();
  
  // Lists
  List<Experience> _experience = [];
  List<Education> _education = [];
  List<String> _skills = [];

  @override
  void initState() {
    super.initState();
    // Auto-fill from Master Profile if available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final masterProfile = ref.read(masterProfileProvider);
      final profileToUse = widget.tailoredProfile ?? masterProfile;
      final isTailored = widget.tailoredProfile != null;
      
      // If we have a profile to use AND the current form is empty
      if (profileToUse != null && _nameController.text.isEmpty) {
        setState(() {
          _nameController.text = profileToUse.fullName;
          _emailController.text = profileToUse.email;
          _phoneController.text = profileToUse.phoneNumber ?? '';
          _locationController.text = profileToUse.location ?? '';
          
          _experience = List<Experience>.from(profileToUse.experience);
          _education = List<Education>.from(profileToUse.education);
          _skills = List<String>.from(profileToUse.skills);
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(isTailored 
              ? 'Data telah disesuaikan oleh AI untuk pekerjaan ini! ✨' 
              : 'Data otomatis diisi dari Master Profile kamu!'),
            behavior: SnackBarBehavior.floating,
            backgroundColor: Theme.of(context).primaryColor,
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _locationController.dispose();
    super.dispose();
  }


  void _submit() {
    if (_formKey.currentState!.validate()) {
      final profile = UserProfile(
        fullName: _nameController.text,
        email: _emailController.text,
        phoneNumber: _phoneController.text,
        location: _locationController.text,
        experience: _experience,
        education: _education,
        skills: _skills.isNotEmpty ? _skills : ['Leadership', 'Communication'], // Fallback if empty, or just empty
      );

      ref.read(cvCreationProvider.notifier).setUserProfile(profile);

      if (_updateMasterProfile) {
        ref.read(masterProfileProvider.notifier).saveProfile(profile);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Master Profile berhasil diupdate!')),
        );
      }

      context.push('/create/style-selection');
    }
  }

  // Accordion State
  bool _isPersonalExpanded = true;
  bool _isExperienceExpanded = false;
  bool _isEducationExpanded = false;
  bool _isSkillsExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Review Data'),
        elevation: 0,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              offset: const Offset(0, -4),
              blurRadius: 10,
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.black,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Generate CV Sekarang',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // Header Message
              if (widget.tailoredProfile != null)
                Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.blue[50],
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.blue[100]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.auto_awesome, color: Colors.blue),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Data ini sudah disesuaikan AI agar relevan dengan posisi yang kamu tuju. Cek lagi ya!',
                          style: TextStyle(color: Colors.blue[900], fontSize: 13),
                        ),
                      ),
                    ],
                  ),
                ),

              // 1. Personal Info Section
              _buildAccordionSection(
                title: 'Informasi Personal',
                icon: Icons.person_outline,
                isExpanded: _isPersonalExpanded,
                onExpansionChanged: (val) => setState(() => _isPersonalExpanded = val),
                child: PersonalInfoForm(
                  nameController: _nameController,
                  emailController: _emailController,
                  phoneController: _phoneController,
                  locationController: _locationController,
                ),
              ),
              const SizedBox(height: 16),

              // 2. Experience Section
              _buildAccordionSection(
                title: 'Pengalaman Kerja',
                icon: Icons.work_outline,
                isExpanded: _isExperienceExpanded,
                onExpansionChanged: (val) => setState(() => _isExperienceExpanded = val),
                child: ExperienceListForm(
                  experiences: _experience,
                  onChanged: (val) => setState(() => _experience = val),
                ),
              ),
              const SizedBox(height: 16),

              // 3. Education Section
              _buildAccordionSection(
                title: 'Riwayat Pendidikan',
                icon: Icons.school_outlined,
                isExpanded: _isEducationExpanded,
                onExpansionChanged: (val) => setState(() => _isEducationExpanded = val),
                child: EducationListForm(
                  education: _education,
                  onChanged: (val) => setState(() => _education = val),
                ),
              ),
              const SizedBox(height: 16),

              // 4. Skills Section
              _buildAccordionSection(
                title: 'Keahlian (Skills)',
                icon: Icons.lightbulb_outline,
                isExpanded: _isSkillsExpanded,
                onExpansionChanged: (val) => setState(() => _isSkillsExpanded = val),
                child: Column(
                  children: [
                    SkillsInputForm(
                      skills: _skills,
                      onChanged: (val) => setState(() => _skills = val),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: CheckboxListTile(
                        title: const Text('Update Master Profile', style: TextStyle(fontWeight: FontWeight.bold)),
                        subtitle: const Text('Simpan perubahan ini ke profil utamamu.', style: TextStyle(fontSize: 12, color: Colors.grey)),
                        value: _updateMasterProfile, 
                        activeColor: Colors.black,
                        onChanged: (val) {
                          setState(() {
                            _updateMasterProfile = val ?? true;
                          });
                        },
                        secondary: const Icon(Icons.save_as_outlined),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAccordionSection({
    required String title,
    required IconData icon,
    required bool isExpanded,
    required Function(bool) onExpansionChanged,
    required Widget child,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          initiallyExpanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isExpanded ? Colors.black : Colors.grey[100],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: isExpanded ? Colors.white : Colors.grey[600],
              size: 20,
            ),
          ),
          title: Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: isExpanded ? Colors.black : Colors.grey[700],
            ),
          ),
          childrenPadding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
          children: [
            const Divider(height: 1),
            const SizedBox(height: 16),
            child,
          ],
        ),
      ),
    );
  }
}

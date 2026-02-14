// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInSubtitle => 'Sign in to sync your CVs across devices';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get login => 'Login';

  @override
  String get or => 'OR';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get signUp => 'Sign Up';

  @override
  String get createAccount => 'Create Account';

  @override
  String get createAccountSubtitle => 'Start your journey to a better career';

  @override
  String get fullName => 'Full Name';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get logIn => 'Log In';

  @override
  String get pleaseEnterEmail => 'Please enter your email';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseEnterName => 'Please enter your name';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get accountCreatedSuccess => 'Account created successfully!';

  @override
  String get welcomeBackSuccess => 'Welcome back!';

  @override
  String get googleSignInSuccess => 'Signed in with Google!';

  @override
  String googleSignInError(Object error) {
    return 'Google Sign-In failed: $error';
  }

  @override
  String get errorDetailsCopied => 'Error details copied to clipboard';

  @override
  String get technicalDetails => 'TECHNICAL DETAILS';

  @override
  String get goHome => 'Go Home';

  @override
  String get close => 'Close';

  @override
  String get rewrite => 'Rewrite';

  @override
  String get typeHere => 'Type here...';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get bold => 'Bold';

  @override
  String get italic => 'Italic';

  @override
  String get header => 'Header';

  @override
  String get locationLabel => 'Location (Search City/Regency)';

  @override
  String get locationHint => 'Ex: Jakarta -> DKI Jakarta, South Jakarta';

  @override
  String get schoolLabel => 'School / University';

  @override
  String get schoolHint => 'Ex: University of Indonesia';

  @override
  String get requiredField => 'Required';

  @override
  String get syncData => 'Sync Data';

  @override
  String get logOut => 'Log Out';

  @override
  String get completeProfileFirst => 'Complete profile first for best results';

  @override
  String get validatingData => 'Validating data...';

  @override
  String get preparingProfile => 'Preparing profile...';

  @override
  String get continuingToForm => 'Continuing to form...';

  @override
  String analyzeProfileError(Object error) {
    return 'Failed to analyze profile: $error';
  }

  @override
  String get fillJobTitle => 'Fill job title first!';

  @override
  String get scanJobPosting => 'Scan Job Posting';

  @override
  String get camera => 'Camera';

  @override
  String get gallery => 'Gallery';

  @override
  String get ocrScanning => 'OCR SCANNING';

  @override
  String get analyzingText => 'Analyzing text...';

  @override
  String get identifyingVacancy => 'Identifying vacancy...';

  @override
  String get organizingData => 'Organizing data...';

  @override
  String get finalizing => 'Finalizing...';

  @override
  String get jobExtractionSuccess => 'Job posting extracted successfully!';

  @override
  String get noTextFound => 'No text found in image';

  @override
  String get jobExtractionFailed => 'Failed to extract job posting';

  @override
  String get targetPosition => 'Target Position';

  @override
  String get continueToReview => 'Continue: Review Data';

  @override
  String get whatJobApply => 'What job are you applying for?';

  @override
  String get aiHelpCreateCV =>
      'AI will help create a CV perfectly tailored for this goal.';

  @override
  String get positionHint => 'Position (Ex: UI Designer)';

  @override
  String get companyHint => 'Company Name (Optional)';

  @override
  String get requiredFieldFriendly => 'This is required!';

  @override
  String get jobDetailLabel => 'Detail / Qualification (Optional)';

  @override
  String get jobDetailHint =>
      'Paste job description, requirements, or qualifications here...';

  @override
  String get reviewedByAI => 'Data & Summary tailored by AI';

  @override
  String get autoFillFromMaster => 'Data auto-filled from your Master Profile';

  @override
  String get jobInputMissing => 'Error: Job Input missing';

  @override
  String generateSummaryFailed(Object error) {
    return 'Failed to generate summary: $error';
  }

  @override
  String get masterProfileUpdated => 'Master Profile updated successfully';

  @override
  String get reviewData => 'Review Data';

  @override
  String get continueChooseTemplate => 'Continue: Choose Template';

  @override
  String get tailoredDataMessage =>
      'This data has been tailored by AI to be relevant to your target position. Please review!';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get professionalSummary => 'Professional Summary';

  @override
  String get workExperience => 'Work Experience';

  @override
  String get educationHistory => 'Education History';

  @override
  String get certifications => 'Certifications';

  @override
  String get skills => 'Skills';

  @override
  String get summaryHint => 'Write a brief professional summary...';

  @override
  String get summaryEmpty => 'Summary cannot be empty';

  @override
  String get generateWithAI => 'Generate with AI';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get add => 'Add';

  @override
  String get noExperience => 'No work experience yet.';

  @override
  String get present => 'Present';

  @override
  String get schoolName => 'School Name';

  @override
  String get degree => 'Degree / Major';

  @override
  String get degreeHint => 'Bachelor of Computer Science';

  @override
  String get startDate => 'Start Date';

  @override
  String get endDate => 'End Date';

  @override
  String get year => 'Year';

  @override
  String get addEducation => 'ADD EDUCATION';

  @override
  String get editEducation => 'EDIT EDUCATION';

  @override
  String get cancelAllCaps => 'CANCEL';

  @override
  String get saveAllCaps => 'SAVE';

  @override
  String get noEducation => 'No education history yet.';

  @override
  String get certificationsLicenses => 'Certifications & Licenses';

  @override
  String get noCertifications => 'No certifications yet.';

  @override
  String get addSkill => 'Add Skill';

  @override
  String get skillHint => 'ex: Flutter, Leadership';

  @override
  String get noSkills => 'No skills yet.';

  @override
  String get thinking => 'Thinking...';

  @override
  String get writing => 'Writing...';

  @override
  String get fillDescriptionFirst =>
      'Please fill in the description first to use AI rewrite!';

  @override
  String get jobTitle => 'Job Title';

  @override
  String get company => 'Company';

  @override
  String get companyPlaceholder => 'Ex: Google';

  @override
  String get selectDate => 'Select Date';

  @override
  String get untilNow => 'Until Now';

  @override
  String get shortDescription => 'Short Description';

  @override
  String get improving => 'Improving...';

  @override
  String get rephrasing => 'Rephrasing...';

  @override
  String get rewriteAI => 'Rewrite AI';

  @override
  String get descriptionHint =>
      'Explain your main responsibilities and achievements...';

  @override
  String get addExperience => 'ADD EXPERIENCE';

  @override
  String get editExperienceTitle => 'EDIT EXPERIENCE';

  @override
  String get addCertification => 'Add Certification';

  @override
  String get editCertification => 'Edit Certification';

  @override
  String get certificationName => 'Certification Name';

  @override
  String get issuer => 'Issuer';

  @override
  String get dateLabel => 'Date:';
}

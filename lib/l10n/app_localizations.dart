import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('id'),
  ];

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Sign in to sync your CVs across devices'**
  String get signInSubtitle;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @or.
  ///
  /// In en, this message translates to:
  /// **'OR'**
  String get or;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// No description provided for @createAccountSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Start your journey to a better career'**
  String get createAccountSubtitle;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @logIn.
  ///
  /// In en, this message translates to:
  /// **'Log In'**
  String get logIn;

  /// No description provided for @pleaseEnterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterEmail;

  /// No description provided for @pleaseEnterPassword.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// No description provided for @pleaseEnterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterName;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// No description provided for @accountCreatedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get accountCreatedSuccess;

  /// No description provided for @welcomeBackSuccess.
  ///
  /// In en, this message translates to:
  /// **'Welcome back!'**
  String get welcomeBackSuccess;

  /// No description provided for @googleSignInSuccess.
  ///
  /// In en, this message translates to:
  /// **'Signed in with Google!'**
  String get googleSignInSuccess;

  /// No description provided for @googleSignInError.
  ///
  /// In en, this message translates to:
  /// **'Google Sign-In failed: {error}'**
  String googleSignInError(Object error);

  /// No description provided for @errorDetailsCopied.
  ///
  /// In en, this message translates to:
  /// **'Error details copied to clipboard'**
  String get errorDetailsCopied;

  /// No description provided for @technicalDetails.
  ///
  /// In en, this message translates to:
  /// **'TECHNICAL DETAILS'**
  String get technicalDetails;

  /// No description provided for @goHome.
  ///
  /// In en, this message translates to:
  /// **'Go Home'**
  String get goHome;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @rewrite.
  ///
  /// In en, this message translates to:
  /// **'Rewrite'**
  String get rewrite;

  /// No description provided for @typeHere.
  ///
  /// In en, this message translates to:
  /// **'Type here...'**
  String get typeHere;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @bold.
  ///
  /// In en, this message translates to:
  /// **'Bold'**
  String get bold;

  /// No description provided for @italic.
  ///
  /// In en, this message translates to:
  /// **'Italic'**
  String get italic;

  /// No description provided for @header.
  ///
  /// In en, this message translates to:
  /// **'Header'**
  String get header;

  /// No description provided for @locationLabel.
  ///
  /// In en, this message translates to:
  /// **'Location (Search City/Regency)'**
  String get locationLabel;

  /// No description provided for @locationHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: Jakarta -> DKI Jakarta, South Jakarta'**
  String get locationHint;

  /// No description provided for @schoolLabel.
  ///
  /// In en, this message translates to:
  /// **'School / University'**
  String get schoolLabel;

  /// No description provided for @schoolHint.
  ///
  /// In en, this message translates to:
  /// **'Ex: University of Indonesia'**
  String get schoolHint;

  /// No description provided for @requiredField.
  ///
  /// In en, this message translates to:
  /// **'Required'**
  String get requiredField;

  /// No description provided for @syncData.
  ///
  /// In en, this message translates to:
  /// **'Sync Data'**
  String get syncData;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @completeProfileFirst.
  ///
  /// In en, this message translates to:
  /// **'Complete profile first for best results'**
  String get completeProfileFirst;

  /// No description provided for @validatingData.
  ///
  /// In en, this message translates to:
  /// **'Validating data...'**
  String get validatingData;

  /// No description provided for @preparingProfile.
  ///
  /// In en, this message translates to:
  /// **'Preparing profile...'**
  String get preparingProfile;

  /// No description provided for @continuingToForm.
  ///
  /// In en, this message translates to:
  /// **'Continuing to form...'**
  String get continuingToForm;

  /// No description provided for @analyzeProfileError.
  ///
  /// In en, this message translates to:
  /// **'Failed to analyze profile: {error}'**
  String analyzeProfileError(Object error);

  /// No description provided for @fillJobTitle.
  ///
  /// In en, this message translates to:
  /// **'Fill job title first!'**
  String get fillJobTitle;

  /// No description provided for @scanJobPosting.
  ///
  /// In en, this message translates to:
  /// **'Scan Job Posting'**
  String get scanJobPosting;

  /// No description provided for @camera.
  ///
  /// In en, this message translates to:
  /// **'Camera'**
  String get camera;

  /// No description provided for @gallery.
  ///
  /// In en, this message translates to:
  /// **'Gallery'**
  String get gallery;

  /// No description provided for @ocrScanning.
  ///
  /// In en, this message translates to:
  /// **'OCR SCANNING'**
  String get ocrScanning;

  /// No description provided for @analyzingText.
  ///
  /// In en, this message translates to:
  /// **'Analyzing text...'**
  String get analyzingText;

  /// No description provided for @identifyingVacancy.
  ///
  /// In en, this message translates to:
  /// **'Identifying vacancy...'**
  String get identifyingVacancy;

  /// No description provided for @organizingData.
  ///
  /// In en, this message translates to:
  /// **'Organizing data...'**
  String get organizingData;

  /// No description provided for @finalizing.
  ///
  /// In en, this message translates to:
  /// **'Finalizing...'**
  String get finalizing;

  /// No description provided for @jobExtractionSuccess.
  ///
  /// In en, this message translates to:
  /// **'Job posting extracted successfully!'**
  String get jobExtractionSuccess;

  /// No description provided for @noTextFound.
  ///
  /// In en, this message translates to:
  /// **'No text found in image'**
  String get noTextFound;

  /// No description provided for @jobExtractionFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to extract job posting'**
  String get jobExtractionFailed;

  /// No description provided for @targetPosition.
  ///
  /// In en, this message translates to:
  /// **'Target Position'**
  String get targetPosition;

  /// No description provided for @continueToReview.
  ///
  /// In en, this message translates to:
  /// **'Continue: Review Data'**
  String get continueToReview;

  /// No description provided for @whatJobApply.
  ///
  /// In en, this message translates to:
  /// **'What job are you applying for?'**
  String get whatJobApply;

  /// No description provided for @aiHelpCreateCV.
  ///
  /// In en, this message translates to:
  /// **'AI will help create a CV perfectly tailored for this goal.'**
  String get aiHelpCreateCV;

  /// No description provided for @positionHint.
  ///
  /// In en, this message translates to:
  /// **'Position (Ex: UI Designer)'**
  String get positionHint;

  /// No description provided for @companyHint.
  ///
  /// In en, this message translates to:
  /// **'Company Name (Optional)'**
  String get companyHint;

  /// No description provided for @requiredFieldFriendly.
  ///
  /// In en, this message translates to:
  /// **'This is required!'**
  String get requiredFieldFriendly;

  /// No description provided for @jobDetailLabel.
  ///
  /// In en, this message translates to:
  /// **'Detail / Qualification (Optional)'**
  String get jobDetailLabel;

  /// No description provided for @jobDetailHint.
  ///
  /// In en, this message translates to:
  /// **'Paste job description, requirements, or qualifications here...'**
  String get jobDetailHint;

  /// No description provided for @reviewedByAI.
  ///
  /// In en, this message translates to:
  /// **'Data & Summary tailored by AI'**
  String get reviewedByAI;

  /// No description provided for @autoFillFromMaster.
  ///
  /// In en, this message translates to:
  /// **'Data auto-filled from your Master Profile'**
  String get autoFillFromMaster;

  /// No description provided for @jobInputMissing.
  ///
  /// In en, this message translates to:
  /// **'Error: Job Input missing'**
  String get jobInputMissing;

  /// No description provided for @generateSummaryFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to generate summary: {error}'**
  String generateSummaryFailed(Object error);

  /// No description provided for @masterProfileUpdated.
  ///
  /// In en, this message translates to:
  /// **'Master Profile updated successfully'**
  String get masterProfileUpdated;

  /// No description provided for @reviewData.
  ///
  /// In en, this message translates to:
  /// **'Review Data'**
  String get reviewData;

  /// No description provided for @continueChooseTemplate.
  ///
  /// In en, this message translates to:
  /// **'Continue: Choose Template'**
  String get continueChooseTemplate;

  /// No description provided for @tailoredDataMessage.
  ///
  /// In en, this message translates to:
  /// **'This data has been tailored by AI to be relevant to your target position. Please review!'**
  String get tailoredDataMessage;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @professionalSummary.
  ///
  /// In en, this message translates to:
  /// **'Professional Summary'**
  String get professionalSummary;

  /// No description provided for @workExperience.
  ///
  /// In en, this message translates to:
  /// **'Work Experience'**
  String get workExperience;

  /// No description provided for @educationHistory.
  ///
  /// In en, this message translates to:
  /// **'Education History'**
  String get educationHistory;

  /// No description provided for @certifications.
  ///
  /// In en, this message translates to:
  /// **'Certifications'**
  String get certifications;

  /// No description provided for @skills.
  ///
  /// In en, this message translates to:
  /// **'Skills'**
  String get skills;

  /// No description provided for @summaryHint.
  ///
  /// In en, this message translates to:
  /// **'Write a brief professional summary...'**
  String get summaryHint;

  /// No description provided for @summaryEmpty.
  ///
  /// In en, this message translates to:
  /// **'Summary cannot be empty'**
  String get summaryEmpty;

  /// No description provided for @generateWithAI.
  ///
  /// In en, this message translates to:
  /// **'Generate with AI'**
  String get generateWithAI;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @noExperience.
  ///
  /// In en, this message translates to:
  /// **'No work experience yet.'**
  String get noExperience;

  /// No description provided for @present.
  ///
  /// In en, this message translates to:
  /// **'Present'**
  String get present;

  /// No description provided for @schoolName.
  ///
  /// In en, this message translates to:
  /// **'School Name'**
  String get schoolName;

  /// No description provided for @degree.
  ///
  /// In en, this message translates to:
  /// **'Degree / Major'**
  String get degree;

  /// No description provided for @degreeHint.
  ///
  /// In en, this message translates to:
  /// **'Bachelor of Computer Science'**
  String get degreeHint;

  /// No description provided for @startDate.
  ///
  /// In en, this message translates to:
  /// **'Start Date'**
  String get startDate;

  /// No description provided for @endDate.
  ///
  /// In en, this message translates to:
  /// **'End Date'**
  String get endDate;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @addEducation.
  ///
  /// In en, this message translates to:
  /// **'ADD EDUCATION'**
  String get addEducation;

  /// No description provided for @editEducation.
  ///
  /// In en, this message translates to:
  /// **'EDIT EDUCATION'**
  String get editEducation;

  /// No description provided for @cancelAllCaps.
  ///
  /// In en, this message translates to:
  /// **'CANCEL'**
  String get cancelAllCaps;

  /// No description provided for @saveAllCaps.
  ///
  /// In en, this message translates to:
  /// **'SAVE'**
  String get saveAllCaps;

  /// No description provided for @noEducation.
  ///
  /// In en, this message translates to:
  /// **'No education history yet.'**
  String get noEducation;

  /// No description provided for @certificationsLicenses.
  ///
  /// In en, this message translates to:
  /// **'Certifications & Licenses'**
  String get certificationsLicenses;

  /// No description provided for @noCertifications.
  ///
  /// In en, this message translates to:
  /// **'No certifications yet.'**
  String get noCertifications;

  /// No description provided for @addSkill.
  ///
  /// In en, this message translates to:
  /// **'Add Skill'**
  String get addSkill;

  /// No description provided for @skillHint.
  ///
  /// In en, this message translates to:
  /// **'ex: Flutter, Leadership'**
  String get skillHint;

  /// No description provided for @noSkills.
  ///
  /// In en, this message translates to:
  /// **'No skills yet.'**
  String get noSkills;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking...'**
  String get thinking;

  /// No description provided for @writing.
  ///
  /// In en, this message translates to:
  /// **'Writing...'**
  String get writing;

  /// No description provided for @fillDescriptionFirst.
  ///
  /// In en, this message translates to:
  /// **'Please fill in the description first to use AI rewrite!'**
  String get fillDescriptionFirst;

  /// No description provided for @jobTitle.
  ///
  /// In en, this message translates to:
  /// **'Job Title'**
  String get jobTitle;

  /// No description provided for @company.
  ///
  /// In en, this message translates to:
  /// **'Company'**
  String get company;

  /// No description provided for @companyPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Ex: Google'**
  String get companyPlaceholder;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @untilNow.
  ///
  /// In en, this message translates to:
  /// **'Until Now'**
  String get untilNow;

  /// No description provided for @shortDescription.
  ///
  /// In en, this message translates to:
  /// **'Short Description'**
  String get shortDescription;

  /// No description provided for @improving.
  ///
  /// In en, this message translates to:
  /// **'Improving...'**
  String get improving;

  /// No description provided for @rephrasing.
  ///
  /// In en, this message translates to:
  /// **'Rephrasing...'**
  String get rephrasing;

  /// No description provided for @rewriteAI.
  ///
  /// In en, this message translates to:
  /// **'Rewrite AI'**
  String get rewriteAI;

  /// No description provided for @descriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Explain your main responsibilities and achievements...'**
  String get descriptionHint;

  /// No description provided for @addExperience.
  ///
  /// In en, this message translates to:
  /// **'ADD EXPERIENCE'**
  String get addExperience;

  /// No description provided for @editExperienceTitle.
  ///
  /// In en, this message translates to:
  /// **'EDIT EXPERIENCE'**
  String get editExperienceTitle;

  /// No description provided for @addCertification.
  ///
  /// In en, this message translates to:
  /// **'Add Certification'**
  String get addCertification;

  /// No description provided for @editCertification.
  ///
  /// In en, this message translates to:
  /// **'Edit Certification'**
  String get editCertification;

  /// No description provided for @certificationName.
  ///
  /// In en, this message translates to:
  /// **'Certification Name'**
  String get certificationName;

  /// No description provided for @issuer.
  ///
  /// In en, this message translates to:
  /// **'Issuer'**
  String get issuer;

  /// No description provided for @dateLabel.
  ///
  /// In en, this message translates to:
  /// **'Date:'**
  String get dateLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

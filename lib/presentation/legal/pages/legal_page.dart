import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class LegalPage extends StatelessWidget {
  final String title;
  final String content;

  const LegalPage({super.key, required this.title, required this.content});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
         backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(color: Colors.grey[200], height: 1),
        ),
      ),
       backgroundColor: Colors.white,
      body: Markdown(data: content),
    );
  }
}

// Simple hardcoded content for MVP. 
// In production, move these to assets or fetch from remote.

const String kPrivacyPolicy = '''
# Privacy Policy for CV Master

**Last updated: January 2026**

This Privacy Policy describes Our policies and procedures on the collection, use and disclosure of Your information when You use the Service.

## Collecting and Using Your Personal Data

### Types of Data Collected

**Personal Data**
While using Our Service, We may ask You to provide specific personally identifiable information:
- Full Name
- Email address
- Phone number
- Employment history

**CV Data**
The data you enter is stored **LOCALLY** on your device. We do not store your CV profiles in our persistent centralized servers.
When you use AI features, your anonymized text is sent to our processing provider solely for the purpose of generating the response and is not used to train their models.

### Security of Your Personal Data
The security of Your Personal Data is important to Us, but remember that no method of transmission over the Internet, or method of electronic storage is 100% secure.

## Contact Us
If you have any questions about this Privacy Policy, You can contact us:
- By email: legal@cvmaster.id
''';

const String kTermsOfService = '''
# Terms of Service

**Last updated: January 2026**

## 1. Terms
By accessing this Application, you are agreeing to be bound by these Terms and Conditions of Use and agree that you are responsible for the agreement with any applicable local laws.

## 2. Use License
Permission is granted to temporarily download one copy of the materials on CV Master's Application for personal, non-commercial transitory viewing only.

## 3. Disclaimer
The materials on CV Master's Application are provided "as is". CV Master makes no warranties, expressed or implied, and hereby disclaims and negates all other warranties.

## 4. Limitations
In no event shall CV Master or its suppliers be liable for any damages (including, without limitation, damages for loss of data or profit) arising out of the use or inability to use the materials on CV Master's Application.

''';

# 📘 Developer Guide: Adding New CV Templates

This guide explains how to add new CV design templates to the application. The system is designed to be dynamic, but since PDF generation requires precise layout logic, you will need to touch two main files.

## Step 1: Add Template Metadata
Register the new template so it appears in the **Template Gallery** and **Selection Screens**.

**File:** `lib/data/repositories/template_repository.dart`

Add a new `CVTemplate` object to the `_allTemplates` list:

```dart
const CVTemplate(
  id: 'MyNewDesign',          // Unique ID (used in logic)
  name: 'Minimalist Pro',     // Display Name
  description: 'Clean whitespace with a focus on typography.',
  thumbnailPath: 'assets/templates/minimalist_preview.png', 
  isPremium: true,            // Set to true to show "Lock" icon
  tags: ['Minimal', 'Clean'], // Filter tags
),
```

## Step 2: Add Assets
1.  Design a preview image (screenshot) of your template.
2.  Save it to `assets/templates/`.
3.  Ensure `pubspec.yaml` includes the assets directory (it usually does, e.g., `assets/`).

## Step 3: Implement PDF Rendering Logic
Define how the PDF actually looks when exported.

**File:** `lib/core/utils/pdf_generator.dart`

The `generateAndPrint` function receives `CVData`, which contains the `styleId`. Use this to switch layouts.

```dart
// logic inside generateAndPrint
final styleId = cvData.styleId;

switch (styleId) {
  case 'MyNewDesign':
    // Call your new layout builder
    return _buildMinimalistLayout(cvData);
  case 'Creative':
    return _buildCreativeLayout(cvData);
  default:
    // Fallback to standard
    return _buildStandardLayout(cvData);
}
```

### Pro Tip: Creating a New Layout Builder
Create a private method that returns a `pw.Widget` (usually a `pw.Column` or `pw.Row`) representing the page structure.

```dart
pw.Widget _buildMinimalistLayout(CVData data) {
  return pw.Column(
    children: [
      // Your custom high-end design here
      pw.Text(data.userProfile.fullName, style: ...),
      // ...
    ],
  );
}
```

## Step 4: Hot Restart
Restart the app to see your new template in the Gallery! 🎨

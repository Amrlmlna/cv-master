import 'package:flutter/widgets.dart';

class ImageSequenceLoader {
  static const int totalFrames = 123;
  static const String basePath = 'assets/sequence/ezgif-frame-';

  /// Pre-caches all images in the sequence to ensure smooth playback.
  static Future<void> precacheSequence(BuildContext context) async {
    for (int i = 1; i <= totalFrames; i++) {
      final String frameNumber = i.toString().padLeft(3, '0');
      final String path = '$basePath$frameNumber.jpg';
      await precacheImage(AssetImage(path), context);
    }
  }

  /// Helper to get the path for a specific frame index (0-based or 1-based, we'll handle mapping).
  /// [frameIndex] should be between 0 and totalFrames - 1.
  static String getPathForFrame(int frameIndex) {
    // Clamp to valid range
    int frame = frameIndex + 1; // Convert 0-based index to 1-based file naming
    if (frame < 1) frame = 1;
    if (frame > totalFrames) frame = totalFrames;
    
    final String frameNumber = frame.toString().padLeft(3, '0');
    return '$basePath$frameNumber.jpg';
  }
}

import 'package:cv_master/presentation/onboarding/utils/image_sequence_loader.dart';
import 'package:flutter/material.dart';

class OnboardingBackground extends StatelessWidget {
  final int frameIndex;

  const OnboardingBackground({
    super.key,
    required this.frameIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox.expand(
      child: Image.asset(
        ImageSequenceLoader.getPathForFrame(frameIndex),
        fit: BoxFit.cover,
        gaplessPlayback: true, // Critical for preventing flicker between frames
      ),
    );
  }
}

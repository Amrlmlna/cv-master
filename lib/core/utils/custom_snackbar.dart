import 'package:flutter/material.dart';
import 'dart:ui';

/// Custom SnackBar utilities for consistent app-wide notifications
class CustomSnackBar {
  static OverlayEntry? _currentEntry;

  /// Show a success snackbar
  static void showSuccess(BuildContext context, String message) {
    _show(context, message, Icons.check_circle_outline);
  }

  /// Show an error snackbar
  static void showError(BuildContext context, String message) {
    _show(context, message, Icons.error_outline);
  }

  /// Show an info snackbar
  static void showInfo(BuildContext context, String message) {
    _show(context, message, Icons.info_outline);
  }

  /// Show a warning snackbar
  static void showWarning(BuildContext context, String message) {
    _show(context, message, Icons.warning_amber_rounded);
  }

  static String _normalizeErrorMessage(String errorMsg) {
    if (errorMsg.contains('firebase_auth/email-already-in-use')) {
      return 'This email address is already in use by another account.';
    }
    if (errorMsg.contains('firebase_auth/invalid-credential') ||
        errorMsg.contains('firebase_auth/wrong-password')) {
      return 'Invalid email or password. Please try again.';
    }
    if (errorMsg.contains('firebase_auth/weak-password')) {
      return 'The password provided is too weak.';
    }
    if (errorMsg.contains('firebase_auth/too-many-requests')) {
      return 'Too many login attempts. Please try again later.';
    }
    if (errorMsg.contains('firebase_auth/user-not-found')) {
      return 'No user found with this email address.';
    }
    if (errorMsg.contains('firebase_auth/network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    }

    // Strip out the bracketed Firebase specific error codes if present
    final regex = RegExp(r'\[.*?\] \s*');
    final cleaned = errorMsg.replaceAll(regex, '').trim();

    if (cleaned.startsWith('Exception: ')) {
      return cleaned.substring(11); // Remove leading 'Exception: '
    }
    return cleaned;
  }

  /// Internal method to show styled snackbar
  static void _show(BuildContext context, String message, IconData icon) {
    final sanitizedMessage = _normalizeErrorMessage(message);

    // Remove existing if any
    _currentEntry?.remove();
    _currentEntry = null;

    final overlay = Overlay.of(context);
    final entry = OverlayEntry(
      builder: (context) => _TopSnackBar(
        message: sanitizedMessage,
        icon: icon,
        onDismissed: () {
          _currentEntry?.remove();
          _currentEntry = null;
        },
      ),
    );

    _currentEntry = entry;
    overlay.insert(entry);
  }
}

class _TopSnackBar extends StatefulWidget {
  final String message;
  final IconData icon;
  final VoidCallback onDismissed;

  const _TopSnackBar({
    required this.message,
    required this.icon,
    required this.onDismissed,
  });

  @override
  State<_TopSnackBar> createState() => _TopSnackBarState();
}

class _TopSnackBarState extends State<_TopSnackBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      reverseDuration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _offsetAnimation =
        Tween<Offset>(begin: const Offset(0.0, -1.0), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
            reverseCurve: Curves.easeInCubic,
          ),
        );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    );

    _controller.forward();

    Future.delayed(const Duration(seconds: 4), () {
      if (mounted) {
        _dismiss();
      }
    });
  }

  Future<void> _dismiss() async {
    await _controller.reverse();
    widget.onDismissed();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final topPadding = MediaQuery.of(context).padding.top;

    return Positioned(
      top: topPadding + 1,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.up,
          onDismissed: (_) {
            widget.onDismissed();
          },
          child: SlideTransition(
            position: _offsetAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 24.0, sigmaY: 24.0),
                  child: CustomPaint(
                    painter: _LiquidGlassSnackBarPainter(),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        // Very transparent dark base so the blur + highlights are visible
                        color: Colors.black.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.2),
                                width: 0.5,
                              ),
                            ),
                            child: Icon(
                              widget.icon,
                              color: Colors.white.withValues(alpha: 0.9),
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              widget.message,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Outfit',
                                height: 1.2,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Custom painter for liquid glass specular highlights and edge glow on the snackbar
class _LiquidGlassSnackBarPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;

    // Top-left specular highlight
    final specularPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(-0.5, -1.5),
        radius: 1.5,
        colors: [
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.06),
          Colors.transparent,
        ],
        stops: const [0.0, 0.35, 1.0],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      specularPaint,
    );

    // Bottom-right subtle warm glow
    final warmGlowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.8, 1.2),
        radius: 1.0,
        colors: [Colors.white.withValues(alpha: 0.08), Colors.transparent],
        stops: const [0.0, 1.0],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      warmGlowPaint,
    );

    // Top edge thin reflection line
    final topLinePaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, 0),
        end: const Alignment(1, 0),
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.4),
          Colors.white.withValues(alpha: 0.3),
          Colors.transparent,
        ],
        stops: const [0.0, 0.25, 0.5, 0.75, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 2));

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(size.width * 0.1, 0, size.width * 0.8, 1.0),
        topLeft: const Radius.circular(1),
        topRight: const Radius.circular(1),
      ),
      topLinePaint,
    );

    // Gradient border stroke
    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.08),
          Colors.white.withValues(alpha: 0.15),
        ],
      ).createShader(rect);

    canvas.drawRRect(
      RRect.fromRectAndRadius(rect, const Radius.circular(16)),
      borderPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

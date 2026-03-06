import 'package:flutter/material.dart';

class LiquidGlassSheetPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final rrect = RRect.fromRectAndCorners(
      rect,
      topLeft: const Radius.circular(28),
      topRight: const Radius.circular(28),
    );

    final specularPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.0, -1.2),
        radius: 1.5,
        colors: [
          Colors.white.withValues(alpha: 0.2),
          Colors.white.withValues(alpha: 0.04),
          Colors.transparent,
        ],
        stops: const [0.0, 0.4, 1.0],
      ).createShader(rect);
    canvas.drawRRect(rrect, specularPaint);

    final topLinePaint = Paint()
      ..shader = LinearGradient(
        begin: const Alignment(-1, 0),
        end: const Alignment(1, 0),
        colors: [
          Colors.transparent,
          Colors.white.withValues(alpha: 0.25),
          Colors.white.withValues(alpha: 0.35),
          Colors.white.withValues(alpha: 0.25),
          Colors.transparent,
        ],
        stops: const [0.0, 0.2, 0.5, 0.8, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, 2));

    canvas.drawRRect(
      RRect.fromRectAndCorners(
        Rect.fromLTWH(size.width * 0.1, 0, size.width * 0.8, 1.0),
        topLeft: const Radius.circular(1),
        topRight: const Radius.circular(1),
      ),
      topLinePaint,
    );

    final borderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.0
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.white.withValues(alpha: 0.05),
        ],
      ).createShader(rect);
    canvas.drawRRect(rrect, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

import 'dart:math';
import 'package:flutter/material.dart';
import '../utils/constants.dart';

class AppLogo extends StatelessWidget {
  final double size;

  const AppLogo({super.key, this.size = 80});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _LogoPainter()),
    );
  }
}

class _LogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background circle with gradient
    final bgPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          AppColors.primary,
          AppColors.primary.withValues(alpha: 0.8),
          const Color(0xFFE67300),
        ],
        stops: const [0.0, 0.6, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: radius));
    canvas.drawCircle(center, radius, bgPaint);

    // Glow effect
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.3),
          Colors.transparent,
        ],
      ).createShader(Rect.fromCircle(
        center: Offset(center.dx - radius * 0.25, center.dy - radius * 0.25),
        radius: radius * 0.7,
      ));
    canvas.drawCircle(center, radius, glowPaint);

    // Airplane
    final planePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    final planeScale = size.width / 100;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(-pi / 6);

    // Fuselage
    final fuselage = Path()
      ..moveTo(-30 * planeScale, 0)
      ..lineTo(-20 * planeScale, -3 * planeScale)
      ..lineTo(25 * planeScale, -2 * planeScale)
      ..lineTo(30 * planeScale, 0)
      ..lineTo(25 * planeScale, 2 * planeScale)
      ..lineTo(-20 * planeScale, 3 * planeScale)
      ..close();
    canvas.drawPath(fuselage, planePaint);

    // Wings
    final wing = Path()
      ..moveTo(-5 * planeScale, -2 * planeScale)
      ..lineTo(5 * planeScale, -20 * planeScale)
      ..lineTo(12 * planeScale, -18 * planeScale)
      ..lineTo(8 * planeScale, -2 * planeScale)
      ..close();
    canvas.drawPath(wing, planePaint);

    final wingBottom = Path()
      ..moveTo(-5 * planeScale, 2 * planeScale)
      ..lineTo(5 * planeScale, 20 * planeScale)
      ..lineTo(12 * planeScale, 18 * planeScale)
      ..lineTo(8 * planeScale, 2 * planeScale)
      ..close();
    canvas.drawPath(wingBottom, planePaint);

    // Tail
    final tail = Path()
      ..moveTo(-25 * planeScale, -3 * planeScale)
      ..lineTo(-30 * planeScale, -12 * planeScale)
      ..lineTo(-22 * planeScale, -10 * planeScale)
      ..lineTo(-20 * planeScale, -3 * planeScale)
      ..close();
    canvas.drawPath(tail, planePaint);

    canvas.restore();

    // Accent arc (travel trail)
    final trailPaint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5 * planeScale
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius * 0.65),
      pi * 0.7,
      pi * 0.8,
      false,
      trailPaint,
    );

    // Small dots on trail
    final dotPaint = Paint()..color = AppColors.accent;
    for (var i = 0; i < 3; i++) {
      final angle = pi * 0.7 + pi * 0.8 * (i + 1) / 4;
      final dx = center.dx + radius * 0.65 * cos(angle);
      final dy = center.dy + radius * 0.65 * sin(angle);
      canvas.drawCircle(Offset(dx, dy), 2 * planeScale, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

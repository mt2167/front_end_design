import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';

/// Thin filled line chart, e.g. the small graphs inside memory panels.
class SparklinePainter extends CustomPainter {
  final List<double> values;
  final Color color;
  final bool filled;

  SparklinePainter({
    required this.values,
    this.color = AppColors.cyan,
    this.filled = true,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (values.length < 2) return;
    final maxV = values.reduce(max);
    final minV = values.reduce(min);
    final range = (maxV - minV) == 0 ? 1 : (maxV - minV);
    final dx = size.width / (values.length - 1);

    final path = Path();
    for (int i = 0; i < values.length; i++) {
      final x = dx * i;
      final y = size.height - ((values[i] - minV) / range) * size.height;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    if (filled) {
      final fillPath = Path.from(path)
        ..lineTo(size.width, size.height)
        ..lineTo(0, size.height)
        ..close();
      final fillPaint = Paint()
        ..shader = LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [color.withOpacity(0.35), color.withOpacity(0.0)],
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height));
      canvas.drawPath(fillPath, fillPaint);
    }

    final linePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.3
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant SparklinePainter oldDelegate) => false;
}

/// Small vertical bar chart, e.g. long-term memory / code runner mini graphs.
class BarChartPainter extends CustomPainter {
  final List<double> values;
  final Color color;

  BarChartPainter({required this.values, this.color = AppColors.cyan});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final maxV = values.reduce(max);
    final barWidth = size.width / (values.length * 1.6);
    final gap = barWidth * 0.6;
    final paint = Paint()..color = color.withOpacity(0.85);

    for (int i = 0; i < values.length; i++) {
      final h = maxV == 0 ? 0.0 : (values[i] / maxV) * size.height;
      final x = i * (barWidth + gap);
      final rect = Rect.fromLTWH(x, size.height - h, barWidth, h);
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, const Radius.circular(0.5)),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant BarChartPainter oldDelegate) => false;
}

/// Voice waveform bars, center-aligned like an audio visualizer.
class WaveformPainter extends CustomPainter {
  final List<double> values; // each 0..1
  final Color color;

  WaveformPainter({required this.values, this.color = AppColors.cyan});

  @override
  void paint(Canvas canvas, Size size) {
    if (values.isEmpty) return;
    final barWidth = size.width / (values.length * 1.8);
    final gap = barWidth * 0.8;
    final centerY = size.height / 2;

    for (int i = 0; i < values.length; i++) {
      final h = (values[i].clamp(0.05, 1.0)) * size.height;
      final x = i * (barWidth + gap) + barWidth / 2;
      final paint = Paint()
        ..color = color.withOpacity(0.35 + 0.65 * values[i])
        ..strokeCap = StrokeCap.round
        ..strokeWidth = barWidth.clamp(1.2, 4.0);
      canvas.drawLine(
        Offset(x, centerY - h / 2),
        Offset(x, centerY + h / 2),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant WaveformPainter oldDelegate) => false;
}

/// Circular progress gauge used for the SYSTEM OVERVIEW health ring.
class GaugePainter extends CustomPainter {
  final double value; // 0..1
  final Color color;
  final double strokeWidth;

  GaugePainter({
    required this.value,
    this.color = AppColors.cyan,
    this.strokeWidth = 5,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = min(size.width, size.height) / 2 - strokeWidth / 2;

    final trackPaint = Paint()
      ..color = AppColors.barTrack
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);

    final valuePaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * pi * value.clamp(0.0, 1.0);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi / 2,
      sweep,
      false,
      valuePaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) =>
      oldDelegate.value != value;
}

/// Small connected-node graph, e.g. knowledge graph / multi-agent panels.
class NetworkGraphPainter extends CustomPainter {
  final int nodeCount;
  final Color color;
  final int seed;

  NetworkGraphPainter({
    this.nodeCount = 14,
    this.color = AppColors.cyan,
    this.seed = 7,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final rnd = Random(seed);
    final points = List.generate(
      nodeCount,
      (_) => Offset(rnd.nextDouble() * size.width, rnd.nextDouble() * size.height),
    );

    final linePaint = Paint()
      ..color = color.withOpacity(0.25)
      ..strokeWidth = 0.8;

    for (int i = 0; i < points.length; i++) {
      for (int j = i + 1; j < points.length; j++) {
        final d = (points[i] - points[j]).distance;
        if (d < size.width * 0.4) {
          canvas.drawLine(points[i], points[j], linePaint);
        }
      }
    }

    final dotPaint = Paint()..color = color;
    for (final p in points) {
      canvas.drawCircle(p, 2.0, dotPaint);
    }
  }

  @override
  bool shouldRepaint(covariant NetworkGraphPainter oldDelegate) => false;
}

/// The large central "AI Core" neural sphere visual.
class NeuralSpherePainter extends CustomPainter {
  final int seed;

  NeuralSpherePainter({this.seed = 42});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;
    final rnd = Random(seed);

    // Outer segmented rings.
    for (final ringFactor in [0.98, 0.84, 0.68]) {
      final radius = maxRadius * ringFactor;
      final ringPaint = Paint()
        ..color = AppColors.cyan.withOpacity(0.16)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1;
      const segments = 44;
      for (int i = 0; i < segments; i++) {
        if (i % 3 == 0) continue;
        final a1 = (i / segments) * 2 * pi;
        final a2 = ((i + 0.6) / segments) * 2 * pi;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          a1,
          a2 - a1,
          false,
          ringPaint,
        );
      }
    }

    // One brighter accent ring with a couple of thicker highlighted arcs.
    final accentPaint = Paint()
      ..color = AppColors.cyanBright.withOpacity(0.55)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius * 0.98),
      0.2,
      0.5,
      false,
      accentPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius * 0.98),
      3.4,
      0.4,
      false,
      accentPaint,
    );

    // Radiating particle branches, mostly cyan with a few warm accents.
    const branchCount = 110;
    for (int i = 0; i < branchCount; i++) {
      final angle = rnd.nextDouble() * 2 * pi;
      final length = maxRadius * (0.22 + rnd.nextDouble() * 0.72);
      final isOrange = rnd.nextDouble() < 0.1;
      final color = isOrange ? AppColors.orange : AppColors.cyan;
      final opacity = 0.15 + rnd.nextDouble() * 0.55;

      final end = Offset(
        center.dx + cos(angle) * length,
        center.dy + sin(angle) * length,
      );

      final linePaint = Paint()
        ..color = color.withOpacity(opacity * 0.55)
        ..strokeWidth = 0.7;
      canvas.drawLine(center, end, linePaint);

      final dotPaint = Paint()..color = color.withOpacity((opacity + 0.25).clamp(0.0, 1.0));
      canvas.drawCircle(end, isOrange ? 1.8 : 1.3, dotPaint);
    }

    // Center glow.
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withOpacity(0.95),
          AppColors.cyanBright.withOpacity(0.55),
          AppColors.cyan.withOpacity(0.0),
        ],
        stops: const [0.0, 0.28, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: maxRadius * 0.35));
    canvas.drawCircle(center, maxRadius * 0.35, glowPaint);

    canvas.drawCircle(center, 5, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant NeuralSpherePainter oldDelegate) => false;
}

/// Simple dashed connector line, horizontal or vertical.
class DashedLinePainter extends CustomPainter {
  final Axis direction;
  final Color color;

  DashedLinePainter({
    this.direction = Axis.horizontal,
    this.color = AppColors.panelBorderBright,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashLength = 4.0;
    const gapLength = 4.0;

    if (direction == Axis.horizontal) {
      double x = 0;
      final y = size.height / 2;
      while (x < size.width) {
        canvas.drawLine(Offset(x, y), Offset(x + dashLength, y), paint);
        x += dashLength + gapLength;
      }
    } else {
      double y = 0;
      final x = size.width / 2;
      while (y < size.height) {
        canvas.drawLine(Offset(x, y), Offset(x, y + dashLength), paint);
        y += dashLength + gapLength;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedLinePainter oldDelegate) => false;
}

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../theme.dart';

/// A single neuron in the projected neural sphere.
class _Neuron {
  final double angle;
  final double radiusFrac; // 0..1, distance from center as fraction of maxRadius
  final double sizeFactor; // relative node size
  final double phase; // for pulsing animation
  final bool warm; // orange accent vs cyan

  _Neuron({
    required this.angle,
    required this.radiusFrac,
    required this.sizeFactor,
    required this.phase,
    required this.warm,
  });
}

/// A directed synapse connection between two neurons, with a traveling pulse.
class _Synapse {
  final int from;
  final int to;
  final double phase;
  final double speed;

  _Synapse({
    required this.from,
    required this.to,
    required this.phase,
    required this.speed,
  });
}

Offset _quadraticPoint(Offset p0, Offset c, Offset p2, double t) {
  final u = 1 - t;
  final x = u * u * p0.dx + 2 * u * t * c.dx + t * t * p2.dx;
  final y = u * u * p0.dy + 2 * u * t * c.dy + t * t * p2.dy;
  return Offset(x, y);
}

/// Animated neural-network sphere: rotating rings, breathing core glow,
/// neuron nodes connected by curved synapses with traveling signal pulses.
class NeuralNetPainter extends CustomPainter {
  final double time;
  final int neuronCount;
  final int seed;

  NeuralNetPainter({
    required this.time,
    this.neuronCount = 50,
    this.seed = 42,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 1.5;
    final rnd = Random(seed);

    // ---- Rotating segmented outer rings ----
    for (int ringIdx = 0; ringIdx < 4; ringIdx++) {
      final ringFactor = [1.0, 0.88, 0.8, 0.70][ringIdx];
      final rotSpeed = [0.05, -0.08, 0.11, -0.14][ringIdx];
      final radius = maxRadius * ringFactor;
      final ringPaint = Paint()
        ..color = AppColors.cyan.withValues(alpha: 0.4)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.3;
      const segments = 44;
      final rotation = time * rotSpeed * 2 * pi;
      for (int i = 0; i < segments; i++) {
        if (i % 3 == 0) continue;
        final a1 = (i / segments) * 2 * pi + rotation;
        final a2 = ((i + 0.6) / segments) * 2 * pi + rotation;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: radius),
          a1,
          a2 - a1,
          false,
          ringPaint,
        );
      }
    }

    // One brighter accent ring with sweeping highlight arcs.
    final accentPaint = Paint()
      ..color = AppColors.cyanBright.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.8
      ..strokeCap = StrokeCap.round;
    final sweep = time * 0.16 * 2 * pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius * 1),
      sweep,
      0.5,
      false,
      accentPaint,
    );
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: maxRadius * 1),
      sweep + pi,
      0.35,
      false,
      accentPaint,
    );

    // ---- Generate neurons (deterministic layout, animated pulsing) ----
    final neurons = <_Neuron>[];
    for (int i = 0; i < neuronCount; i++) {
      // Bias distribution: dense cluster near center, sparser toward edge.
      final rBias = pow(rnd.nextDouble(), 1.15).toDouble();
      neurons.add(_Neuron(
        angle: rnd.nextDouble() * 2 * pi,
        radiusFrac: 0.16 + rBias * 0.8,
        sizeFactor: 1.4 + rnd.nextDouble() * 1.8,
        phase: rnd.nextDouble() * 2 * pi,
        warm: rnd.nextDouble() < 0.1,
      ));
    }

    Offset neuronPos(_Neuron n) {
      final wobble = sin(time * 0.6 + n.phase) * 0.015;
      final r = maxRadius * (n.radiusFrac + wobble);
      return Offset(
        center.dx + cos(n.angle) * r,
        center.dy + sin(n.angle) * r,
      );
    }

    final positions = neurons.map(neuronPos).toList();

    // ---- Connect nearby neurons with curved synapses ----
    final synapses = <_Synapse>[];
    final connectThreshold = maxRadius * 0.22;
    for (int i = 0; i < neurons.length; i++) {
      int connections = 0;
      for (int j = i + 1; j < neurons.length && connections < 2; j++) {
        final d = (positions[i] - positions[j]).distance;
        if (d < connectThreshold && rnd.nextDouble() < 0.42) {
          synapses.add(_Synapse(
            from: i,
            to: j,
            phase: rnd.nextDouble(),
            speed: 0.25 + rnd.nextDouble() * 0.4,
          ));
          connections++;
        }
      }
    }

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.9;

    final controlPoints = <Offset>[];
    for (final s in synapses) {
      final p0 = positions[s.from];
      final p2 = positions[s.to];
      final mid = Offset.lerp(p0, p2, 0.5)!;
      final normal = Offset(-(p2.dy - p0.dy), p2.dx - p0.dx);
      final normalLen = normal.distance == 0 ? 1.0 : normal.distance;
      final wobble = sin(time * 0.8 + s.phase * 10) * (p0 - p2).distance * 0.08;
      final control = mid + (normal / normalLen) * wobble;
      controlPoints.add(control);

      final path = Path()
        ..moveTo(p0.dx, p0.dy)
        ..quadraticBezierTo(control.dx, control.dy, p2.dx, p2.dy);
      canvas.drawPath(path, linePaint..color = AppColors.cyan.withValues(alpha: 0.12));
    }

    // ---- Traveling signal pulses along a subset of synapses ----
    final pulsePaint = Paint();
    for (int i = 0; i < synapses.length; i++) {
      if (i % 3 != 0) continue; // only fire on a subset of synapses
      final s = synapses[i];
      final p0 = positions[s.from];
      final p2 = positions[s.to];
      final control = controlPoints[i];
      final t = ((time * s.speed) + s.phase) % 1.0;
      final pos = _quadraticPoint(p0, control, p2, t);
      final fade = sin(t * pi); // fades in/out along the path
      pulsePaint.color = AppColors.cyanBright.withValues(alpha: 0.8 * fade.clamp(0.0, 1.0));
      canvas.drawCircle(pos, 2.4, pulsePaint);
    }

    // ---- Draw neuron nodes ----
    for (int i = 0; i < neurons.length; i++) {
      final n = neurons[i];
      final pos = positions[i];
      final pulse = 0.7 + 0.3 * sin(time * 2 + n.phase);
      final color = n.warm ? AppColors.orange : AppColors.cyan;
      final distFromCenter = n.radiusFrac;
      final brightness = (1.0 - distFromCenter * 0.6).clamp(0.3, 1.0);

      final glowPaint = Paint()
        ..color = color.withValues(alpha: 0.16 * brightness)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3.5);
      canvas.drawCircle(pos, n.sizeFactor * 4.5 * pulse, glowPaint);

      final dotPaint = Paint()..color = color.withValues(alpha: (0.55 + 0.4 * pulse) * brightness);
      canvas.drawCircle(pos, n.sizeFactor * 1.9, dotPaint);
    }

    // ---- Central breathing glow + core ----
    final breath = 1.0 + 0.09 * sin(time * 1.8);
    final glowRadius = maxRadius * 0.36 * breath;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: 0.95),
          AppColors.cyanBright.withValues(alpha: 0.55),
          AppColors.cyan.withValues(alpha: 0.0),
        ],
        stops: const [0.0, 0.28, 1.0],
      ).createShader(Rect.fromCircle(center: center, radius: glowRadius));
    canvas.drawCircle(center, glowRadius, glowPaint);

    canvas.drawCircle(center, 7 * breath, Paint()..color = Colors.white);
  }

  @override
  bool shouldRepaint(covariant NeuralNetPainter oldDelegate) => true;
}

/// Ticker-driven wrapper that repaints [NeuralNetPainter] every frame.
class NeuralCore extends StatefulWidget {
  const NeuralCore({super.key});

  @override
  State<NeuralCore> createState() => _NeuralCoreState();
}

class _NeuralCoreState extends State<NeuralCore> with SingleTickerProviderStateMixin {
  late final Ticker _ticker;
  double _time = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker((elapsed) {
      setState(() {
        _time = elapsed.inMicroseconds / 1000000.0;
      });
    });
    _ticker.start();
  }

  @override
  void dispose() {
    _ticker.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: NeuralNetPainter(time: _time),
      size: Size.infinite,
    );
  }
}
import 'dart:math';
import 'package:flutter/material.dart';
import '../theme.dart';

enum ConnectorDirection { towardRight, towardLeft }

/// A slim vertical lane of animated "synapse" connectors: a node near the
/// panel-side edge, a dashed line, and a traveling pulse toward the core.
/// [weights] approximate the relative height of each panel it lines up
/// with, so the nodes are spaced similarly to the panels beside them.
class ConnectorLane extends StatelessWidget {
  final List<int> weights;
  final ConnectorDirection direction;
  final double time;

  const ConnectorLane({
    super.key,
    required this.weights,
    required this.direction,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 22,
      height: double.infinity,
      child: Column(
        children: [
          for (int i = 0; i < weights.length; i++)
            Expanded(
              flex: weights[i],
              child: CustomPaint(
                size: Size.infinite,
                painter: _ConnectorSegmentPainter(
                  direction: direction,
                  time: time,
                  phase: i / weights.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _ConnectorSegmentPainter extends CustomPainter {
  final ConnectorDirection direction;
  final double time;
  final double phase;

  _ConnectorSegmentPainter({
    required this.direction,
    required this.time,
    required this.phase,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final panelX = direction == ConnectorDirection.towardRight ? 2.0 : size.width - 2.0;
    final coreX = direction == ConnectorDirection.towardRight ? size.width - 2.0 : 2.0;
    final y = size.height / 2;

    final nodeCenter = Offset(panelX, y);
    final coreEdge = Offset(coreX, y);

    // Node at the panel-side edge.
    final nodePulse = 0.6 + 0.4 * sin(time * 2.2 + phase * 10);
    canvas.drawCircle(
      nodeCenter,
      2.6,
      Paint()..color = AppColors.cyan.withOpacity(0.3 + 0.3 * nodePulse),
    );
    canvas.drawCircle(
      nodeCenter,
      1.1,
      Paint()..color = AppColors.cyanBright.withOpacity(0.8),
    );

    // Dashed line from node toward the core.
    final dashPaint = Paint()
      ..color = AppColors.panelBorderBright.withOpacity(0.7)
      ..strokeWidth = 1;
    const dashLen = 3.0;
    const gapLen = 3.0;
    final dx = coreEdge.dx - nodeCenter.dx;
    final totalLen = dx.abs();
    double covered = 0;
    final dir = dx.sign;
    while (covered < totalLen) {
      final segLen = min(dashLen, totalLen - covered);
      final startX = nodeCenter.dx + dir * covered;
      final endX = nodeCenter.dx + dir * (covered + segLen);
      canvas.drawLine(Offset(startX, y), Offset(endX, y), dashPaint);
      covered += dashLen + gapLen;
    }

    // Traveling pulse moving from node toward the core.
    final t = (time * 0.35 + phase) % 1.0;
    final pulseX = nodeCenter.dx + dir * totalLen * t;
    final fade = sin(t * pi).clamp(0.0, 1.0);
    canvas.drawCircle(
      Offset(pulseX, y),
      1.5,
      Paint()..color = AppColors.cyanBright.withOpacity(0.85 * fade),
    );
  }

  @override
  bool shouldRepaint(covariant _ConnectorSegmentPainter oldDelegate) => true;
}

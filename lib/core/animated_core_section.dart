import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'connector_lane.dart';
import 'neural_core.dart';

/// The full animated centerpiece: left connector lane (toward panels) +
/// the neural sphere + right connector lane, all driven by one shared
/// clock so the pulses feel like one connected system.
class AnimatedCoreSection extends StatefulWidget {
  final List<int> leftWeights;
  final List<int> rightWeights;

  const AnimatedCoreSection({
    super.key,
    required this.leftWeights,
    required this.rightWeights,
  });

  @override
  State<AnimatedCoreSection> createState() => _AnimatedCoreSectionState();
}

class _AnimatedCoreSectionState extends State<AnimatedCoreSection>
    with SingleTickerProviderStateMixin {
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
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ConnectorLane(
          weights: widget.leftWeights,
          direction: ConnectorDirection.towardRight,
          time: _time,
        ),
        const SizedBox(width: 4),
        const Expanded(child: NeuralCore()),
        const SizedBox(width: 4),
        ConnectorLane(
          weights: widget.rightWeights,
          direction: ConnectorDirection.towardLeft,
          time: _time,
        ),
      ],
    );
  }
}

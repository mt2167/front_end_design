import 'package:flutter/material.dart';
import '../theme.dart';

/// Standard bordered panel used throughout the dashboard.
class PanelContainer extends StatelessWidget {
  final String title;
  final Widget child;
  final bool showMenu;

  const PanelContainer({
    super.key,
    required this.title,
    required this.child,
    this.showMenu = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
      decoration: panelDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: AppText.panelTitle),
              if (showMenu)
                const Icon(Icons.more_horiz,
                    color: AppColors.mutedBlueDark, size: 16),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

/// Circular outlined icon, used for panel avatars (mic, db, shield, etc).
class IconBadge extends StatelessWidget {
  final IconData icon;
  final double size;
  final Color color;

  const IconBadge({
    super.key,
    required this.icon,
    this.size = 54,
    this.color = AppColors.cyan,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color.withValues(alpha: 0.55), width: 1.4),
      ),
      child: Center(
        child: Icon(icon, color: color, size: size * 0.4),
      ),
    );
  }
}

/// Thin horizontal progress bar (memory usage, CPU load, etc).
class ProgressBarThin extends StatelessWidget {
  final double value; // 0..1
  final Color color;
  final double height;

  const ProgressBarThin({
    super.key,
    required this.value,
    this.color = AppColors.cyan,
    this.height = 4,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(4),
      child: Container(
        height: height,
        color: AppColors.barTrack,
        alignment: Alignment.centerLeft,
        child: FractionallySizedBox(
          widthFactor: value.clamp(0.0, 1.0),
          child: Container(color: color),
        ),
      ),
    );
  }
}

/// Label above value, e.g. "CONTEXT WINDOW / 16K TOKENS".
class LabeledValue extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;
  final double valueFontSize;

  const LabeledValue({
    super.key,
    required this.label,
    required this.value,
    this.valueColor = AppColors.white,
    this.valueFontSize = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(height: 4),
        Text(
          value,
          style: AppText.valueSmall.copyWith(
            color: valueColor,
            fontSize: valueFontSize,
          ),
        ),
      ],
    );
  }
}

/// Two LabeledValue columns side by side, e.g. ENTRIES / USAGE.
class StatPair extends StatelessWidget {
  final Widget first;
  final Widget second;

  const StatPair({super.key, required this.first, required this.second});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        Expanded(child: second),
      ],
    );
  }
}

/// 4 LabeledValue columns side by side, e.g. ENTRIES / USAGE.
class MultiStat extends StatelessWidget {
  final Widget first;
  final Widget second;
  final Widget third;
  final Widget fourth;

  const MultiStat({
    super.key, 
    required this.first, 
    required this.second,
    required this.third,
    required this.fourth
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: first),
        Expanded(child: second),
        Expanded(child: third),
        Expanded(child: fourth),
      ],
    );
  }
}

/// Tool Hub grid icon tile.
class IconTile extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconTile({super.key, required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.panelFillAlt,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AppColors.panelBorder, width: 0.8),
      ),
      child: Column(
        children: [
          Icon(icon, color: AppColors.cyan, size: 16),
          const SizedBox(height: 6),
          Text(
            label,
            style: AppText.label.copyWith(fontSize: 7.2),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Advisor agent avatar with role + online status.
class AgentAvatar extends StatelessWidget {
  final IconData icon;
  final String name;
  final String role;

  const AgentAvatar({
    super.key,
    required this.icon,
    required this.name,
    required this.role,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.cyan.withValues(alpha: 0.6), width: 1.2),
          ),
          child: Icon(icon, color: AppColors.cyan, size: 19),
        ),
        const SizedBox(height: 8),
        Text(name, style: AppText.valueSmall.copyWith(fontSize: 10.5)),
        const SizedBox(height: 2),
        Text(role, style: AppText.sublabel, textAlign: TextAlign.center),
        const SizedBox(height: 5),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration:
                  const BoxDecoration(color: AppColors.green, shape: BoxShape.circle),
            ),
            const SizedBox(width: 4),
            const Text('ONLINE', style: AppText.greenTag),
          ],
        ),
      ],
    );
  }
}

/// Single row inside the Action Logs table.
class LogRow extends StatelessWidget {
  final String time;
  final String event;
  final String source;

  const LogRow({
    super.key,
    required this.time,
    required this.event,
    required this.source,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 42, child: Text(time, style: AppText.label)),
          Expanded(
            flex: 4,
            child: Text(
              event,
              style: AppText.valueSmall.copyWith(fontSize: 10.5),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Expanded(
            flex: 2,
            child: Text(source, style: AppText.label),
          ),
          const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle, color: AppColors.green, size: 11),
              SizedBox(width: 3),
              Text('Success', style: AppText.greenTag),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small mini-chart wrapper with fixed size, used everywhere for consistency.
class MiniChart extends StatelessWidget {
  final CustomPainter painter;
  final double width;
  final double height;

  const MiniChart({
    super.key,
    required this.painter,
    this.width = 90,
    this.height = 34,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(painter: painter),
    );
  }
}

/// Top bar item: label + colored dot + value (e.g. "SYSTEM STATUS  OPTIMAL").
class TopBarItem extends StatelessWidget {
  final String label;
  final String value;
  final Color dotColor;

  const TopBarItem({
    super.key,
    required this.label,
    required this.value,
    this.dotColor = AppColors.cyan,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(width: 8),
        Container(
          width: 5,
          height: 5,
          decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle),
        ),
        const SizedBox(width: 5),
        Text(value, style: AppText.cyanTag.copyWith(color: dotColor)),
      ],
    );
  }
}

/// Top bar item with an inline progress bar (memory / CPU).
class TopBarProgressItem extends StatelessWidget {
  final String label;
  final String value;
  final double progress;

  const TopBarProgressItem({
    super.key,
    required this.label,
    required this.value,
    required this.progress,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label, style: AppText.label),
        const SizedBox(width: 8),
        Text(value, style: AppText.valueSmall.copyWith(fontSize: 11)),
        const SizedBox(width: 8),
        SizedBox(
          width: 56,
          child: ProgressBarThin(value: progress),
        ),
      ],
    );
  }
}

/// Thin vertical divider used between top bar sections.
class VDivider extends StatelessWidget {
  const VDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 20,
      color: AppColors.panelBorder,
    );
  }
}

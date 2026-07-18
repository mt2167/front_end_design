import 'package:flutter/material.dart';
import '../../theme.dart';
import '../../core/widgets.dart';
import '../../core/painters.dart';
import '../../core/animated_core_section.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.background, AppColors.backgroundEnd],
          ),
        ),
        child: const SafeArea(
          child: Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _TopBar(),
                SizedBox(height: 14),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(flex: 3, child: _LeftColumn()),
                      SizedBox(width: 14),
                      Expanded(flex: 5, child: _CenterColumn()),
                      SizedBox(width: 14),
                      Expanded(flex: 3, child: _RightColumn()),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// TOP BAR
// ---------------------------------------------------------------------------

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
      decoration: panelDecoration,
      child: Row(
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.cyan, width: 1.2),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(Icons.hub_outlined, color: AppColors.cyan, size: 15),
          ),
          const SizedBox(width: 10),
          RichText(
            text: const TextSpan(children: [
              TextSpan(text: 'J.A.R.V.I.S. ', style: AppText.brand),
              TextSpan(text: 'AI OS', style: AppText.brandAccent),
            ]),
          ),
          const SizedBox(width: 8),
          const Text('v7.3.1', style: AppText.label),
          const SizedBox(width: 20),
          const VDivider(),
          const SizedBox(width: 20),
          const TopBarItem(
            label: 'SYSTEM STATUS',
            value: 'OPTIMAL',
            dotColor: AppColors.green,
          ),
          const SizedBox(width: 20),
          const VDivider(),
          const SizedBox(width: 20),
          const TopBarItem(
            label: 'ACTIVE MODEL',
            value: 'NEXUS-9 ULTRA',
            dotColor: AppColors.cyan,
          ),
          const SizedBox(width: 20),
          const VDivider(),
          const SizedBox(width: 20),
          const TopBarProgressItem(
            label: 'MEMORY USAGE',
            value: '42%',
            progress: 0.42,
          ),
          const SizedBox(width: 20),
          const VDivider(),
          const SizedBox(width: 20),
          const TopBarProgressItem(
            label: 'CPU LOAD',
            value: '28%',
            progress: 0.28,
          ),
          const Spacer(),
          const Text('UPTIME', style: AppText.label),
          const SizedBox(width: 8),
          Text('12d 04h 32m', style: AppText.valueSmall.copyWith(fontSize: 11)),
          const SizedBox(width: 22),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('09:42:17', style: AppText.valueSmall.copyWith(fontSize: 11)),
              const SizedBox(height: 2),
              const Text('MAY 24, 2025', style: TextStyle(color: AppColors.mutedBlue, fontSize: 7)),
            ],
          ),
          const SizedBox(width: 16),
          const Icon(Icons.notifications_none, color: AppColors.mutedBlue, size: 16),
          const SizedBox(width: 12),
          const Icon(Icons.settings_outlined, color: AppColors.mutedBlue, size: 16),
          const SizedBox(width: 12),
          const Icon(Icons.power_settings_new, color: AppColors.mutedBlue, size: 16),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// LEFT COLUMN
// ---------------------------------------------------------------------------

class _LeftColumn extends StatelessWidget {
  const _LeftColumn();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _systemOverviewPanel(),
          const SizedBox(height: 12),
          _voicePipelinePanel(),
          const SizedBox(height: 12),          
          _memorySnapShotPanel(),
          const SizedBox(height: 12),
          _semanticMemoryPanel(),
          const SizedBox(height: 12),
          _knowledgeGraphPanel(),
          const SizedBox(height: 12),
          _actionLogsPanel(),
        ],
      ),
    );
  }

  Widget _voicePipelinePanel() {
    return PanelContainer(
      title: 'VOICE PIPELINE',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const IconBadge(icon: Icons.mic_none, size: 54),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Listening...', style: AppText.valueSmall),
                        Text('WAKE WORD: JARVIS', style: AppText.label),
                      ],
                    ),
                    const SizedBox(height: 8),
                    MiniChart(
                      width: double.infinity,
                      height: 30,
                      painter: WaveformPainter(
                        values: const [
                          0.2, 0.4, 0.7, 0.5, 0.9, 0.6, 0.3, 0.8, 1.0, 0.6,
                          0.4, 0.7, 0.5, 0.3, 0.6, 0.9, 0.4, 0.2, 0.5, 0.3,
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text('STATUS', style: AppText.label),
          const SizedBox(height: 6),
          Row(
            children: List.generate(14, (i) {
              return Expanded(
                child: Container(
                  height: 5,
                  margin: const EdgeInsets.only(right: 3),
                  decoration: BoxDecoration(
                    color: i < 9 ? AppColors.cyan : AppColors.barTrack,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
          const SizedBox(height: 6),
          const Text('ACTIVE', style: AppText.greenTag),
        ],
      ),
    );
  }

  Widget _systemOverviewPanel() {
    return PanelContainer(
      title: 'SYSTEM OVERVIEW',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.donut_large, size: 50),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                LabeledValue(label: 'CURRENT OBJECTIVE', value: 'A PROJECT', valueFontSize: 10),
                SizedBox(height: 8),                
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('SYSTEM HEALTH', style: AppText.label),
                    Text('100%', style: AppText.valueSmall),
                  ],
                ),
                SizedBox(height: 4),
                ProgressBarThin(value: 0.99),
              ],
            ),
          ),
          const SizedBox(width: 20), 
          const LabeledValue(label: 'REASONING STATE', value: 'DEEP ANALYSIS', valueFontSize: 10),
          const SizedBox(width: 20), 
          const LabeledValue(label: 'ACTIVE MODEL', value: 'A MODEL', valueFontSize: 10),
          const SizedBox(width: 8),          
          MiniChart(
            width: 60,
            height: 34,
            painter: SparklinePainter(values: const [2, 4, 3, 5, 4, 6, 5, 7, 6, 8]),
          ),
        ],
      ),
    );
  }

  Widget _memorySnapShotPanel() {
    return PanelContainer(
      title: 'MEMORY SNAPSHOT',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.storage, size: 50),
          const SizedBox(width: 14),
          const Expanded(
            child: MultiStat(
              first: LabeledValue(label: 'WORKING MEMORY', value: '2.4M'),
              second: LabeledValue(label: 'LONG-TERM MEMORY', value: '42%'),
              third: LabeledValue(label: 'SEMANTIC RETRIVAL', value: '2.4M'),
              fourth: LabeledValue(label: 'KNOWLEDGE GRAPH ACTIVITY', value: '42%'),
            ),
          ),
          const SizedBox(width: 8),
          MiniChart(
            width: 60,
            height: 34,
            painter: BarChartPainter(
              values: const [3, 6, 4, 8, 5, 9, 6, 10, 7, 12, 8, 11],
            ),
          ),
        ],
      ),
    );
  }

  Widget _semanticMemoryPanel() {
    return PanelContainer(
      title: 'SEMANTIC MEMORY',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.hub_outlined, size: 50),
          const SizedBox(width: 14),
          const Expanded(
            child: StatPair(
              first: LabeledValue(label: 'CONCEPTS', value: '128K'),
              second: LabeledValue(label: 'LINKS', value: '3.7M'),
            ),
          ),
          const SizedBox(width: 8),
          MiniChart(
            width: 60,
            height: 34,
            painter: SparklinePainter(
              values: const [3, 6, 2, 7, 3, 8, 4, 6, 5, 9],
              filled: false,
            ),
          ),
        ],
      ),
    );
  }

  Widget _knowledgeGraphPanel() {
    return PanelContainer(
      title: 'KNOWLEDGE GRAPH',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiniChart(
            width: 56,
            height: 56,
            painter: NetworkGraphPainter(nodeCount: 12, seed: 3),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: StatPair(
              first: LabeledValue(label: 'NODES', value: '9.8M'),
              second: LabeledValue(label: 'RELATIONSHIPS', value: '24.6M'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _actionLogsPanel() {
    final logs = [
      ('09:42:10', 'User Command: Open Project Atlas', 'Voice'),
      ('09:42:08', 'Code Runner: Build & Test', 'Agent'),
      ('09:42:05', 'Web Search: Latest AI News', 'Browser'),
      ('09:42:02', 'Memory Update: Project Notes', 'Memory'),
      ('09:41:59', 'Home Control: Lights Adjusted', 'Home'),
    ];

    return PanelContainer(
      title: 'ACTION LOGS',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              SizedBox(width: 42, child: Text('TIME', style: AppText.label)),
              Expanded(flex: 4, child: Text('EVENT', style: AppText.label)),
              Expanded(flex: 2, child: Text('SOURCE', style: AppText.label)),
              Text('STATUS', style: AppText.label),
            ],
          ),
          const Divider(color: AppColors.panelBorder, height: 14),
          for (final log in logs)
            LogRow(time: log.$1, event: log.$2, source: log.$3),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// CENTER COLUMN
// ---------------------------------------------------------------------------

class _CenterColumn extends StatelessWidget {
  const _CenterColumn();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _aiCoreHeader(),
        const SizedBox(height: 6),
        const Expanded(
          child: AnimatedCoreSection(
            // Rough relative heights of the left/right panels, so the
            // connector nodes land at approximately the right vertical
            // position next to the panel they represent.
            leftWeights: [13, 10, 10, 10, 10, 15],
            rightWeights: [20, 10, 10, 10, 10, 12],
          ),
        ),
        const SizedBox(height: 6),
        _cognitiveLoadBar(),
        const SizedBox(height: 10),
        _systemOverviewPanel(),
        const SizedBox(height: 10),
        _advisorAgentsPanel(),
      ],
    );
  }

  Widget _aiCoreHeader() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.panelBorderBright, width: 1),
          borderRadius: BorderRadius.circular(20),
          color: AppColors.panelFill,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: const TextSpan(children: [
                TextSpan(text: 'AI CORE ', style: AppText.brand),
                TextSpan(text: '· NEURAL NETWORK', style: AppText.brandAccent),
              ]),
            ),
            const SizedBox(height: 2),
            const Text(
              'ACTIVE  ·  THINKING  ·  LEARNING',
              style: AppText.label,
            ),
          ],
        ),
      ),
    );
  }

  Widget _cognitiveLoadBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: panelDecoration,
      child: Row(
        children: [
          const Text('COGNITIVE LOAD', style: AppText.label),
          const SizedBox(width: 12),
          const Text('67%', style: AppText.valueSmall),
          const SizedBox(width: 12),
          const Expanded(child: ProgressBarThin(value: 0.67, height: 5)),
          const SizedBox(width: 12),
          MiniChart(
            width: 70,
            height: 20,
            painter: WaveformPainter(
              values: const [0.3, 0.6, 0.4, 0.8, 0.5, 0.7, 0.3, 0.6, 0.9, 0.4],
            ),
          ),
        ],
      ),
    );
  }

  Widget _systemOverviewPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: panelDecoration,
      child: Column(
        children: [
          const Text('SYSTEM OVERVIEW', style: AppText.panelTitle),
          const SizedBox(height: 14),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledValue(label: 'TASKS', value: '32'),
                    SizedBox(height: 2),
                    Text('ACTIVE', style: AppText.label),
                  ],
                ),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledValue(label: 'AGENTS', value: '8'),
                    SizedBox(height: 2),
                    Text('ONLINE', style: AppText.label),
                  ],
                ),
              ),
              SizedBox(
                width: 92,
                height: 92,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    MiniChart(
                      width: 92,
                      height: 92,
                      painter: GaugePainter(value: 1.0, color: AppColors.cyan, strokeWidth: 6),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('HEALTH', style: AppText.label),
                        Text('100%', style: TextStyle(color: AppColors.white, fontSize: 17, fontWeight: FontWeight.w700)),
                        Text('OPTIMAL', style: AppText.greenTag),
                      ],
                    ),
                  ],
                ),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledValue(label: 'REQUESTS', value: '1.2K'),
                    SizedBox(height: 2),
                    Text('/min', style: AppText.label),
                  ],
                ),
              ),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    LabeledValue(label: 'SUCCESS RATE', value: '99.7%', valueColor: AppColors.green),
                    SizedBox(height: 2),
                    Text('↑ 0.3%', style: AppText.greenTag),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (i) {
              return Container(
                width: 5,
                height: 5,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: i == 2 ? AppColors.cyan : AppColors.mutedBlueDark,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _advisorAgentsPanel() {
    final agents = [
      (Icons.hub_outlined, 'ARCHITECT', 'System Design'),
      (Icons.search, 'RESEARCHER', 'Information Analyst'),
      (Icons.assignment_outlined, 'PLANNER', 'Task Orchestrator'),
      (Icons.shield_outlined, 'CRITIC', 'Quality Assurance'),
      (Icons.lock_outline, 'GUARDIAN', 'Security Monitor'),
      (Icons.remove_red_eye_outlined, 'OBSERVER', 'Environment Watch'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: panelDecoration,
      child: Column(
        children: [
          const Text('ADVISOR AGENTS', style: AppText.panelTitle),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              for (final a in agents)
                AgentAvatar(icon: a.$1, name: a.$2, role: a.$3),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// RIGHT COLUMN
// ---------------------------------------------------------------------------

class _RightColumn extends StatelessWidget {
  const _RightColumn();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _toolHubPanel(),
          const SizedBox(height: 12),
          _homeControlPanel(),
          const SizedBox(height: 12),
          _codeRunnerPanel(),
          const SizedBox(height: 12),
          _visionPanel(),
          const SizedBox(height: 12),
          _safetyChecksPanel(),
          const SizedBox(height: 12),
          _multiAgentPanel(),
        ],
      ),
    );
  }

  Widget _toolHubPanel() {
    final tools = [
      (Icons.terminal, 'TERMINAL'),
      (Icons.public, 'BROWSER'),
      (Icons.code, 'GIT'),
      (Icons.email_outlined, 'EMAIL'),
      (Icons.calendar_today_outlined, 'CALENDAR'),
      (Icons.camera_alt_outlined, 'CAMERA'),
      (Icons.mic_none, 'MICROPHONE'),
      (Icons.map_outlined, 'MAPS'),
      (Icons.wb_sunny_outlined, 'WEATHER'),
      (Icons.description_outlined, 'DOCUMENTS'),
      (Icons.home_outlined, 'HOME ASSISTANT'),
      (Icons.sticky_note_2_outlined, 'NOTES'),
      (Icons.dns_outlined, 'DATABASE'),
      (Icons.api_outlined, 'API'),
      (Icons.add, 'MORE'),
    ];

    return PanelContainer(
      title: 'TOOL HUB',
      child: GridView.count(
        crossAxisCount: 3,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1.5,
        children: [
          for (final t in tools) IconTile(icon: t.$1, label: t.$2),
        ],
      ),
    );
  }

  Widget _homeControlPanel() {
    return PanelContainer(
      title: 'HOME CONTROL',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.home_outlined, size: 50),
          const SizedBox(width: 14),
          const Expanded(
            child: StatPair(
              first: LabeledValue(label: 'DEVICES', value: '24', valueColor: AppColors.white),
              second: LabeledValue(label: 'ENVIRONMENT', value: '22°C'),
            ),
          ),
          const SizedBox(width: 8),
          MiniChart(
            width: 60,
            height: 34,
            painter: SparklinePainter(values: const [4, 3, 5, 4, 6, 5, 7, 6, 8, 7]),
          ),
        ],
      ),
    );
  }

  Widget _codeRunnerPanel() {
    return PanelContainer(
      title: 'CODE RUNNER',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.code, size: 50),
          const SizedBox(width: 14),
          const Expanded(
            child: StatPair(
              first: LabeledValue(label: 'LANGUAGES', value: '12'),
              second: LabeledValue(label: 'TESTS', value: '256'),
            ),
          ),
          const SizedBox(width: 8),
          MiniChart(
            width: 60,
            height: 34,
            painter: BarChartPainter(values: const [4, 7, 5, 9, 6, 10, 7, 11, 8, 12]),
          ),
        ],
      ),
    );
  }

  Widget _visionPanel() {
    return PanelContainer(
      title: 'VISION',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.remove_red_eye_outlined, size: 50),
          const SizedBox(width: 14),
          const Expanded(
            child: StatPair(
              first: LabeledValue(label: 'MODE', value: 'OCR + CV', valueFontSize: 13),
              second: LabeledValue(label: 'ACCURACY', value: '98.6%'),
            ),
          ),
          const SizedBox(width: 8),
          MiniChart(
            width: 60,
            height: 34,
            painter: SparklinePainter(values: const [5, 6, 5, 7, 6, 8, 7, 9, 8, 9]),
          ),
        ],
      ),
    );
  }

  Widget _safetyChecksPanel() {
    return PanelContainer(
      title: 'SAFETY CHECKS',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const IconBadge(icon: Icons.shield_outlined, size: 50),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const StatPair(
                  first: LabeledValue(label: 'THREAT LEVEL', value: 'LOW', valueColor: AppColors.green, valueFontSize: 13),
                  second: LabeledValue(label: 'PERMISSIONS', value: 'ALL SECURE', valueColor: AppColors.green, valueFontSize: 13),
                ),
                const SizedBox(height: 10),
                MiniChart(
                  width: double.infinity,
                  height: 10,
                  painter: DashedLinePainter(color: AppColors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _multiAgentPanel() {
    return PanelContainer(
      title: 'MULTI-AGENT COORDINATION',
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MiniChart(
            width: 90,
            height: 90,
            painter: NetworkGraphPainter(nodeCount: 16, seed: 11),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _MiniStatLine(label: 'ACTIVE TASKS', value: '14'),
                SizedBox(height: 8),
                _MiniStatLine(label: 'COLLABORATIONS', value: '7'),
                SizedBox(height: 8),
                _MiniStatLine(label: 'SYNC STATUS', value: 'OPTIMAL', valueColor: AppColors.cyan),
                SizedBox(height: 8),
                _MiniStatLine(label: 'NETWORK LOAD', value: '36%'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniStatLine extends StatelessWidget {
  final String label;
  final String value;
  final Color valueColor;

  const _MiniStatLine({
    required this.label,
    required this.value,
    this.valueColor = AppColors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: AppText.label),
        Text(
          value,
          style: AppText.valueSmall.copyWith(fontSize: 11, color: valueColor),
        ),
      ],
    );
  }
}

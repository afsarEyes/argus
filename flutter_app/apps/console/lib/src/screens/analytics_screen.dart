import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class AnalyticsScreen extends ConsumerStatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  ConsumerState<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends ConsumerState<AnalyticsScreen> {
  String _selectedLine = 'all';
  String _selectedSeverity = 'all';
  String _timeRange = '7D'; // 7D, 30D, 180D

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final lines = ref.watch(consoleLinesListProvider).valueOrNull ?? [];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Filter Row
          Row(
            children: [
              Text(
                'QC PERFORMANCE ANALYTICS',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  color: colors.textPrimary,
                ),
              ),
              const Spacer(),
              // Time Range picker
              _buildSegmentedControl(),
              const SizedBox(width: 16),
              // Line selector
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.panelBackground,
                    border: Border.all(color: colors.panelBorder),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedLine,
                    items: [
                      const DropdownMenuItem(value: 'all', child: Text('ALL LINES', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                      ...lines.map((l) => DropdownMenuItem(value: l.id, child: Text(l.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12)))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedLine = val);
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // Severity selector
              DropdownButtonHideUnderline(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: colors.panelBackground,
                    border: Border.all(color: colors.panelBorder),
                    borderRadius: const BorderRadius.all(Radius.circular(4)),
                  ),
                  child: DropdownButton<String>(
                    value: _selectedSeverity,
                    items: const [
                      DropdownMenuItem(value: 'all', child: Text('ALL SEVERITIES', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                      DropdownMenuItem(value: 'critical', child: Text('CRITICAL', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                      DropdownMenuItem(value: 'major', child: Text('MAJOR', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                      DropdownMenuItem(value: 'minor', child: Text('MINOR', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    ],
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedSeverity = val);
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Overview KPI Row
          Row(
            children: [
              Expanded(child: _buildKpiCard('SLA COMPLIANCE', '94.2%', '+1.4% MoM', Colors.green, colors)),
              const SizedBox(width: 16),
              Expanded(child: _buildKpiCard('MEAN TIME TO RESOLVE (MTTR)', '42 MIN', '-8 mins MoM', colors.brandAccent, colors)),
              const SizedBox(width: 16),
              Expanded(child: _buildKpiCard('TOTAL ISSUES LOGGED', '118 TKT', 'Within bounds', Colors.blue, colors)),
              const SizedBox(width: 16),
              Expanded(child: _buildKpiCard('CRITICAL SLA BREACHES', '2 INC', 'Action required', colors.statusSlaBreached, colors)),
            ],
          ),
          const SizedBox(height: 24),

          // Charts Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Defect-Type Pareto Chart
              Expanded(
                flex: 4,
                child: ArgusPanel(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'DEFECT PARETO (TICKET COUNT)',
                          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 240,
                          child: BarChart(
                            BarChartData(
                              alignment: BarChartAlignment.spaceAround,
                              maxY: 30,
                              barTouchData: BarTouchData(enabled: true),
                              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (val) => FlLine(color: colors.panelBorder, strokeWidth: 0.5)),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      final labels = ['SEAL FAIL', 'TENSION', 'STRAP SNAP', 'ALIGN', 'TEMP'];
                                      if (value.toInt() >= 0 && value.toInt() < labels.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(labels[value.toInt()], style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 10, fontWeight: FontWeight.bold)),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              barGroups: [
                                _makeBarGroup(0, 24, colors.severityCritical),
                                _makeBarGroup(1, 18, colors.brandAccent),
                                _makeBarGroup(2, 12, colors.brandAccent),
                                _makeBarGroup(3, 8, colors.brandAccent),
                                _makeBarGroup(4, 5, colors.textSecondary),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // SLA Compliance Trend Line Chart
              Expanded(
                flex: 4,
                child: ArgusPanel(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'SLA COMPLIANCE TREND (%)',
                          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          height: 240,
                          child: LineChart(
                            LineChartData(
                              minY: 80,
                              maxY: 100,
                              gridData: FlGridData(show: true, drawVerticalLine: false, getDrawingHorizontalLine: (val) => FlLine(color: colors.panelBorder, strokeWidth: 0.5)),
                              titlesData: FlTitlesData(
                                show: true,
                                rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                                bottomTitles: AxisTitles(
                                  sideTitles: SideTitles(
                                    showTitles: true,
                                    getTitlesWidget: (double value, TitleMeta meta) {
                                      final labels = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
                                      if (value.toInt() >= 0 && value.toInt() < labels.length) {
                                        return SideTitleWidget(
                                          axisSide: meta.axisSide,
                                          child: Text(labels[value.toInt()], style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 10, fontWeight: FontWeight.bold)),
                                        );
                                      }
                                      return const Text('');
                                    },
                                  ),
                                ),
                              ),
                              borderData: FlBorderData(show: false),
                              lineBarsData: [
                                LineChartBarData(
                                  spots: const [
                                    FlSpot(0, 92),
                                    FlSpot(1, 95),
                                    FlSpot(2, 91),
                                    FlSpot(3, 94),
                                    FlSpot(4, 96),
                                    FlSpot(5, 93),
                                    FlSpot(6, 95),
                                  ],
                                  isCurved: true,
                                  color: colors.brandAccent,
                                  barWidth: 3,
                                  isStrokeCapRound: true,
                                  dotData: const FlDotData(show: true),
                                  belowBarData: BarAreaData(
                                    show: true,
                                    color: colors.brandAccent.withOpacity(0.05),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Leaderboard & Repeat Defects Alerts
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Resolution Leaderboard
              Expanded(
                flex: 4,
                child: ArgusPanel(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          'AREA MTTR & SLA LEADERBOARD',
                          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        const SizedBox(height: 16),
                        _buildLeaderboardRow('LINE A - GLUEING & STRAPPING', '28 MINS', '98.1% SLA', Colors.green, colors),
                        const Divider(height: 16),
                        _buildLeaderboardRow('LINE B - WRAPPING DEPT', '35 MINS', '96.2% SLA', Colors.green, colors),
                        const Divider(height: 16),
                        _buildLeaderboardRow('LINE D - BUNDLING CELL', '44 MINS', '94.8% SLA', colors.brandAccent, colors),
                        const Divider(height: 16),
                        _buildLeaderboardRow('LINE C - PRESS ASSEMBLY', '61 MINS', '88.5% SLA', colors.statusSlaBreached, colors),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 24),

              // Repeat defect detector alert list
              Expanded(
                flex: 4,
                child: ArgusPanel(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            const Text(
                              'REPEAT-DEFECT DETECTOR ALERTS',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13),
                            ),
                            const Spacer(),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(color: colors.statusSlaBreached.withOpacity(0.1), borderRadius: BorderRadius.circular(4)),
                              child: Text('3 HOT SPOTS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 9, fontWeight: FontWeight.bold, color: colors.statusSlaBreached)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _buildDetectorRow('STRAP SNAP DEVIATION', 'Line B // Station 3', '4 repeats logged in last 48 hours', colors),
                        const Divider(height: 16),
                        _buildDetectorRow('GLUE TEMP FLUCTUATION', 'Line A // Station 1', '3 repeats logged in last 24 hours', colors),
                        const Divider(height: 16),
                        _buildDetectorRow('TENSION LIMIT EXCEEDED', 'Line D // Station 4', '5 repeats logged in last 7 days', colors),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentedControl() {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    return Container(
      decoration: BoxDecoration(
        color: colors.panelBackground,
        border: Border.all(color: colors.panelBorder),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        children: ['7D', '30D', '180D'].map((range) {
          final isSelected = _timeRange == range;
          return InkWell(
            onTap: () => setState(() => _timeRange = range),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              color: isSelected ? colors.brandAccent.withOpacity(0.1) : Colors.transparent,
              child: Text(
                range,
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: isSelected ? colors.brandAccent : colors.textSecondary,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildKpiCard(String label, String value, String changeText, Color color, ArgusColors colors) {
    return ArgusPanel(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 10, color: colors.textSecondary)),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w900, fontSize: 24)),
            const SizedBox(height: 4),
            Text(changeText, style: TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 10, color: color)),
          ],
        ),
      ),
    );
  }

  BarChartGroupData _makeBarGroup(int x, double y, Color color) {
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          width: 28,
          borderRadius: const BorderRadius.only(topLeft: Radius.circular(3), topRight: Radius.circular(3)),
        ),
      ],
    );
  }

  Widget _buildLeaderboardRow(String lineText, String mttr, String sla, Color performanceColor, ArgusColors colors) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(lineText, style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 12)),
        Row(
          children: [
            Text(mttr, style: const TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold, fontSize: 12)),
            const SizedBox(width: 16),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: performanceColor.withOpacity(0.08), borderRadius: BorderRadius.circular(4)),
              child: Text(sla, style: TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold, fontSize: 11, color: performanceColor)),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDetectorRow(String categoryTitle, String location, String countLabel, ArgusColors colors) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(categoryTitle, style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 12)),
            Text(location.toUpperCase(), style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 10, color: colors.textSecondary)),
          ],
        ),
        const SizedBox(height: 4),
        Text(countLabel, style: TextStyle(fontFamily: 'Inter', fontSize: 11, color: colors.severityCritical)),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:argus_core/argus_core.dart';
import '../theme/argus_colors.dart';

class SeverityBadge extends StatelessWidget {
  const SeverityBadge({
    super.key,
    required this.severity,
  });

  final TicketSeverity severity;

  Color _getSeverityColor(ArgusColors colors) {
    switch (severity) {
      case TicketSeverity.critical:
        return colors.severityCritical;
      case TicketSeverity.major:
        return colors.severityMajor;
      case TicketSeverity.minor:
        return colors.severityMinor;
    }
  }

  String _getSeverityText() {
    switch (severity) {
      case TicketSeverity.critical:
        return 'CRITICAL';
      case TicketSeverity.major:
        return 'MAJOR';
      case TicketSeverity.minor:
        return 'MINOR';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>();
    if (colors == null) {
      return Text(_getSeverityText());
    }

    final color = _getSeverityColor(colors);
    final text = _getSeverityText();
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
          color: color,
        );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: textStyle,
      ),
    );
  }
}

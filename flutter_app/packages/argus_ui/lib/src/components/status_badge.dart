import 'package:flutter/material.dart';
import 'package:argus_core/argus_core.dart';
import '../theme/argus_colors.dart';

class StatusBadge extends StatelessWidget {
  const StatusBadge({
    super.key,
    required this.status,
    this.isChip = false,
    this.isSlaBreached = false,
  });

  final TicketStatus status;
  final bool isChip;
  final bool isSlaBreached;

  Color _getStatusColor(ArgusColors colors) {
    if (isSlaBreached) {
      return colors.statusSlaBreached;
    }
    switch (status) {
      case TicketStatus.open:
        return colors.statusOpen;
      case TicketStatus.assigned:
        return colors.statusAssigned;
      case TicketStatus.inProgress:
        return colors.statusInProgress;
      case TicketStatus.resolved:
        return colors.statusResolved;
      case TicketStatus.closed:
        return colors.statusClosed;
    }
  }

  String _getStatusText() {
    switch (status) {
      case TicketStatus.open:
        return 'OPEN';
      case TicketStatus.assigned:
        return 'ASSIGNED';
      case TicketStatus.inProgress:
        return 'IN PROGRESS';
      case TicketStatus.resolved:
        return 'RESOLVED';
      case TicketStatus.closed:
        return 'CLOSED';
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>();
    if (colors == null) {
      return Text(_getStatusText());
    }

    final color = _getStatusColor(colors);
    final text = _getStatusText();
    final textStyle = Theme.of(context).textTheme.labelSmall?.copyWith(
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        );

    if (isChip) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          border: Border.all(color: color.withValues(alpha: 0.3), width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          text,
          style: textStyle?.copyWith(color: color),
        ),
      );
    } else {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            text,
            style: textStyle?.copyWith(color: color),
          ),
        ],
      );
    }
  }
}

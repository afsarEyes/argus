import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/argus_colors.dart';
import '../theme/argus_theme.dart';

class MonospaceTatCounter extends StatefulWidget {
  const MonospaceTatCounter({
    super.key,
    required this.deadline,
    this.style,
  });

  final DateTime deadline;
  final TextStyle? style;

  @override
  State<MonospaceTatCounter> createState() => _MonospaceTatCounterState();
}

class _MonospaceTatCounterState extends State<MonospaceTatCounter> {
  late Timer _timer;
  late Duration _timeRemaining;

  @override
  void initState() {
    super.initState();
    _calculateTimeRemaining();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) {
        setState(() {
          _calculateTimeRemaining();
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _calculateTimeRemaining() {
    final now = DateTime.now();
    _timeRemaining = widget.deadline.difference(now);
  }

  String _formatDuration(Duration duration) {
    final absoluteSeconds = duration.inSeconds.abs();
    final hours = (absoluteSeconds / 3600).floor().toString().padLeft(2, '0');
    final minutes = ((absoluteSeconds % 3600) / 60).floor().toString().padLeft(2, '0');
    final seconds = (absoluteSeconds % 60).toString().padLeft(2, '0');

    final sign = duration.isNegative ? '-' : '';
    return '$sign$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final isBreached = _timeRemaining.isNegative;
    final colors = Theme.of(context).extension<ArgusColors>();
    final defaultColor = colors?.textPrimary ?? Colors.black;
    final alertColor = colors?.statusSlaBreached ?? Colors.red;

    final displayColor = isBreached ? alertColor : defaultColor;

    final formattedText = _formatDuration(_timeRemaining);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: isBreached ? alertColor.withValues(alpha: 0.1) : (colors?.panelBorder.withValues(alpha: 0.2) ?? Colors.grey.withValues(alpha: 0.2)),
        border: Border.all(
          color: isBreached ? alertColor.withValues(alpha: 0.3) : (colors?.panelBorder ?? Colors.grey),
          width: 1,
        ),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_filled_outlined,
            size: 14,
            color: displayColor,
          ),
          const SizedBox(width: 6),
          Text(
            formattedText,
            style: ArgusTypography.monospace(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: displayColor,
            ).merge(widget.style),
          ),
        ],
      ),
    );
  }
}

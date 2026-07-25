import 'package:flutter/material.dart';
import '../theme/argus_colors.dart';

class ArgusErrorState extends StatelessWidget {
  const ArgusErrorState({
    super.key,
    required this.errorMessage,
    required this.onRetry,
    this.title = 'System Error Detected',
  });

  final String errorMessage;
  final VoidCallback onRetry;
  final String title;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>();
    final errorColor = colors?.statusSlaBreached ?? Colors.red;

    return Center(
      child: Container(
        margin: const EdgeInsets.all(24),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: errorColor.withValues(alpha: 0.05),
          border: Border.all(
            color: errorColor.withValues(alpha: 0.3),
            width: 1,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Icon(
                  Icons.report_problem_outlined,
                  color: errorColor,
                  size: 24,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: errorColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              errorMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colors?.textPrimary,
                  ),
            ),
            const SizedBox(height: 20),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: onRetry,
                icon: const Icon(Icons.refresh, size: 16),
                label: const Text('RETRY'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: errorColor,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

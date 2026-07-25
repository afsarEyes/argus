import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';

final notificationsListProvider = FutureProvider<List<NotificationLog>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  try {
    final List<dynamic> data = await client
        .from('notifications_log')
        .select()
        .order('sent_at', ascending: false);
    return data.map((json) => NotificationLog.fromJson(json)).toList();
  } catch (_) {
    return [];
  }
});

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationsAsync = ref.watch(notificationsListProvider);
    final colors = Theme.of(context).extension<ArgusColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QC ALERT LOGS',
          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(notificationsListProvider),
          ),
        ],
      ),
      body: notificationsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: ArgusErrorState(
            errorMessage: 'Failed to load notifications: $e',
            onRetry: () => ref.invalidate(notificationsListProvider),
          ),
        ),
        data: (list) {
          if (list.isEmpty) {
            return ArgusEmptyState(
              icon: Icons.notifications_none,
              title: 'NO ALERTS',
              message: 'No quality alerts logged in this shift.',
              actionLabel: 'Refresh',
              onActionPressed: () => ref.invalidate(notificationsListProvider),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: list.length,
            itemBuilder: (context, index) {
              final log = list[index];

              return Padding(
                padding: const EdgeInsets.only(bottom: 12.0),
                child: ArgusCard(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.warning_amber_rounded, color: colors.severityCritical, size: 24),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                log.title.toUpperCase(),
                                style: const TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                log.body,
                                style: TextStyle(
                                  fontFamily: 'Inter',
                                  fontSize: 13,
                                  color: colors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                log.sentAt.toLocal().toString().split('.').first,
                                style: TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontSize: 10,
                                  fontWeight: FontWeight.w500,
                                  color: colors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

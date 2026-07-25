import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/local_providers.dart';
import '../routing/app_router.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final userAsync = ref.watch(appUserStreamProvider);
    final themeMode = ref.watch(themeModeStateProvider);
    
    final lines = ref.watch(linesListProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QC WORKER PROFILE',
          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
        ),
      ),
      body: userAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (user) {
          if (user == null) {
            return const Center(child: Text('Not logged in.'));
          }

          final lineName = lines
              .firstWhere(
                (l) => l.id == user.lineId,
                orElse: () => Line(id: '', name: 'No assigned line', plantId: '', active: true),
              )
              .name;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // User Details Card
                ArgusCard(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        CircleAvatar(
                          radius: 40,
                          backgroundColor: colors.brandAccent.withOpacity(0.1),
                          child: Icon(Icons.person, size: 40, color: colors.brandAccent),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          user.name.toUpperCase(),
                          style: const TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          user.email,
                          style: TextStyle(
                            fontFamily: 'Inter',
                            color: colors.textSecondary,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Settings Panel
                Text(
                  'METADATA & SETTINGS',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 8),
                ArgusPanel(
                  child: Column(
                    children: [
                      ListTile(
                        title: const Text('ASSIGNED ROLE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13)),
                        trailing: Text(user.role.name.toUpperCase(), style: TextStyle(color: colors.brandAccent, fontWeight: FontWeight.bold)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('WORK STATION LINE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13)),
                        trailing: Text(lineName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('WORK SHIFT', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13)),
                        trailing: Text((user.shift ?? 'Not assigned').toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        title: const Text('DARK THEME MODE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13)),
                        trailing: Switch(
                          value: themeMode == ThemeMode.dark,
                          activeColor: colors.brandAccent,
                          onChanged: (val) {
                            HapticFeedback.lightImpact();
                            ref.read(themeModeStateProvider.notifier).toggleTheme();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // Logout Button
                ElevatedButton(
                  onPressed: () async {
                    HapticFeedback.lightImpact();
                    await ref.read(authRepositoryProvider).logout();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.severityCritical,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  child: const Text(
                    'SECURE LOG OUT / RESET WORK',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

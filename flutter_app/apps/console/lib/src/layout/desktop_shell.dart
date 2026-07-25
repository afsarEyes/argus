import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class DesktopShell extends ConsumerWidget {
  const DesktopShell({
    super.key,
    required this.navigationShell,
  });

  final StatefulNavigationShell navigationShell;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final themeMode = ref.watch(consoleThemeModeProvider);
    final selectedPlant = ref.watch(consoleSelectedPlantProvider);
    final plants = ref.watch(consolePlantsListProvider).valueOrNull ?? [];
    final activeUser = ref.watch(consoleUserProvider).valueOrNull;

    // Sidebar items mapping
    final items = [
      _SidebarItem(Icons.dashboard_outlined, 'LIVE TICKET BOARD', 0),
      _SidebarItem(Icons.analytics_outlined, 'ANALYTICS DASHBOARD', 1),
      _SidebarItem(Icons.rule_folder_outlined, 'AUTO-ASSIGN RULES', 2),
      _SidebarItem(Icons.account_tree_outlined, 'TAXONOMY CONFIG', 3),
      _SidebarItem(Icons.people_alt_outlined, 'USER MANAGEMENT', 4),
      _SidebarItem(Icons.summarize_outlined, 'REPORTS & DIGESTS', 5),
    ];

    return Scaffold(
      body: Row(
        children: [
          // 1. Sidebar Navigation
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: colors.panelBackground,
              border: Border(right: BorderSide(color: colors.panelBorder, width: 1)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Branding Header
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                  decoration: BoxDecoration(
                    border: Border(bottom: BorderSide(color: colors.panelBorder, width: 1)),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.security, color: colors.brandAccent, size: 24),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'ARGUS',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontWeight: FontWeight.w900,
                                fontSize: 18,
                                color: colors.textPrimary,
                                letterSpacing: 1.5,
                              ),
                            ),
                            Text(
                              'QC CONTROL TOWER',
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontWeight: FontWeight.w600,
                                fontSize: 9,
                                color: colors.brandAccent,
                                letterSpacing: 1,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // Sidebar Navigation Links
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = navigationShell.currentIndex == item.index;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2.0),
                        child: InkWell(
                          onTap: () => navigationShell.goBranch(item.index),
                          borderRadius: const BorderRadius.all(Radius.circular(4)),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: isSelected ? colors.brandAccent.withOpacity(0.08) : Colors.transparent,
                              borderRadius: const BorderRadius.all(Radius.circular(4)),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  item.icon,
                                  size: 18,
                                  color: isSelected ? colors.brandAccent : colors.textSecondary,
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    item.label,
                                    style: TextStyle(
                                      fontFamily: 'SpaceGrotesk',
                                      fontSize: 12,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      color: isSelected ? colors.brandAccent : colors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // User profile details in Sidebar Footer
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    border: Border(top: BorderSide(color: colors.panelBorder, width: 1)),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: colors.brandAccent.withOpacity(0.1),
                        child: Icon(Icons.person, size: 16, color: colors.brandAccent),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              activeUser?.name ?? 'ADMINISTRATOR',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                            Text(
                              (activeUser?.role.name ?? 'quality_manager').toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Inter',
                                fontSize: 9,
                                color: colors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.logout, size: 16),
                        onPressed: () async {
                          await ref.read(consoleAuthRepositoryProvider).logout();
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2. Main Content & Top Header
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top Status Header Bar
                Container(
                  height: 64,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  decoration: BoxDecoration(
                    color: colors.panelBackground,
                    border: Border(bottom: BorderSide(color: colors.panelBorder, width: 1)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Plant Selector & Realtime Indicator
                      Row(
                        children: [
                          const Text(
                            'PLANT VIEW:',
                            style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 11, color: Colors.grey),
                          ),
                          const SizedBox(width: 8),
                          DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: selectedPlant,
                              items: [
                                const DropdownMenuItem(value: 'all', child: Text('ALL SIGNODE PLANTS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13))),
                                ...plants.map((p) => DropdownMenuItem(
                                      value: p.id,
                                      child: Text(p.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 13)),
                                    )),
                              ],
                              onChanged: (val) {
                                if (val != null) {
                                  ref.read(consoleSelectedPlantProvider.notifier).state = val;
                                }
                              },
                            ),
                          ),
                          const SizedBox(width: 24),
                          // WebSocket status indicator
                          const _RealtimeIndicator(),
                        ],
                      ),

                      // Theme mode and System Clock
                      Row(
                        children: [
                          IconButton(
                            icon: Icon(
                              themeMode == ThemeMode.dark ? Icons.light_mode : Icons.dark_mode,
                              size: 20,
                            ),
                            onPressed: () {
                              ref.read(consoleThemeModeProvider.notifier).toggle();
                            },
                          ),
                          const SizedBox(width: 16),
                          const VerticalDivider(width: 1, indent: 20, endIndent: 20),
                          const SizedBox(width: 16),
                          Icon(Icons.calendar_today, size: 14, color: colors.textSecondary),
                          const SizedBox(width: 8),
                          Text(
                            'SHIFT: ONLINE // UTC',
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontWeight: FontWeight.w700,
                              fontSize: 11,
                              color: colors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // Main Views content inject
                Expanded(
                  child: Container(
                    color: colors.panelBackground.withOpacity(0.5),
                    child: navigationShell,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SidebarItem {
  final IconData icon;
  final String label;
  final int index;
  _SidebarItem(this.icon, this.label, this.index);
}

class _RealtimeIndicator extends ConsumerWidget {
  const _RealtimeIndicator();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final isConnected = ref.watch(consoleRealtimeConnectedProvider);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isConnected ? Colors.green.withOpacity(0.1) : Colors.red.withOpacity(0.1),
        border: Border.all(
          color: isConnected ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.3),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: isConnected ? Colors.green : Colors.red,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isConnected ? 'REALTIME LIVE' : 'DISCONNECTED',
            style: TextStyle(
              fontFamily: 'JetBrainsMono',
              fontWeight: FontWeight.bold,
              fontSize: 9,
              color: isConnected ? Colors.green : Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

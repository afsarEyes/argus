import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadUsers();
  }

  Future<void> _loadUsers() async {
    try {
      final client = Supabase.instance.client;
      final List<dynamic> data = await client.from('users').select();
      setState(() {
        _users = data.map((d) => User.fromJson(d)).toList();
        _isLoading = false;
      });
    } catch (_) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _updateUserRole(String id, UserRole role) async {
    try {
      final client = Supabase.instance.client;
      await client.from('users').update({'role': role.name}).eq('id', id);
      _loadUsers();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User role updated.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
  }

  Future<void> _updateUserShift(String id, String? shift) async {
    try {
      final client = Supabase.instance.client;
      await client.from('users').update({'shift': shift}).eq('id', id);
      _loadUsers();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('User shift updated.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final lines = ref.watch(consoleLinesListProvider).valueOrNull ?? [];

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Row
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'PLANT STAFF & SECURITY CONTROLS',
                  style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900, fontSize: 16, color: colors.textPrimary),
                ),
                Text(
                  'Manage user account authorization status, role level escalation layers, and line/shift assignments.',
                  style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Users Table
            Expanded(
              child: ArgusPanel(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('OPERATOR NAME', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('EMAIL ADDRESS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ESCALATION ROLE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ASSIGNED LINE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ACTIVE SHIFT', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('STATUS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                    ],
                    rows: _users.map((user) {
                      final lineName = lines.firstWhere((l) => l.id == user.lineId, orElse: () => Line(id: '', name: 'Unassigned', plantId: '', active: false)).name;

                      return DataRow(
                        cells: [
                          DataCell(Text(user.name.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(user.email, style: TextStyle(color: colors.textSecondary))),
                          DataCell(
                            DropdownButtonHideUnderline(
                              child: DropdownButton<UserRole>(
                                value: user.role,
                                items: UserRole.values.map((r) => DropdownMenuItem(
                                      value: r,
                                      child: Text(r.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12)),
                                    )).toList(),
                                onChanged: (val) {
                                  if (val != null && val != user.role) {
                                    _updateUserRole(user.id, val);
                                  }
                                },
                              ),
                            ),
                          ),
                          DataCell(Text(lineName.toUpperCase())),
                          DataCell(
                            DropdownButtonHideUnderline(
                              child: DropdownButton<String?>(
                                value: user.shift,
                                items: const [
                                  DropdownMenuItem(value: null, child: Text('NONE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                                  DropdownMenuItem(value: 'A', child: Text('SHIFT A', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                                  DropdownMenuItem(value: 'B', child: Text('SHIFT B', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                                  DropdownMenuItem(value: 'C', child: Text('SHIFT C', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                                ],
                                onChanged: (val) {
                                  _updateUserShift(user.id, val);
                                },
                              ),
                            ),
                          ),
                          DataCell(
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.1),
                                border: Border.all(
                                  color: Colors.green.withOpacity(0.3),
                                ),
                                borderRadius: const BorderRadius.all(Radius.circular(4)),
                              ),
                              child: const Text(
                                'ACTIVE',
                                style: TextStyle(
                                  fontFamily: 'SpaceGrotesk',
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

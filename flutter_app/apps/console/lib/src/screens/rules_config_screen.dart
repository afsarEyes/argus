import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class RulesConfigScreen extends ConsumerStatefulWidget {
  const RulesConfigScreen({super.key});

  @override
  ConsumerState<RulesConfigScreen> createState() => _RulesConfigScreenState();
}

class _RulesConfigScreenState extends ConsumerState<RulesConfigScreen> {
  List<AssignmentRule> _rules = [];
  List<User> _users = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final client = Supabase.instance.client;
      
      // Fetch rules
      final List<dynamic> rulesData = await client.from('assignment_rules').select();
      final rules = rulesData.map((d) => AssignmentRule.fromJson(d)).toList();

      // Fetch active users (to assign as owners)
      final List<dynamic> usersData = await client.from('users').select().eq('is_active', true);
      final users = usersData.map((d) => User.fromJson(d)).toList();

      setState(() {
        _rules = rules;
        _users = users;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _deleteRule(String id) async {
    try {
      final client = Supabase.instance.client;
      await client.from('assignment_rules').delete().eq('id', id);
      _loadData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
    }
  }

  void _showAddRuleDialog() {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final lines = ref.read(consoleLinesListProvider).valueOrNull ?? [];
    final categories = ref.read(consoleCategoriesListProvider).valueOrNull ?? [];

    String? selectedLineId = lines.isNotEmpty ? lines.first.id : null;
    String? selectedCategoryId = categories.isNotEmpty ? categories.first.id : null;
    String selectedShift = 'A';
    String? selectedOwnerId = _users.isNotEmpty ? _users.first.id : null;

    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              title: const Text('CREATE AUTO-ASSIGNMENT RULE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Production Line'),
                      value: selectedLineId,
                      items: lines.map((l) => DropdownMenuItem(value: l.id, child: Text(l.name.toUpperCase()))).toList(),
                      onChanged: (val) => setDialogState(() => selectedLineId = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Defect Category'),
                      value: selectedCategoryId,
                      items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name.toUpperCase()))).toList(),
                      onChanged: (val) => setDialogState(() => selectedCategoryId = val),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Shift'),
                      value: selectedShift,
                      items: const [
                        DropdownMenuItem(value: 'A', child: Text('SHIFT A')),
                        DropdownMenuItem(value: 'B', child: Text('SHIFT B')),
                        DropdownMenuItem(value: 'C', child: Text('SHIFT C')),
                      ],
                      onChanged: (val) {
                        if (val != null) setDialogState(() => selectedShift = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      decoration: const InputDecoration(labelText: 'Designated Owner'),
                      value: selectedOwnerId,
                      items: _users.map((u) => DropdownMenuItem<String>(value: u.id, child: Text('${u.name.toUpperCase()} (${u.role.name.toUpperCase()})'))).toList(),
                      onChanged: (val) => setDialogState(() => selectedOwnerId = val),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('CANCEL'),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (selectedLineId == null || selectedCategoryId == null || selectedOwnerId == null) return;
                    try {
                      final client = Supabase.instance.client;
                      await client.from('assignment_rules').insert({
                        'line_id': selectedLineId,
                        'defect_category_id': selectedCategoryId,
                        'shift': selectedShift,
                        'assigned_owner_id': selectedOwnerId,
                      });
                      Navigator.of(context).pop();
                      _loadData();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Failed to save: $e')));
                    }
                  },
                  child: const Text('SAVE RULE'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final lines = ref.watch(consoleLinesListProvider).valueOrNull ?? [];
    final categories = ref.watch(consoleCategoriesListProvider).valueOrNull ?? [];

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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'TICKET ROUTING RULES',
                      style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900, fontSize: 16, color: colors.textPrimary),
                    ),
                    Text(
                      'Manage auto-assignment rules matching Line, Defect Category, and Shift to target leads.',
                      style: TextStyle(fontFamily: 'Inter', fontSize: 12, color: colors.textSecondary),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: _showAddRuleDialog,
                  icon: const Icon(Icons.add),
                  label: const Text('CREATE RULE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Rules Data Table Card
            Expanded(
              child: ArgusPanel(
                child: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: DataTable(
                    columns: const [
                      DataColumn(label: Text('RULE ID', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('PRODUCTION LINE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('DEFECT TAXONOMY', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('SHIFT TARGET', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ROUTED LEAD OWNER', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                      DataColumn(label: Text('ACTIONS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
                    ],
                    rows: _rules.map((rule) {
                      final lineName = lines.firstWhere((l) => l.id == rule.lineId, orElse: () => Line(id: '', name: 'Deleted Line', plantId: '', active: false)).name;
                      final categoryName = categories.firstWhere((c) => c.id == rule.defectCategoryId, orElse: () => DefectCategory(id: '', name: 'Deleted Category', active: false)).name;
                      final ownerName = _users.firstWhere((u) => u.id == rule.assignedOwnerId, orElse: () => User(id: '', email: '', name: 'Unassigned', role: UserRole.staff)).name;

                      return DataRow(
                        cells: [
                          DataCell(Text(rule.id.substring(0, 8).toUpperCase(), style: const TextStyle(fontFamily: 'JetBrainsMono', fontSize: 12))),
                          DataCell(Text(lineName.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.bold))),
                          DataCell(Text(categoryName.toUpperCase())),
                          DataCell(Text('SHIFT ${rule.shift ?? "ANY"}')),
                          DataCell(Text(ownerName.toUpperCase(), style: TextStyle(color: colors.brandAccent, fontWeight: FontWeight.bold))),
                          DataCell(
                            IconButton(
                              icon: const Icon(Icons.delete_outline, color: Colors.red, size: 18),
                              onPressed: () => _deleteRule(rule.id),
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

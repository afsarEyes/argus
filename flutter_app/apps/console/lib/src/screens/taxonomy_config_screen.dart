import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class TaxonomyConfigScreen extends ConsumerStatefulWidget {
  const TaxonomyConfigScreen({super.key});

  @override
  ConsumerState<TaxonomyConfigScreen> createState() => _TaxonomyConfigScreenState();
}

class _TaxonomyConfigScreenState extends ConsumerState<TaxonomyConfigScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  List<SlaTarget> _slaTargets = [];
  bool _isLoadingSla = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadSlaTargets();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadSlaTargets() async {
    try {
      final client = Supabase.instance.client;
      final List<dynamic> data = await client.from('sla_targets').select();
      setState(() {
        _slaTargets = data.map((d) => SlaTarget.fromJson(d)).toList();
        _isLoadingSla = false;
      });
    } catch (_) {
      setState(() => _isLoadingSla = false);
    }
  }

  Future<void> _updateSlaTarget(String id, int minutes) async {
    try {
      final client = Supabase.instance.client;
      await client.from('sla_targets').update({'target_minutes': minutes}).eq('id', id);
      _loadSlaTargets();
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('SLA updated successfully.')));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Container(
          decoration: BoxDecoration(
            color: colors.panelBackground,
            border: Border(bottom: BorderSide(color: colors.panelBorder, width: 1)),
          ),
          child: TabBar(
            controller: _tabController,
            isScrollable: false,
            tabs: const [
              Tab(child: Text('PLANTS, LINES & STATIONS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
              Tab(child: Text('DEFECT CATEGORIES', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
              Tab(child: Text('SLA TARGETS CONFIG', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold))),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPlantsLinesStationsView(colors),
          _buildDefectsView(colors),
          _buildSlaView(colors),
        ],
      ),
    );
  }

  // TAB 1: Plants, Lines & Stations Tree View
  Widget _buildPlantsLinesStationsView(ArgusColors colors) {
    final plantsAsync = ref.watch(consolePlantsListProvider);
    final linesAsync = ref.watch(consoleLinesListProvider);
    final stationsAsync = ref.watch(consoleStationsListProvider);

    return plantsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading plants: $e')),
      data: (plants) {
        final lines = linesAsync.valueOrNull ?? [];
        final stations = stationsAsync.valueOrNull ?? [];

        return ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: plants.length,
          itemBuilder: (context, index) {
            final plant = plants[index];
            final plantLines = lines.where((l) => l.plantId == plant.id).toList();

            return Card(
              margin: const EdgeInsets.only(bottom: 20),
              color: colors.panelBackground,
              child: ExpansionTile(
                title: Text(plant.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 16)),
                subtitle: Text(plant.location ?? 'No location details', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                children: plantLines.map((line) {
                  final lineStations = stations.where((s) => s.lineId == line.id).toList();
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: ExpansionTile(
                      title: Text(line.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 14)),
                      children: lineStations.map((station) {
                        return ListTile(
                          title: Text(station.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12)),
                          leading: const Icon(Icons.circle_outlined, size: 8),
                        );
                      }).toList(),
                    ),
                  );
                }).toList(),
              ),
            );
          },
        );
      },
    );
  }

  // TAB 2: Defect Categories List View
  Widget _buildDefectsView(ArgusColors colors) {
    final categoriesAsync = ref.watch(consoleCategoriesListProvider);

    return categoriesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error loading defects: $e')),
      data: (list) {
        return Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('DEFECT TAXONOMY', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 16)),
                  ElevatedButton(
                    onPressed: () {
                      // Dialog implementation placeholder for adding defect categories
                    },
                    child: const Text('ADD DEFECT CATEGORY'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ArgusPanel(
                  child: ListView.separated(
                    itemCount: list.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, idx) {
                      final item = list[idx];
                      return ListTile(
                        title: Text(item.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold)),
                        subtitle: Text(item.description ?? 'No description provided.', style: TextStyle(color: colors.textSecondary)),
                        trailing: Icon(Icons.check_circle_outline, color: colors.brandAccent),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  // TAB 3: SLA Targets Configuration View
  Widget _buildSlaView(ArgusColors colors) {
    if (_isLoadingSla) {
      return const Center(child: CircularProgressIndicator());
    }

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const Text('SLA SEVERITY TARGET TIMES', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: _slaTargets.length,
              itemBuilder: (context, index) {
                final target = _slaTargets[index];
                int currentMins = target.targetMinutes;

                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  color: colors.panelBackground,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 2,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(target.severity.name.toUpperCase(), style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w900, fontSize: 16, color: colors.brandAccent)),
                              const SizedBox(height: 4),
                              Text('Max resolution time before escalation breach alerts are dispatched.', style: TextStyle(fontSize: 12, color: colors.textSecondary)),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Text('$currentMins MINS', style: const TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.w900, fontSize: 20)),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Slider(
                                  value: currentMins.toDouble(),
                                  min: 5,
                                  max: 240,
                                  divisions: 47,
                                  onChanged: (val) {
                                    setState(() {
                                      _slaTargets = _slaTargets
                                          .map((t) => t.id == target.id
                                              ? t.copyWith(targetMinutes: val.toInt())
                                              : t)
                                          .toList();
                                    });
                                  },
                                  onChangeEnd: (val) {
                                    _updateSlaTarget(target.id, val.toInt());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

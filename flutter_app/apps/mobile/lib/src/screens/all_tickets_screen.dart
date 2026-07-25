import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/local_providers.dart';

class AllTicketsScreen extends ConsumerStatefulWidget {
  const AllTicketsScreen({super.key});

  @override
  ConsumerState<AllTicketsScreen> createState() => _AllTicketsScreenState();
}

class _MyFilterOptions {
  _MyFilterOptions({
    this.lineId,
    this.status,
    this.showOnlySlaBreached = false,
  });

  final String? lineId;
  final TicketStatus? status;
  final bool showOnlySlaBreached;

  _MyFilterOptions copyWith({
    String? Function()? lineId,
    TicketStatus? Function()? status,
    bool? showOnlySlaBreached,
  }) {
    return _MyFilterOptions(
      lineId: lineId != null ? lineId() : this.lineId,
      status: status != null ? status() : this.status,
      showOnlySlaBreached: showOnlySlaBreached ?? this.showOnlySlaBreached,
    );
  }
}

class _AllTicketsScreenState extends ConsumerState<AllTicketsScreen> {
  _MyFilterOptions _filters = _MyFilterOptions();
  List<Ticket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadTickets();
  }

  Future<void> _loadTickets() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final repo = ref.read(ticketRepositoryProvider);
      final tickets = await repo.getTickets();
      if (mounted) {
        setState(() {
          _tickets = tickets;
          _isLoading = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  List<Ticket> get _filteredTickets {
    return _tickets.where((t) {
      if (_filters.lineId != null && t.lineId != _filters.lineId) {
        return false;
      }
      if (_filters.status != null && t.status != _filters.status) {
        return false;
      }
      if (_filters.showOnlySlaBreached) {
        int targetMinutes = 120;
        if (t.severity == TicketSeverity.critical) targetMinutes = 30;
        if (t.severity == TicketSeverity.major) targetMinutes = 60;
        final deadline = t.createdAt.add(Duration(minutes: targetMinutes));
        final isBreached = DateTime.now().isAfter(deadline) &&
            t.status != TicketStatus.resolved &&
            t.status != TicketStatus.closed;
        if (!isBreached) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final lines = ref.watch(linesListProvider).valueOrNull ?? [];
    final stations = ref.watch(stationsListProvider).valueOrNull ?? [];
    final categories = ref.watch(defectCategoriesListProvider).valueOrNull ?? [];

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'PLANT FLOORS DASHBOARD',
          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTickets),
        ],
      ),
      body: Column(
        children: [
          // Dynamic Filtering Panel
          Container(
            color: colors.panelBackground,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String?>(
                        value: _filters.lineId,
                        dropdownColor: colors.panelBackground,
                        decoration: InputDecoration(
                          labelText: 'Filter Line',
                          labelStyle: TextStyle(color: colors.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                        ),
                        items: [
                          DropdownMenuItem<String?>(
                            value: null,
                            child: Text('All Lines', style: TextStyle(color: colors.textPrimary)),
                          ),
                          ...lines.map((l) {
                            return DropdownMenuItem<String?>(
                              value: l.id,
                              child: Text(l.name, style: TextStyle(color: colors.textPrimary)),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _filters = _filters.copyWith(lineId: () => val);
                          });
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: DropdownButtonFormField<TicketStatus?>(
                        value: _filters.status,
                        dropdownColor: colors.panelBackground,
                        decoration: InputDecoration(
                          labelText: 'Filter Status',
                          labelStyle: TextStyle(color: colors.textSecondary),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                        ),
                        items: [
                          DropdownMenuItem<TicketStatus?>(
                            value: null,
                            child: Text('All Statuses', style: TextStyle(color: colors.textPrimary)),
                          ),
                          ...TicketStatus.values.map((s) {
                            return DropdownMenuItem<TicketStatus?>(
                              value: s,
                              child: Text(s.name.toUpperCase(), style: TextStyle(color: colors.textPrimary)),
                            );
                          }),
                        ],
                        onChanged: (val) {
                          setState(() {
                            _filters = _filters.copyWith(status: () => val);
                          });
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'SHOW ONLY SLA-BREACHED',
                      style: TextStyle(
                        fontFamily: 'SpaceGrotesk',
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: colors.textPrimary,
                      ),
                    ),
                    Switch(
                      value: _filters.showOnlySlaBreached,
                      activeColor: colors.statusSlaBreached,
                      onChanged: (val) {
                        setState(() {
                          _filters = _filters.copyWith(showOnlySlaBreached: val);
                        });
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),

          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : RefreshIndicator(
                    onRefresh: _loadTickets,
                    child: _buildTicketsList(colors, lines, stations, categories),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildTicketsList(
    ArgusColors colors,
    List<Line> lines,
    List<Station> stations,
    List<DefectCategory> categories,
  ) {
    final list = _filteredTickets;

    if (list.isEmpty) {
      return ArgusEmptyState(
        icon: Icons.filter_list_off,
        title: 'NO RESULTS',
        message: 'No tickets matched the filter criteria.',
        actionLabel: 'Refresh',
        onActionPressed: _loadTickets,
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final ticket = list[index];

        final lineName = lines.firstWhere((l) => l.id == ticket.lineId, orElse: () => Line(id: '', name: 'Line ${ticket.lineId}', plantId: '', active: true)).name;
        final stationName = stations.firstWhere((s) => s.id == ticket.stationId, orElse: () => Station(id: '', name: 'Station ${ticket.stationId}', lineId: '', active: true)).name;
        final categoryName = categories.firstWhere((c) => c.id == ticket.defectCategoryId, orElse: () => DefectCategory(id: '', name: 'Defect', active: true)).name;

        int targetMinutes = 120;
        if (ticket.severity == TicketSeverity.critical) targetMinutes = 30;
        if (ticket.severity == TicketSeverity.major) targetMinutes = 60;
        final deadline = ticket.createdAt.add(Duration(minutes: targetMinutes));

        final isBreached = DateTime.now().isAfter(deadline) &&
            ticket.status != TicketStatus.resolved &&
            ticket.status != TicketStatus.closed;

        return Padding(
          padding: const EdgeInsets.only(bottom: 12.0),
          child: InkWell(
            onTap: () {
              context.go('/queue/tickets/${ticket.id}');
            },
            child: Container(
              decoration: BoxDecoration(
                border: isBreached ? Border.all(color: colors.statusSlaBreached, width: 2) : null,
                borderRadius: const BorderRadius.all(Radius.circular(6)),
              ),
              child: ArgusCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                ticket.id.startsWith('ARG-') ? ticket.id : 'ARG-LOCAL',
                                style: const TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold),
                              ),
                              if (isBreached) ...[
                                const SizedBox(width: 8),
                                Icon(Icons.warning, size: 16, color: colors.statusSlaBreached),
                              ],
                            ],
                          ),
                          Row(
                            children: [
                              SeverityBadge(severity: ticket.severity),
                              const SizedBox(width: 8),
                              StatusBadge(
                                status: ticket.status,
                                isChip: true,
                                isSlaBreached: isBreached,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        categoryName.toUpperCase(),
                        style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 15),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        ticket.description,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: colors.textSecondary),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$lineName // $stationName'.toUpperCase(),
                            style: TextStyle(fontFamily: 'JetBrainsMono', fontSize: 11, color: colors.textSecondary),
                          ),
                          if (!isBreached && ticket.status != TicketStatus.resolved && ticket.status != TicketStatus.closed)
                            Row(
                              children: [
                                const Icon(Icons.timer, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                MonospaceTatCounter(deadline: deadline),
                              ],
                            ),
                          if (isBreached)
                            Text(
                              'SLA BREACHED',
                              style: TextStyle(
                                fontFamily: 'SpaceGrotesk',
                                fontWeight: FontWeight.w700,
                                fontSize: 11,
                                color: colors.statusSlaBreached,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

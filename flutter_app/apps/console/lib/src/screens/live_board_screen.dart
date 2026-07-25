import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class LiveBoardScreen extends ConsumerStatefulWidget {
  const LiveBoardScreen({super.key});

  @override
  ConsumerState<LiveBoardScreen> createState() => _LiveBoardScreenState();
}

class _LiveBoardScreenState extends ConsumerState<LiveBoardScreen> {
  List<Ticket> _tickets = [];
  bool _isLoading = true;
  RealtimeChannel? _realtimeChannel;

  // Filter States
  String _selectedSeverity = 'all';
  String _selectedShift = 'all';
  String _selectedLine = 'all';

  @override
  void initState() {
    super.initState();
    _loadTickets();
    _subscribeRealtime();
  }

  @override
  void dispose() {
    if (_realtimeChannel != null) {
      Supabase.instance.client.removeChannel(_realtimeChannel!);
    }
    super.dispose();
  }

  Future<void> _loadTickets() async {
    try {
      final repo = ref.read(consoleTicketRepositoryProvider);
      final list = await repo.getTickets();
      setState(() {
        _tickets = list;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _subscribeRealtime() {
    final client = Supabase.instance.client;
    ref.read(consoleRealtimeConnectedProvider.notifier).state = true;

    _realtimeChannel = client.channel('public:tickets')
      ..onPostgresChanges(
        event: PostgresChangeEvent.all,
        schema: 'public',
        table: 'tickets',
        callback: (payload) {
          _handleRealtimePayload(payload);
        },
      )
      ..subscribe((status, _) {
        if (status == RealtimeSubscribeStatus.subscribed) {
          ref.read(consoleRealtimeConnectedProvider.notifier).state = true;
        } else if (status == RealtimeSubscribeStatus.closed || status == RealtimeSubscribeStatus.channelError) {
          ref.read(consoleRealtimeConnectedProvider.notifier).state = false;
        }
      });
  }

  void _handleRealtimePayload(PostgresChangePayload payload) {
    setState(() {
      if (payload.eventType == PostgresChangeEvent.insert) {
        final newTicket = Ticket.fromJson(payload.newRecord);
        _tickets = [newTicket, ..._tickets];
      } else if (payload.eventType == PostgresChangeEvent.update) {
        final updatedTicket = Ticket.fromJson(payload.newRecord);
        _tickets = _tickets.map((t) => t.id == updatedTicket.id ? updatedTicket : t).toList();
      } else if (payload.eventType == PostgresChangeEvent.delete) {
        final deletedId = payload.oldRecord['id'] as String;
        _tickets = _tickets.where((t) => t.id != deletedId).toList();
      }
    });
  }

  Future<void> _updateTicketStatus(String id, TicketStatus newStatus) async {
    try {
      final repo = ref.read(consoleTicketRepositoryProvider);
      await repo.updateTicketStatus(id, newStatus);
      // Local state is updated automatically via the Realtime channel webhook callback
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to update status: $e')),
      );
    }
  }

  List<Ticket> _getFilteredTickets(TicketStatus status, String plantFilter) {
    return _tickets.where((t) {
      if (t.status != status) return false;

      // Filter by Plant Selector
      if (plantFilter != 'all') {
        // Query the line hierarchy of the plant
        final lines = ref.read(consoleLinesListProvider).valueOrNull ?? [];
        final line = lines.firstWhere((l) => l.id == t.lineId, orElse: () => Line(id: '', name: '', plantId: '', active: false));
        if (line.plantId != plantFilter) return false;
      }

      // Sidebar Filter states
      if (_selectedSeverity != 'all' && t.severity.name != _selectedSeverity) return false;
      if (_selectedLine != 'all' && t.lineId != _selectedLine) return false;

      // Infer Shift
      if (_selectedShift != 'all') {
        final hour = t.createdAt.toUtc().hour;
        var shift = 'C';
        if (hour >= 6 && hour < 14) shift = 'A';
        else if (hour >= 14 && hour < 22) shift = 'B';
        if (shift != _selectedShift) return false;
      }

      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final plantFilter = ref.watch(consoleSelectedPlantProvider);
    final lines = ref.watch(consoleLinesListProvider).valueOrNull ?? [];
    final stations = ref.watch(consoleStationsListProvider).valueOrNull ?? [];
    final categories = ref.watch(consoleCategoriesListProvider).valueOrNull ?? [];

    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    return Column(
      children: [
        // Filter Toolbar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          decoration: BoxDecoration(
            color: colors.panelBackground,
            border: Border(bottom: BorderSide(color: colors.panelBorder, width: 1)),
          ),
          child: Row(
            children: [
              const Icon(Icons.filter_list, size: 16),
              const SizedBox(width: 8),
              const Text('FILTERS:', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 11)),
              const SizedBox(width: 16),

              // Line Filter dropdown
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedLine,
                  items: [
                    const DropdownMenuItem(value: 'all', child: Text('ALL PRODUCTION LINES', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    ...lines.map((l) => DropdownMenuItem(value: l.id, child: Text(l.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12)))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedLine = val);
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Severity Filter
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedSeverity,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('ALL SEVERITIES', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    DropdownMenuItem(value: 'critical', child: Text('CRITICAL', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    DropdownMenuItem(value: 'major', child: Text('MAJOR', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    DropdownMenuItem(value: 'minor', child: Text('MINOR', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedSeverity = val);
                  },
                ),
              ),
              const SizedBox(width: 16),

              // Shift Filter
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedShift,
                  items: const [
                    DropdownMenuItem(value: 'all', child: Text('ALL SHIFTS', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    DropdownMenuItem(value: 'A', child: Text('SHIFT A (06:00 - 14:00)', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    DropdownMenuItem(value: 'B', child: Text('SHIFT B (14:00 - 22:00)', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                    DropdownMenuItem(value: 'C', child: Text('SHIFT C (22:00 - 06:00)', style: TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 12))),
                  ],
                  onChanged: (val) {
                    if (val != null) setState(() => _selectedShift = val);
                  },
                ),
              ),
              const Spacer(),

              // Refresh Board action
              OutlinedButton.icon(
                onPressed: _loadTickets,
                icon: const Icon(Icons.refresh, size: 14),
                label: const Text('REFRESH BOARD', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 11)),
              ),
            ],
          ),
        ),

        // Kanban Content View
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              const columns = TicketStatus.values;
              return Row(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: columns.map((col) {
                  final list = _getFilteredTickets(col, plantFilter);
                  return Expanded(
                    child: DragTarget<Ticket>(
                      onAcceptWithDetails: (details) {
                        _updateTicketStatus(details.data.id, col);
                      },
                      builder: (context, candidateData, rejectedData) {
                        final isOver = candidateData.isNotEmpty;
                        return Container(
                          decoration: BoxDecoration(
                            border: Border(right: BorderSide(color: colors.panelBorder, width: 0.5)),
                            color: isOver ? colors.brandAccent.withOpacity(0.02) : Colors.transparent,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Column Title Header
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                decoration: BoxDecoration(
                                  color: colors.panelBackground.withOpacity(0.4),
                                  border: Border(bottom: BorderSide(color: colors.panelBorder, width: 1)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      col.name.toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'SpaceGrotesk',
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12,
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: colors.panelBorder,
                                        borderRadius: const BorderRadius.all(Radius.circular(10)),
                                      ),
                                      child: Text(
                                        '${list.length}',
                                        style: TextStyle(
                                          fontFamily: 'JetBrainsMono',
                                          fontSize: 10,
                                          fontWeight: FontWeight.bold,
                                          color: colors.textPrimary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              // Ticket card lists
                              Expanded(
                                child: ListView.builder(
                                  padding: const EdgeInsets.all(12),
                                  itemCount: list.length,
                                  itemBuilder: (context, index) {
                                    final ticket = list[index];
                                    final line = lines.firstWhere((l) => l.id == ticket.lineId, orElse: () => Line(id: '', name: 'Unknown Line', plantId: '', active: false));
                                    final cat = categories.firstWhere((c) => c.id == ticket.defectCategoryId, orElse: () => DefectCategory(id: '', name: 'Defect', active: false));

                                    // Render Draggable card
                                    return Draggable<Ticket>(
                                      data: ticket,
                                      feedback: Material(
                                        color: Colors.transparent,
                                        child: SizedBox(
                                          width: 250,
                                          child: Opacity(
                                            opacity: 0.8,
                                            child: _KanbanCard(ticket: ticket, line: line, category: cat, colors: colors),
                                          ),
                                        ),
                                      ),
                                      childWhenDragging: Opacity(
                                        opacity: 0.3,
                                        child: _KanbanCard(ticket: ticket, line: line, category: cat, colors: colors),
                                      ),
                                      child: _KanbanCard(ticket: ticket, line: line, category: cat, colors: colors, onStatusChange: (s) => _updateTicketStatus(ticket.id, s)),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  );
                }).toList(),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _KanbanCard extends StatelessWidget {
  const _KanbanCard({
    required this.ticket,
    required this.line,
    required this.category,
    required this.colors,
    this.onStatusChange,
  });

  final Ticket ticket;
  final Line line;
  final DefectCategory category;
  final ArgusColors colors;
  final ValueChanged<TicketStatus>? onStatusChange;

  @override
  Widget build(BuildContext context) {
    // Derive SLA Deadline target (default 30/60/120)
    final targetMins = ticket.severity == TicketSeverity.critical
        ? 30
        : (ticket.severity == TicketSeverity.major ? 60 : 120);
    final deadline = ticket.createdAt.add(Duration(minutes: targetMins));
    final isBreached = DateTime.now().isAfter(deadline) &&
        ticket.status != TicketStatus.resolved &&
        ticket.status != TicketStatus.closed;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(6)),
          border: Border.all(
            color: isBreached ? colors.statusSlaBreached : Colors.transparent,
            width: isBreached ? 1.5 : 0,
          ),
        ),
        child: ArgusCard(
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Top row ID & Severity
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      ticket.id,
                      style: const TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    SeverityBadge(severity: ticket.severity),
                  ],
                ),
                const SizedBox(height: 8),

                // Category Title
                Text(
                  category.name.toUpperCase(),
                  style: const TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),

                // Description
                Text(
                  ticket.description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Inter',
                    fontSize: 11,
                    color: colors.textSecondary,
                  ),
                ),
                const SizedBox(height: 12),

                // Bottom row details
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      line.name.toUpperCase(),
                      style: TextStyle(
                        fontFamily: 'JetBrainsMono',
                        fontSize: 10,
                        color: colors.textSecondary,
                      ),
                    ),
                    if (ticket.status != TicketStatus.resolved && ticket.status != TicketStatus.closed)
                      Row(
                        children: [
                          Icon(Icons.timer_outlined, size: 10, color: isBreached ? colors.statusSlaBreached : Colors.grey),
                          const SizedBox(width: 2),
                          MonospaceTatCounter(deadline: deadline),
                        ],
                      ),
                  ],
                ),

                // Manual status shift actions for desktop comfort
                if (onStatusChange != null) ...[
                  const Divider(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'MOVE:',
                        style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 8, color: Colors.grey),
                      ),
                      const SizedBox(width: 4),
                      DropdownButtonHideUnderline(
                        child: DropdownButton<TicketStatus>(
                          iconSize: 14,
                          value: ticket.status,
                          items: TicketStatus.values.map((s) => DropdownMenuItem(
                                value: s,
                                child: Text(s.name.toUpperCase(), style: const TextStyle(fontFamily: 'SpaceGrotesk', fontSize: 9)),
                              )).toList(),
                          onChanged: (val) {
                            if (val != null && val != ticket.status) {
                              onStatusChange!(val);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

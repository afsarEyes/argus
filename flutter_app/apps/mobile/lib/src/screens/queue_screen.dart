import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/local_providers.dart';

class MyQueueScreen extends ConsumerStatefulWidget {
  const MyQueueScreen({super.key});

  @override
  ConsumerState<MyQueueScreen> createState() => _MyQueueScreenState();
}

class _MyQueueScreenState extends ConsumerState<MyQueueScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  bool _isOffline = false;
  List<Ticket> _tickets = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _checkConnectivity();
    _loadTickets();
    Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (mounted) {
        setState(() {
          _isOffline = !hasConnection;
        });
        _loadTickets();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _checkConnectivity() async {
    final result = await Connectivity().checkConnectivity();
    final hasConnection = result.any((r) => r != ConnectivityResult.none);
    setState(() {
      _isOffline = !hasConnection;
    });
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

  List<Ticket> _getTicketsByStatus(List<TicketStatus> statuses) {
    return _tickets.where((t) => statuses.contains(t.status)).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'QC TICKET QUEUE',
          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadTickets,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: colors.brandAccent,
          labelColor: colors.brandAccent,
          unselectedLabelColor: colors.textSecondary,
          tabs: const [
            Tab(text: 'OPEN'),
            Tab(text: 'IN PROGRESS'),
            Tab(text: 'RESOLVED'),
          ],
        ),
      ),
      body: Column(
        children: [
          // Connectivity Status Indicator Bar
          if (_isOffline)
            Container(
              color: colors.brandAccent.withOpacity(0.2),
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.cloud_off, size: 16, color: colors.brandAccent),
                  const SizedBox(width: 8),
                  Text(
                    'OPERATING OFFLINE - DEMANDS QUEUED LOCALLY',
                    style: TextStyle(
                      fontFamily: 'JetBrainsMono',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: colors.brandAccent,
                    ),
                  ),
                ],
              ),
            ),

          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  )
                : TabBarView(
                    controller: _tabController,
                    children: [
                      _TicketListFeed(
                        tickets: _getTicketsByStatus([TicketStatus.open, TicketStatus.assigned]),
                        onRefresh: _loadTickets,
                      ),
                      _TicketListFeed(
                        tickets: _getTicketsByStatus([TicketStatus.inProgress]),
                        onRefresh: _loadTickets,
                      ),
                      _TicketListFeed(
                        tickets: _getTicketsByStatus([TicketStatus.resolved, TicketStatus.closed]),
                        onRefresh: _loadTickets,
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _TicketListFeed extends ConsumerWidget {
  const _TicketListFeed({
    required this.tickets,
    required this.onRefresh,
  });

  final List<Ticket> tickets;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (tickets.isEmpty) {
      return ArgusEmptyState(
        icon: Icons.list_alt,
        title: 'QUEUE EMPTY',
        message: 'No tickets in this section of the queue.',
        actionLabel: 'Refresh',
        onActionPressed: onRefresh,
      );
    }

    final linesAsync = ref.watch(linesListProvider);
    final stationsAsync = ref.watch(stationsListProvider);
    final categoriesAsync = ref.watch(defectCategoriesListProvider);

    final lines = linesAsync.valueOrNull ?? [];
    final stations = stationsAsync.valueOrNull ?? [];
    final categories = categoriesAsync.valueOrNull ?? [];

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: tickets.length,
        itemBuilder: (context, index) {
          final ticket = tickets[index];

          final lineName = lines.firstWhere((l) => l.id == ticket.lineId, orElse: () => Line(id: '', name: 'Line ${ticket.lineId}', plantId: '', active: true)).name;
          final stationName = stations.firstWhere((s) => s.id == ticket.stationId, orElse: () => Station(id: '', name: 'Station ${ticket.stationId}', lineId: '', active: true)).name;
          final categoryName = categories.firstWhere((c) => c.id == ticket.defectCategoryId, orElse: () => DefectCategory(id: '', name: 'Defect', active: true)).name;

          // Determine target SLA breach minutes based on severity
          int targetMinutes = 120; // Default
          if (ticket.severity == TicketSeverity.critical) targetMinutes = 30;
          if (ticket.severity == TicketSeverity.major) targetMinutes = 60;

          final deadline = ticket.createdAt.add(Duration(minutes: targetMinutes));

          return Padding(
            padding: const EdgeInsets.only(bottom: 12.0),
            child: InkWell(
              onTap: () {
                context.go('/queue/tickets/${ticket.id}');
              },
              child: ArgusCard(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Header Row: Ticket ID (monospace) & Severity Badge & Status Badge
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Text(
                                ticket.id.startsWith('ARG-') ? ticket.id : 'ARG-LOCAL',
                                style: const TextStyle(
                                  fontFamily: 'JetBrainsMono',
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                ),
                              ),
                              const SizedBox(width: 8),
                              if (ticket.syncStatus == TicketSyncStatus.pendingSync)
                                const Icon(Icons.cloud_upload_outlined, size: 16, color: Colors.orange)
                              else if (ticket.syncStatus == TicketSyncStatus.error)
                                const Icon(Icons.error_outline, size: 16, color: Colors.red),
                            ],
                          ),
                          Row(
                            children: [
                              SeverityBadge(severity: ticket.severity),
                              const SizedBox(width: 8),
                              StatusBadge(
                                status: ticket.status,
                                isChip: true,
                                isSlaBreached: DateTime.now().isAfter(deadline) &&
                                    ticket.status != TicketStatus.resolved &&
                                    ticket.status != TicketStatus.closed,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Title: Category Name
                      Text(
                        categoryName.toUpperCase(),
                        style: const TextStyle(
                          fontFamily: 'SpaceGrotesk',
                          fontWeight: FontWeight.w700,
                          fontSize: 16,
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
                          fontSize: 13,
                          color: Theme.of(context).extension<ArgusColors>()!.textSecondary,
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Footer details: Line/Station & MonospaceTatCounter
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '$lineName // $stationName'.toUpperCase(),
                            style: TextStyle(
                              fontFamily: 'JetBrainsMono',
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              color: Theme.of(context).extension<ArgusColors>()!.textSecondary,
                            ),
                          ),
                          if (ticket.status != TicketStatus.resolved && ticket.status != TicketStatus.closed)
                            Row(
                              children: [
                                const Icon(Icons.timer, size: 14, color: Colors.grey),
                                const SizedBox(width: 4),
                                MonospaceTatCounter(deadline: deadline),
                              ],
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

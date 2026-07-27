import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/local_providers.dart';
import '../routing/app_router.dart';

// Riverpod providers for events and active users lookup
final ticketEventsProvider = FutureProvider.family<List<TicketEvent>, String>((ref, ticketId) async {
  final client = ref.watch(supabaseClientProvider);
  try {
    final List<dynamic> data = await client
        .from('ticket_events')
        .select()
        .eq('ticket_id', ticketId)
        .order('created_at', ascending: false);
    return data.map((json) => TicketEvent.fromJson(json)).toList();
  } catch (_) {
    return [];
  }
});

final activeUsersListProvider = FutureProvider<List<User>>((ref) async {
  final client = ref.watch(supabaseClientProvider);
  final List<dynamic> data = await client.from('users').select().eq('is_active', true);
  return data.map((json) => User.fromJson(json)).toList();
});

class TicketDetailScreen extends ConsumerStatefulWidget {
  const TicketDetailScreen({super.key, required this.ticketId});

  final String ticketId;

  @override
  ConsumerState<TicketDetailScreen> createState() => _TicketDetailScreenState();
}

class _TicketDetailScreenState extends ConsumerState<TicketDetailScreen> {
  Ticket? _ticket;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadTicketDetails();
  }

  Future<void> _loadTicketDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final ticketRepo = ref.read(ticketRepositoryProvider);
      final tickets = await ticketRepo.getTickets();
      final ticket = tickets.firstWhere((t) => t.id == widget.ticketId);
      setState(() {
        _ticket = ticket;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'Failed to load ticket details: $e';
        _isLoading = false;
      });
    }
  }

  Future<void> _updateStatus(TicketStatus newStatus, {String? rootCause, String? correctiveAction}) async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    try {
      final repo = ref.read(ticketRepositoryProvider);
      final updated = await repo.updateTicketStatus(
        widget.ticketId,
        newStatus,
        rootCause: rootCause,
        correctiveAction: correctiveAction,
      );
      
      setState(() {
        _ticket = updated;
      });
      ref.invalidate(ticketEventsProvider(widget.ticketId));
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ticket status updated to ${newStatus.name.toUpperCase()}'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating status: $e'), backgroundColor: Colors.red),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _reassignTicket(User targetUser) async {
    HapticFeedback.lightImpact();
    setState(() {
      _isLoading = true;
    });

    try {
      final client = ref.read(supabaseClientProvider);
      await client
          .from('tickets')
          .update({'assigned_owner_id': targetUser.id})
          .eq('id', widget.ticketId);

      ref.invalidate(ticketEventsProvider(widget.ticketId));
      await _loadTicketDetails();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Ticket reassigned to ${targetUser.name}'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error reassigning ticket: $e'), backgroundColor: Colors.red),
        );
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _showResolveBottomSheet() {
    final rootController = TextEditingController();
    final correctiveController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).cardColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
      ),
      builder: (context) {
        final colors = Theme.of(context).extension<ArgusColors>()!;
        final bottomInset = MediaQuery.of(context).viewInsets.bottom;

        return Padding(
          padding: EdgeInsets.fromLTRB(16, 16, 16, bottomInset + 16),
          child: Form(
            key: formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'RESOLVE TICKET',
                  style: TextStyle(
                    fontFamily: 'SpaceGrotesk',
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: colors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: rootController,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Root Cause Description',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.brandAccent)),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Describe the root cause.' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: correctiveController,
                  style: TextStyle(color: colors.textPrimary),
                  decoration: InputDecoration(
                    labelText: 'Corrective Action Taken',
                    labelStyle: TextStyle(color: colors.textSecondary),
                    enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.panelBorder)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: colors.brandAccent)),
                  ),
                  validator: (v) => v == null || v.trim().isEmpty ? 'Describe the corrective action taken.' : null,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    if (formKey.currentState!.validate()) {
                      Navigator.pop(context);
                      _updateStatus(
                        TicketStatus.resolved,
                        rootCause: rootController.text.trim(),
                        correctiveAction: correctiveController.text.trim(),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.brandAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  child: const Text(
                    'SUBMIT RESOLUTION',
                    style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showReassignDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Consumer(
          builder: (context, ref, _) {
            final usersAsync = ref.watch(activeUsersListProvider);
            final colors = Theme.of(context).extension<ArgusColors>()!;

            return AlertDialog(
              backgroundColor: colors.panelBackground,
              title: Text(
                'REASSIGN TICKET OWNER',
                style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, color: colors.textPrimary, fontSize: 16),
              ),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: usersAsync.when(
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Text('Error: $e'),
                  data: (users) {
                    return ListView.builder(
                      itemCount: users.length,
                      itemBuilder: (context, index) {
                        final u = users[index];
                        return ListTile(
                          title: Text(u.name, style: TextStyle(color: colors.textPrimary)),
                          subtitle: Text('${u.role.name.toUpperCase()} // ${u.shift ?? 'NO SHIFT'}', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                          onTap: () {
                            Navigator.pop(context);
                            _reassignTicket(u);
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final userStream = ref.watch(appUserStreamProvider);
    final currentUser = userStream.valueOrNull;

    if (_isLoading && _ticket == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('LOADING...')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(title: const Text('ERROR')),
        body: Center(
          child: ArgusErrorState(
            errorMessage: _errorMessage!,
            onRetry: _loadTicketDetails,
          ),
        ),
      );
    }

    final ticket = _ticket!;
    final eventsAsync = ref.watch(ticketEventsProvider(ticket.id));

    // Resolve static labels
    final lines = ref.watch(linesListProvider).valueOrNull ?? [];
    final stations = ref.watch(stationsListProvider).valueOrNull ?? [];
    final categories = ref.watch(defectCategoriesListProvider).valueOrNull ?? [];

    final lineName = lines.firstWhere((l) => l.id == ticket.lineId, orElse: () => Line(id: '', name: 'Line ${ticket.lineId}', plantId: '', active: true)).name;
    final stationName = stations.firstWhere((s) => s.id == ticket.stationId, orElse: () => Station(id: '', name: 'Station ${ticket.stationId}', lineId: '', active: true)).name;
    final categoryName = categories.firstWhere((c) => c.id == ticket.defectCategoryId, orElse: () => DefectCategory(id: '', name: 'Defect Category', active: true)).name;

    int targetMinutes = 120;
    if (ticket.severity == TicketSeverity.critical) targetMinutes = 30;
    if (ticket.severity == TicketSeverity.major) targetMinutes = 60;
    final deadline = ticket.createdAt.add(Duration(minutes: targetMinutes));

    return Scaffold(
      appBar: AppBar(
        title: Text(
          ticket.id.startsWith('ARG-') ? ticket.id : 'ARG-LOCAL',
          style: const TextStyle(fontFamily: 'JetBrainsMono', fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadTicketDetails),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Severity & Status Badges
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
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
                  const SizedBox(height: 20),

                  // Defect Header
                  Text(
                    categoryName.toUpperCase(),
                    style: const TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 20),
                  ),
                  const SizedBox(height: 8),

                  // Metadata Card
                  ArgusPanel(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _buildMetaRow('LINE', lineName),
                          const Divider(),
                          _buildMetaRow('STATION', stationName),
                          const Divider(),
                          _buildMetaRow('REPORTED AT', ticket.createdAt.toLocal().toString().split('.').first),
                          if (ticket.syncStatus != TicketSyncStatus.synced) ...[
                            const Divider(),
                            _buildMetaRow('SYNC STATUS', ticket.syncStatus.name.toUpperCase()),
                          ],
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Defect Description
                  Text(
                    'DEFECT DESCRIPTION',
                    style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 12, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    ticket.description,
                    style: const TextStyle(fontFamily: 'Inter', fontSize: 14, height: 1.4),
                  ),
                  const SizedBox(height: 20),

                  // Photos Gallery section
                  if (ticket.photos.isNotEmpty) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'ATTACHED PHOTOS (${ticket.photos.length})',
                          style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 12, color: colors.textSecondary),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 120,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: ticket.photos.length,
                        itemBuilder: (context, index) {
                          final path = ticket.photos[index];
                          final cleanPath = path.replaceFirst('file://', '');
                          final isLocal = cleanPath.startsWith('/') || cleanPath.contains('argus_attachments');

                          Widget imageWidget;
                          if (isLocal) {
                            final file = File(cleanPath);
                            if (file.existsSync()) {
                              imageWidget = Image.file(
                                file,
                                width: 120,
                                height: 120,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(colors),
                              );
                            } else {
                              imageWidget = _buildImagePlaceholder(colors);
                            }
                          } else {
                            imageWidget = Image.network(
                              path,
                              width: 120,
                              height: 120,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => _buildImagePlaceholder(colors),
                            );
                          }

                          return GestureDetector(
                            onTap: () => _showFullscreenImage(context, path),
                            child: Padding(
                              padding: const EdgeInsets.only(right: 8.0),
                              child: ClipRRect(
                                borderRadius: const BorderRadius.all(Radius.circular(6)),
                                child: Container(
                                  decoration: BoxDecoration(
                                    border: Border.all(color: colors.panelBorder),
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                  child: imageWidget,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Resolution details
                  if (ticket.status == TicketStatus.resolved || ticket.status == TicketStatus.closed) ...[
                    Text(
                      'RESOLUTION INFO',
                      style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 12, color: colors.textSecondary),
                    ),
                    const SizedBox(height: 6),
                    ArgusPanel(
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text(
                              'ROOT CAUSE:',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 11, color: colors.brandAccent),
                            ),
                            Text(ticket.rootCause ?? 'No root cause specified', style: const TextStyle(fontFamily: 'Inter')),
                            const SizedBox(height: 12),
                            Text(
                              'CORRECTIVE ACTION:',
                              style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold, fontSize: 11, color: colors.brandAccent),
                            ),
                            Text(ticket.correctiveAction ?? 'No corrective action specified', style: const TextStyle(fontFamily: 'Inter')),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // Activity timeline feed
                  Text(
                    'ACTIVITY TIMELINE',
                    style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 12, color: colors.textSecondary),
                  ),
                  const SizedBox(height: 8),
                  eventsAsync.when(
                    loading: () => const Center(child: CircularProgressIndicator()),
                    error: (e, _) => Text('Error loading timeline: $e'),
                    data: (events) {
                      if (events.isEmpty) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Text('No status transitions logged yet.', style: TextStyle(color: colors.textSecondary, fontSize: 12)),
                        );
                      }
                      return Column(
                        children: events.map((ev) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(Icons.circle, size: 10, color: colors.brandAccent),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${ev.eventType.toUpperCase()} // ${ev.newValue ?? ''}'.trim(),
                                        style: TextStyle(color: colors.textPrimary, fontWeight: FontWeight.bold, fontSize: 13),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        ev.createdAt.toLocal().toString().split('.').first,
                                        style: TextStyle(color: colors.textSecondary, fontSize: 11, fontFamily: 'JetBrainsMono'),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Role-Aware Bottom Action Bar
          if (currentUser != null && _ticket != null && !_isLoading)
            _buildRoleActionButtons(currentUser, ticket),
        ],
      ),
    );
  }

  Widget _buildMetaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700, fontSize: 11, color: Theme.of(context).extension<ArgusColors>()!.textSecondary)),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: const TextStyle(fontFamily: 'Inter', fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRoleActionButtons(User user, Ticket ticket) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    final canManage = user.role == UserRole.admin ||
        user.role == UserRole.qualityManager ||
        user.role == UserRole.supervisor ||
        user.role == UserRole.lineOwner;

    if (ticket.status == TicketStatus.resolved || ticket.status == TicketStatus.closed) {
      return const SizedBox.shrink(); // Resolved tickets cannot be updated further in standard flow
    }

    return Container(
      color: colors.panelBackground,
      padding: const EdgeInsets.all(16.0),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            if (canManage) ...[
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    HapticFeedback.lightImpact();
                    _showReassignDialog();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.transparent,
                    foregroundColor: colors.brandAccent,
                    elevation: 0,
                    side: BorderSide(color: colors.brandAccent),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                  child: const Text('REASSIGN', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700)),
                ),
              ),
              const SizedBox(width: 12),
            ],
            if (ticket.status == TicketStatus.open || ticket.status == TicketStatus.assigned)
              Expanded(
                child: ElevatedButton(
                  onPressed: () => _updateStatus(TicketStatus.inProgress),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.brandAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                  child: const Text('START WORK', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700)),
                ),
              ),
            if (ticket.status == TicketStatus.inProgress)
              Expanded(
                child: ElevatedButton(
                  onPressed: _showResolveBottomSheet,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.brandAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(6))),
                  ),
                  child: const Text('RESOLVE', style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.w700)),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _showFullscreenImage(BuildContext context, String path) {
    final cleanPath = path.replaceFirst('file://', '');
    final isLocal = cleanPath.startsWith('/') || cleanPath.contains('argus_attachments');

    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.black,
          insetPadding: const EdgeInsets.all(12),
          child: Stack(
            alignment: Alignment.topRight,
            children: [
              InteractiveViewer(
                child: isLocal
                    ? Image.file(File(cleanPath), fit: BoxFit.contain)
                    : Image.network(path, fit: BoxFit.contain),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white, size: 28),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildImagePlaceholder(ArgusColors colors) {
    return Container(
      width: 120,
      height: 120,
      color: colors.panelBackground,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.broken_image, color: colors.textSecondary, size: 28),
          const SizedBox(height: 4),
          Text('Photo Unavailable', style: TextStyle(color: colors.textSecondary, fontSize: 10)),
        ],
      ),
    );
  }
}

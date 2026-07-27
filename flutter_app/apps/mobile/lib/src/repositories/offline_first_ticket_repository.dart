import 'package:flutter/foundation.dart';
import 'package:argus_core/argus_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../offline/database.dart';
import '../offline/sync_manager.dart';

class OfflineFirstTicketRepository implements TicketRepository {
  OfflineFirstTicketRepository({
    required this.remoteRepository,
    required this.db,
    required this.syncManager,
  });

  final TicketRepository remoteRepository;
  final AppDatabase db;
  final SyncManager syncManager;

  @override
  Future<List<Ticket>> getTickets({String? lineId, TicketStatus? status}) async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasConnection = connectivity.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        final remoteTickets = await remoteRepository.getTickets(lineId: lineId, status: status);
        return remoteTickets;
      }
    } catch (e) {
      debugPrint('OfflineFirstTicketRepository: Error fetching remote tickets -> $e');
    }

    // Fallback: Query all tickets from local Drift SQLite database
    final List<OfflineTicket> localData = await db.select(db.offlineTickets).get();

    final filtered = localData.where((t) {
      if (lineId != null && t.lineId != lineId) return false;
      if (status != null && t.status != status.toJson()) return false;
      return true;
    }).toList();

    return filtered.map((t) {
      return Ticket(
        id: t.humanReadableId ?? t.id,
        reporterId: t.reporterId,
        lineId: t.lineId,
        stationId: t.stationId,
        defectCategoryId: t.defectCategoryId,
        severity: TicketSeverity.values.firstWhere((e) => e.toJson() == t.severity),
        photos: t.photoPaths,
        voiceNoteUrl: t.voiceNotePath,
        description: t.description,
        status: TicketStatus.values.firstWhere((e) => e.toJson() == t.status),
        createdAt: t.createdAt,
        syncStatus: TicketSyncStatus.values.firstWhere((e) => e.toJson() == t.syncStatus),
        offlineId: t.id,
      );
    }).toList();
  }

  @override
  Future<Ticket> createTicket(Ticket ticket) async {
    final connectivity = await Connectivity().checkConnectivity();
    final hasConnection = connectivity.any((r) => r != ConnectivityResult.none);

    final localId = const Uuid().v4();
    final localTicket = ticket.copyWith(
      id: localId,
      syncStatus: TicketSyncStatus.pendingSync,
      offlineId: localId,
    );

    if (hasConnection) {
      try {
        debugPrint('OfflineFirstTicketRepository: Submitting to remote server...');
        final synced = await remoteRepository.createTicket(localTicket);
        debugPrint('OfflineFirstTicketRepository: Remote submission SUCCESS -> ID: ${synced.id}');
        return synced;
      } catch (e, stack) {
        debugPrint('OfflineFirstTicketRepository: Remote submission EXCEPTION -> $e');
        debugPrint('Stack: $stack');
        rethrow;
      }
    }

    // Save to local Drift SQLite database if offline
    await db.into(db.offlineTickets).insert(OfflineTicketsCompanion.insert(
          id: localId,
          reporterId: localTicket.reporterId,
          lineId: localTicket.lineId,
          stationId: localTicket.stationId,
          defectCategoryId: localTicket.defectCategoryId,
          severity: localTicket.severity.toJson(),
          photoPaths: localTicket.photos,
          voiceNotePath: Value(localTicket.voiceNoteUrl),
          description: localTicket.description,
          createdAt: localTicket.createdAt,
          syncStatus: const Value('pending_sync'),
          humanReadableId: const Value(null),
        ));

    // Trigger background sync task
    syncManager.triggerSync();

    return localTicket;
  }

  @override
  Future<Ticket> updateTicketStatus(
    String ticketId,
    TicketStatus status, {
    String? rootCause,
    String? correctiveAction,
  }) async {
    return remoteRepository.updateTicketStatus(
      ticketId,
      status,
      rootCause: rootCause,
      correctiveAction: correctiveAction,
    );
  }
}

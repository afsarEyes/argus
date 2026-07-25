import 'dart:async';
import 'dart:io';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:drift/drift.dart';
import 'database.dart';

class SyncManager {
  SyncManager(this._db, this._supabaseClient);

  final AppDatabase _db;
  final SupabaseClient _supabaseClient;

  StreamSubscription<List<ConnectivityResult>>? _subscription;
  bool _isSyncing = false;

  void startMonitoring() {
    _subscription = Connectivity().onConnectivityChanged.listen((results) {
      final hasConnection = results.any((r) => r != ConnectivityResult.none);
      if (hasConnection) {
        triggerSync();
      }
    });
  }

  void stopMonitoring() {
    _subscription?.cancel();
  }

  Future<void> triggerSync() async {
    if (_isSyncing) return;
    _isSyncing = true;

    try {
      final unsynced = await (_db.select(_db.offlineTickets)
            ..where((t) => t.syncStatus.isIn(['pending_sync', 'error'])))
          .get();

      for (final localTicket in unsynced) {
        await _syncTicket(localTicket);
      }
    } catch (_) {
      // Quietly log error or handle retry policies
    } finally {
      _isSyncing = false;
    }
  }

  Future<void> _syncTicket(OfflineTicket localTicket) async {
    // 1. Mark status as syncing
    await (_db.update(_db.offlineTickets)
          ..where((t) => t.id.equals(localTicket.id)))
        .write(const OfflineTicketsCompanion(syncStatus: Value('syncing')));

    try {
      // 2. Sync Idempotency check: query remote using local ticket UUID (offline_id)
      final existing = await _supabaseClient
          .from('tickets')
          .select()
          .eq('offline_id', localTicket.id)
          .maybeSingle();

      if (existing != null) {
        // Already synchronized from previous connection attempt
        await (_db.update(_db.offlineTickets)
              ..where((t) => t.id.equals(localTicket.id)))
            .write(OfflineTicketsCompanion(
              syncStatus: const Value('synced'),
              humanReadableId: Value(existing['id'] as String),
            ));
        return;
      }

      // 3. Upload photo attachments to Supabase Storage bucket 'ticket-attachments'
      final List<String> remotePhotoUrls = [];
      for (final localPath in localTicket.photoPaths) {
        final file = File(localPath);
        if (await file.exists()) {
          final fileName = localPath.split('/').last;
          final storagePath = 'tickets/${localTicket.id}/$fileName';

          await _supabaseClient.storage
              .from('ticket-attachments')
              .upload(storagePath, file);

          final publicUrl = _supabaseClient.storage
              .from('ticket-attachments')
              .getPublicUrl(storagePath);
          remotePhotoUrls.add(publicUrl);
        }
      }

      // 4. Upload voice notes if present
      String? remoteVoiceNoteUrl;
      if (localTicket.voiceNotePath != null) {
        final file = File(localTicket.voiceNotePath!);
        if (await file.exists()) {
          final fileName = localTicket.voiceNotePath!.split('/').last;
          final storagePath = 'tickets/${localTicket.id}/$fileName';

          await _supabaseClient.storage
              .from('ticket-attachments')
              .upload(storagePath, file);

          remoteVoiceNoteUrl = _supabaseClient.storage
              .from('ticket-attachments')
              .getPublicUrl(storagePath);
        }
      }

      // 5. Insert row into Supabase Tickets table
      final payload = {
        'reporter_id': localTicket.reporterId,
        'line_id': localTicket.lineId,
        'station_id': localTicket.stationId,
        'defect_category_id': localTicket.defectCategoryId,
        'severity': localTicket.severity,
        'photos': remotePhotoUrls,
        'voice_note_url': remoteVoiceNoteUrl,
        'description': localTicket.description,
        'status': localTicket.status,
        'offline_id': localTicket.id,
        'created_at': localTicket.createdAt.toIso8601String(),
      };

      final response = await _supabaseClient
          .from('tickets')
          .insert(payload)
          .select()
          .single();

      final remoteId = response['id'] as String;

      // 6. Update local status to synced and save the human readable ticket ID
      await (_db.update(_db.offlineTickets)
            ..where((t) => t.id.equals(localTicket.id)))
          .write(OfflineTicketsCompanion(
            syncStatus: const Value('synced'),
            humanReadableId: Value(remoteId),
          ));
    } catch (_) {
      // On failure, revert status to error for future retry attempts
      await (_db.update(_db.offlineTickets)
            ..where((t) => t.id.equals(localTicket.id)))
          .write(const OfflineTicketsCompanion(syncStatus: Value('error')));
    }
  }
}

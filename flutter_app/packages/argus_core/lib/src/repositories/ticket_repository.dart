import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/ticket.dart';
import '../enums/ticket_status.dart';
import '../services/supabase_client_provider.dart';

part 'ticket_repository.g.dart';

abstract class TicketRepository {
  Future<List<Ticket>> getTickets({String? lineId, TicketStatus? status});
  Future<Ticket> createTicket(Ticket ticket);
  Future<Ticket> updateTicketStatus(
    String ticketId,
    TicketStatus status, {
    String? rootCause,
    String? correctiveAction,
  });
}

class SupabaseTicketRepository implements TicketRepository {
  SupabaseTicketRepository(this._client);
  final supabase.SupabaseClient _client;

  @override
  Future<List<Ticket>> getTickets({String? lineId, TicketStatus? status}) async {
    var query = _client.from('tickets').select();
    if (lineId != null) {
      query = query.eq('line_id', lineId);
    }
    if (status != null) {
      query = query.eq('status', status.toJson());
    }
    final List<dynamic> data = await query.order('created_at', ascending: false);
    return data.map((json) => Ticket.fromJson(json)).toList();
  }

  @override
  Future<Ticket> createTicket(Ticket ticket) async {
    final json = ticket.toJson();
    if (json['id'] == null || json['id'] == '') {
      json.remove('id');
    }
    final data = await _client.from('tickets').insert(json).select().single();
    return Ticket.fromJson(data);
  }

  @override
  Future<Ticket> updateTicketStatus(
    String ticketId,
    TicketStatus status, {
    String? rootCause,
    String? correctiveAction,
  }) async {
    final Map<String, dynamic> updates = {'status': status.toJson()};
    if (rootCause != null) {
      updates['root_cause'] = rootCause;
    }
    if (correctiveAction != null) {
      updates['corrective_action'] = correctiveAction;
    }

    final now = DateTime.now().toUtc().toIso8601String();
    if (status == TicketStatus.assigned || status == TicketStatus.inProgress) {
      updates['acknowledged_at'] = now;
    } else if (status == TicketStatus.resolved) {
      updates['resolved_at'] = now;
    } else if (status == TicketStatus.closed) {
      updates['closed_at'] = now;
    }

    final data = await _client.from('tickets').update(updates).eq('id', ticketId).select().single();
    return Ticket.fromJson(data);
  }
}

@riverpod
TicketRepository ticketRepository(TicketRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseTicketRepository(client);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/ticket_severity.dart';
import '../enums/ticket_status.dart';
import '../enums/ticket_sync_status.dart';

part 'ticket.freezed.dart';
part 'ticket.g.dart';

@freezed
class Ticket with _$Ticket {
  const factory Ticket({
    required String id,
    required String reporterId,
    required String lineId,
    required String stationId,
    required String defectCategoryId,
    required TicketSeverity severity,
    required List<String> photos,
    String? voiceNoteUrl,
    required String description,
    required TicketStatus status,
    String? assignedOwnerId,
    String? offlineId,
    required DateTime createdAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    DateTime? closedAt,
    String? rootCause,
    String? correctiveAction,
    @Default(TicketSyncStatus.synced) TicketSyncStatus syncStatus,
  }) = _Ticket;

  factory Ticket.fromJson(Map<String, dynamic> json) => _$TicketFromJson(json);
}

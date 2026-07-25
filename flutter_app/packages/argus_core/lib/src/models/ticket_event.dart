import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_event.freezed.dart';
part 'ticket_event.g.dart';

@freezed
class TicketEvent with _$TicketEvent {
  const factory TicketEvent({
    required String id,
    required String ticketId,
    required String actorId,
    required String eventType,
    String? oldValue,
    String? newValue,
    required DateTime createdAt,
  }) = _TicketEvent;

  factory TicketEvent.fromJson(Map<String, dynamic> json) => _$TicketEventFromJson(json);
}

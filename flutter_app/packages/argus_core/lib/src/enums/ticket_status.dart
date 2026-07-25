import 'package:json_annotation/json_annotation.dart';

enum TicketStatus {
  @JsonValue('open')
  open,
  @JsonValue('assigned')
  assigned,
  @JsonValue('in_progress')
  inProgress,
  @JsonValue('resolved')
  resolved,
  @JsonValue('closed')
  closed;

  String toJson() => _$TicketStatusEnumMap[this]!;
}

const _$TicketStatusEnumMap = {
  TicketStatus.open: 'open',
  TicketStatus.assigned: 'assigned',
  TicketStatus.inProgress: 'in_progress',
  TicketStatus.resolved: 'resolved',
  TicketStatus.closed: 'closed',
};

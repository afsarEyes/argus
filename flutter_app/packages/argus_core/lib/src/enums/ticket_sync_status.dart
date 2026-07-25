import 'package:json_annotation/json_annotation.dart';

enum TicketSyncStatus {
  @JsonValue('synced')
  synced,
  @JsonValue('pendingSync')
  pendingSync,
  @JsonValue('error')
  error;

  String toJson() => _$TicketSyncStatusEnumMap[this]!;
}

const _$TicketSyncStatusEnumMap = {
  TicketSyncStatus.synced: 'synced',
  TicketSyncStatus.pendingSync: 'pendingSync',
  TicketSyncStatus.error: 'error',
};

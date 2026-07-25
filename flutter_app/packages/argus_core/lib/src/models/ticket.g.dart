// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketImpl _$$TicketImplFromJson(Map<String, dynamic> json) => _$TicketImpl(
  id: json['id'] as String,
  reporterId: json['reporter_id'] as String,
  lineId: json['line_id'] as String,
  stationId: json['station_id'] as String,
  defectCategoryId: json['defect_category_id'] as String,
  severity: $enumDecode(_$TicketSeverityEnumMap, json['severity']),
  photos: (json['photos'] as List<dynamic>).map((e) => e as String).toList(),
  voiceNoteUrl: json['voice_note_url'] as String?,
  description: json['description'] as String,
  status: $enumDecode(_$TicketStatusEnumMap, json['status']),
  assignedOwnerId: json['assigned_owner_id'] as String?,
  offlineId: json['offline_id'] as String?,
  createdAt: DateTime.parse(json['created_at'] as String),
  acknowledgedAt: json['acknowledged_at'] == null
      ? null
      : DateTime.parse(json['acknowledged_at'] as String),
  resolvedAt: json['resolved_at'] == null
      ? null
      : DateTime.parse(json['resolved_at'] as String),
  closedAt: json['closed_at'] == null
      ? null
      : DateTime.parse(json['closed_at'] as String),
  rootCause: json['root_cause'] as String?,
  correctiveAction: json['corrective_action'] as String?,
  syncStatus:
      $enumDecodeNullable(_$TicketSyncStatusEnumMap, json['sync_status']) ??
      TicketSyncStatus.synced,
);

Map<String, dynamic> _$$TicketImplToJson(_$TicketImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reporter_id': instance.reporterId,
      'line_id': instance.lineId,
      'station_id': instance.stationId,
      'defect_category_id': instance.defectCategoryId,
      'severity': instance.severity,
      'photos': instance.photos,
      'voice_note_url': instance.voiceNoteUrl,
      'description': instance.description,
      'status': instance.status,
      'assigned_owner_id': instance.assignedOwnerId,
      'offline_id': instance.offlineId,
      'created_at': instance.createdAt.toIso8601String(),
      'acknowledged_at': instance.acknowledgedAt?.toIso8601String(),
      'resolved_at': instance.resolvedAt?.toIso8601String(),
      'closed_at': instance.closedAt?.toIso8601String(),
      'root_cause': instance.rootCause,
      'corrective_action': instance.correctiveAction,
      'sync_status': instance.syncStatus,
    };

const _$TicketSeverityEnumMap = {
  TicketSeverity.critical: 'critical',
  TicketSeverity.major: 'major',
  TicketSeverity.minor: 'minor',
};

const _$TicketStatusEnumMap = {
  TicketStatus.open: 'open',
  TicketStatus.assigned: 'assigned',
  TicketStatus.inProgress: 'in_progress',
  TicketStatus.resolved: 'resolved',
  TicketStatus.closed: 'closed',
};

const _$TicketSyncStatusEnumMap = {
  TicketSyncStatus.synced: 'synced',
  TicketSyncStatus.pendingSync: 'pendingSync',
  TicketSyncStatus.error: 'error',
};

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ticket_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$TicketEventImpl _$$TicketEventImplFromJson(Map<String, dynamic> json) =>
    _$TicketEventImpl(
      id: json['id'] as String,
      ticketId: json['ticket_id'] as String,
      actorId: json['actor_id'] as String,
      eventType: json['event_type'] as String,
      oldValue: json['old_value'] as String?,
      newValue: json['new_value'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
    );

Map<String, dynamic> _$$TicketEventImplToJson(_$TicketEventImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ticket_id': instance.ticketId,
      'actor_id': instance.actorId,
      'event_type': instance.eventType,
      'old_value': instance.oldValue,
      'new_value': instance.newValue,
      'created_at': instance.createdAt.toIso8601String(),
    };

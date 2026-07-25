// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_log.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$NotificationLogImpl _$$NotificationLogImplFromJson(
  Map<String, dynamic> json,
) => _$NotificationLogImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  ticketId: json['ticket_id'] as String?,
  title: json['title'] as String,
  body: json['body'] as String,
  sentAt: DateTime.parse(json['sent_at'] as String),
);

Map<String, dynamic> _$$NotificationLogImplToJson(
  _$NotificationLogImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'user_id': instance.userId,
  'ticket_id': instance.ticketId,
  'title': instance.title,
  'body': instance.body,
  'sent_at': instance.sentAt.toIso8601String(),
};

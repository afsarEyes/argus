import 'package:freezed_annotation/freezed_annotation.dart';

part 'notification_log.freezed.dart';
part 'notification_log.g.dart';

@freezed
class NotificationLog with _$NotificationLog {
  const factory NotificationLog({
    required String id,
    required String userId,
    String? ticketId,
    required String title,
    required String body,
    required DateTime sentAt,
  }) = _NotificationLog;

  factory NotificationLog.fromJson(Map<String, dynamic> json) => _$NotificationLogFromJson(json);
}

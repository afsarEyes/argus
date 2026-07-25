import 'package:freezed_annotation/freezed_annotation.dart';
import '../enums/ticket_severity.dart';

part 'sla_target.freezed.dart';
part 'sla_target.g.dart';

@freezed
class SlaTarget with _$SlaTarget {
  const factory SlaTarget({
    required String id,
    required TicketSeverity severity,
    required int targetMinutes,
  }) = _SlaTarget;

  factory SlaTarget.fromJson(Map<String, dynamic> json) => _$SlaTargetFromJson(json);
}

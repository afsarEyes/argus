// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sla_target.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SlaTargetImpl _$$SlaTargetImplFromJson(Map<String, dynamic> json) =>
    _$SlaTargetImpl(
      id: json['id'] as String,
      severity: $enumDecode(_$TicketSeverityEnumMap, json['severity']),
      targetMinutes: (json['target_minutes'] as num).toInt(),
    );

Map<String, dynamic> _$$SlaTargetImplToJson(_$SlaTargetImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'severity': instance.severity,
      'target_minutes': instance.targetMinutes,
    };

const _$TicketSeverityEnumMap = {
  TicketSeverity.critical: 'critical',
  TicketSeverity.major: 'major',
  TicketSeverity.minor: 'minor',
};

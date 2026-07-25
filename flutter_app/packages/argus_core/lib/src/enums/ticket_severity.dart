import 'package:json_annotation/json_annotation.dart';

enum TicketSeverity {
  @JsonValue('critical')
  critical,
  @JsonValue('major')
  major,
  @JsonValue('minor')
  minor;

  String toJson() => _$TicketSeverityEnumMap[this]!;
}

const _$TicketSeverityEnumMap = {
  TicketSeverity.critical: 'critical',
  TicketSeverity.major: 'major',
  TicketSeverity.minor: 'minor',
};

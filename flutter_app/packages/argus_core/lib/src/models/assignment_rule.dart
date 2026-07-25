import 'package:freezed_annotation/freezed_annotation.dart';

part 'assignment_rule.freezed.dart';
part 'assignment_rule.g.dart';

@freezed
class AssignmentRule with _$AssignmentRule {
  const factory AssignmentRule({
    required String id,
    required String lineId,
    required String defectCategoryId,
    String? shift,
    required String assignedOwnerId,
  }) = _AssignmentRule;

  factory AssignmentRule.fromJson(Map<String, dynamic> json) => _$AssignmentRuleFromJson(json);
}

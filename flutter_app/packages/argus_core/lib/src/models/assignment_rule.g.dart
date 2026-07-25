// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'assignment_rule.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$AssignmentRuleImpl _$$AssignmentRuleImplFromJson(Map<String, dynamic> json) =>
    _$AssignmentRuleImpl(
      id: json['id'] as String,
      lineId: json['line_id'] as String,
      defectCategoryId: json['defect_category_id'] as String,
      shift: json['shift'] as String?,
      assignedOwnerId: json['assigned_owner_id'] as String,
    );

Map<String, dynamic> _$$AssignmentRuleImplToJson(
  _$AssignmentRuleImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'line_id': instance.lineId,
  'defect_category_id': instance.defectCategoryId,
  'shift': instance.shift,
  'assigned_owner_id': instance.assignedOwnerId,
};

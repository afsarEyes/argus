import 'package:json_annotation/json_annotation.dart';

enum UserRole {
  @JsonValue('staff')
  staff,
  @JsonValue('line_owner')
  lineOwner,
  @JsonValue('supervisor')
  supervisor,
  @JsonValue('quality_manager')
  qualityManager,
  @JsonValue('admin')
  admin;

  String toJson() => _$UserRoleEnumMap[this]!;
}

const _$UserRoleEnumMap = {
  UserRole.staff: 'staff',
  UserRole.lineOwner: 'line_owner',
  UserRole.supervisor: 'supervisor',
  UserRole.qualityManager: 'quality_manager',
  UserRole.admin: 'admin',
};

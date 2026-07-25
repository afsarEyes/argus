// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  role: $enumDecode(_$UserRoleEnumMap, json['role']),
  plantId: json['plant_id'] as String?,
  lineId: json['line_id'] as String?,
  shift: json['shift'] as String?,
);

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'email': instance.email,
      'name': instance.name,
      'role': instance.role,
      'plant_id': instance.plantId,
      'line_id': instance.lineId,
      'shift': instance.shift,
    };

const _$UserRoleEnumMap = {
  UserRole.staff: 'staff',
  UserRole.lineOwner: 'line_owner',
  UserRole.supervisor: 'supervisor',
  UserRole.qualityManager: 'quality_manager',
  UserRole.admin: 'admin',
};

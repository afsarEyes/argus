// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'line.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LineImpl _$$LineImplFromJson(Map<String, dynamic> json) => _$LineImpl(
  id: json['id'] as String,
  plantId: json['plant_id'] as String,
  name: json['name'] as String,
  active: json['active'] as bool,
);

Map<String, dynamic> _$$LineImplToJson(_$LineImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'plant_id': instance.plantId,
      'name': instance.name,
      'active': instance.active,
    };

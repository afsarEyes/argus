// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'defect_category.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DefectCategoryImpl _$$DefectCategoryImplFromJson(Map<String, dynamic> json) =>
    _$DefectCategoryImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      active: json['active'] as bool,
    );

Map<String, dynamic> _$$DefectCategoryImplToJson(
  _$DefectCategoryImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'active': instance.active,
};

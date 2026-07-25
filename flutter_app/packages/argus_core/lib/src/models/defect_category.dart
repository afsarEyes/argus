import 'package:freezed_annotation/freezed_annotation.dart';

part 'defect_category.freezed.dart';
part 'defect_category.g.dart';

@freezed
class DefectCategory with _$DefectCategory {
  const factory DefectCategory({
    required String id,
    required String name,
    String? description,
    required bool active,
  }) = _DefectCategory;

  factory DefectCategory.fromJson(Map<String, dynamic> json) => _$DefectCategoryFromJson(json);
}

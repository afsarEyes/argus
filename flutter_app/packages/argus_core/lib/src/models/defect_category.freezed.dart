// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'defect_category.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

DefectCategory _$DefectCategoryFromJson(Map<String, dynamic> json) {
  return _DefectCategory.fromJson(json);
}

/// @nodoc
mixin _$DefectCategory {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  bool get active => throw _privateConstructorUsedError;

  /// Serializes this DefectCategory to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of DefectCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $DefectCategoryCopyWith<DefectCategory> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $DefectCategoryCopyWith<$Res> {
  factory $DefectCategoryCopyWith(
    DefectCategory value,
    $Res Function(DefectCategory) then,
  ) = _$DefectCategoryCopyWithImpl<$Res, DefectCategory>;
  @useResult
  $Res call({String id, String name, String? description, bool active});
}

/// @nodoc
class _$DefectCategoryCopyWithImpl<$Res, $Val extends DefectCategory>
    implements $DefectCategoryCopyWith<$Res> {
  _$DefectCategoryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of DefectCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? active = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            active: null == active
                ? _value.active
                : active // ignore: cast_nullable_to_non_nullable
                      as bool,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$DefectCategoryImplCopyWith<$Res>
    implements $DefectCategoryCopyWith<$Res> {
  factory _$$DefectCategoryImplCopyWith(
    _$DefectCategoryImpl value,
    $Res Function(_$DefectCategoryImpl) then,
  ) = __$$DefectCategoryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String? description, bool active});
}

/// @nodoc
class __$$DefectCategoryImplCopyWithImpl<$Res>
    extends _$DefectCategoryCopyWithImpl<$Res, _$DefectCategoryImpl>
    implements _$$DefectCategoryImplCopyWith<$Res> {
  __$$DefectCategoryImplCopyWithImpl(
    _$DefectCategoryImpl _value,
    $Res Function(_$DefectCategoryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of DefectCategory
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? description = freezed,
    Object? active = null,
  }) {
    return _then(
      _$DefectCategoryImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        active: null == active
            ? _value.active
            : active // ignore: cast_nullable_to_non_nullable
                  as bool,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$DefectCategoryImpl implements _DefectCategory {
  const _$DefectCategoryImpl({
    required this.id,
    required this.name,
    this.description,
    required this.active,
  });

  factory _$DefectCategoryImpl.fromJson(Map<String, dynamic> json) =>
      _$$DefectCategoryImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String? description;
  @override
  final bool active;

  @override
  String toString() {
    return 'DefectCategory(id: $id, name: $name, description: $description, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$DefectCategoryImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.active, active) || other.active == active));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, description, active);

  /// Create a copy of DefectCategory
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$DefectCategoryImplCopyWith<_$DefectCategoryImpl> get copyWith =>
      __$$DefectCategoryImplCopyWithImpl<_$DefectCategoryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$DefectCategoryImplToJson(this);
  }
}

abstract class _DefectCategory implements DefectCategory {
  const factory _DefectCategory({
    required final String id,
    required final String name,
    final String? description,
    required final bool active,
  }) = _$DefectCategoryImpl;

  factory _DefectCategory.fromJson(Map<String, dynamic> json) =
      _$DefectCategoryImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String? get description;
  @override
  bool get active;

  /// Create a copy of DefectCategory
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$DefectCategoryImplCopyWith<_$DefectCategoryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

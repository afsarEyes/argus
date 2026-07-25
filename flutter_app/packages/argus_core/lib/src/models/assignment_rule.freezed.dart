// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'assignment_rule.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

AssignmentRule _$AssignmentRuleFromJson(Map<String, dynamic> json) {
  return _AssignmentRule.fromJson(json);
}

/// @nodoc
mixin _$AssignmentRule {
  String get id => throw _privateConstructorUsedError;
  String get lineId => throw _privateConstructorUsedError;
  String get defectCategoryId => throw _privateConstructorUsedError;
  String? get shift => throw _privateConstructorUsedError;
  String get assignedOwnerId => throw _privateConstructorUsedError;

  /// Serializes this AssignmentRule to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AssignmentRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AssignmentRuleCopyWith<AssignmentRule> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AssignmentRuleCopyWith<$Res> {
  factory $AssignmentRuleCopyWith(
    AssignmentRule value,
    $Res Function(AssignmentRule) then,
  ) = _$AssignmentRuleCopyWithImpl<$Res, AssignmentRule>;
  @useResult
  $Res call({
    String id,
    String lineId,
    String defectCategoryId,
    String? shift,
    String assignedOwnerId,
  });
}

/// @nodoc
class _$AssignmentRuleCopyWithImpl<$Res, $Val extends AssignmentRule>
    implements $AssignmentRuleCopyWith<$Res> {
  _$AssignmentRuleCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AssignmentRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lineId = null,
    Object? defectCategoryId = null,
    Object? shift = freezed,
    Object? assignedOwnerId = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as String,
            defectCategoryId: null == defectCategoryId
                ? _value.defectCategoryId
                : defectCategoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            shift: freezed == shift
                ? _value.shift
                : shift // ignore: cast_nullable_to_non_nullable
                      as String?,
            assignedOwnerId: null == assignedOwnerId
                ? _value.assignedOwnerId
                : assignedOwnerId // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$AssignmentRuleImplCopyWith<$Res>
    implements $AssignmentRuleCopyWith<$Res> {
  factory _$$AssignmentRuleImplCopyWith(
    _$AssignmentRuleImpl value,
    $Res Function(_$AssignmentRuleImpl) then,
  ) = __$$AssignmentRuleImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String lineId,
    String defectCategoryId,
    String? shift,
    String assignedOwnerId,
  });
}

/// @nodoc
class __$$AssignmentRuleImplCopyWithImpl<$Res>
    extends _$AssignmentRuleCopyWithImpl<$Res, _$AssignmentRuleImpl>
    implements _$$AssignmentRuleImplCopyWith<$Res> {
  __$$AssignmentRuleImplCopyWithImpl(
    _$AssignmentRuleImpl _value,
    $Res Function(_$AssignmentRuleImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of AssignmentRule
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? lineId = null,
    Object? defectCategoryId = null,
    Object? shift = freezed,
    Object? assignedOwnerId = null,
  }) {
    return _then(
      _$AssignmentRuleImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as String,
        defectCategoryId: null == defectCategoryId
            ? _value.defectCategoryId
            : defectCategoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        shift: freezed == shift
            ? _value.shift
            : shift // ignore: cast_nullable_to_non_nullable
                  as String?,
        assignedOwnerId: null == assignedOwnerId
            ? _value.assignedOwnerId
            : assignedOwnerId // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$AssignmentRuleImpl implements _AssignmentRule {
  const _$AssignmentRuleImpl({
    required this.id,
    required this.lineId,
    required this.defectCategoryId,
    this.shift,
    required this.assignedOwnerId,
  });

  factory _$AssignmentRuleImpl.fromJson(Map<String, dynamic> json) =>
      _$$AssignmentRuleImplFromJson(json);

  @override
  final String id;
  @override
  final String lineId;
  @override
  final String defectCategoryId;
  @override
  final String? shift;
  @override
  final String assignedOwnerId;

  @override
  String toString() {
    return 'AssignmentRule(id: $id, lineId: $lineId, defectCategoryId: $defectCategoryId, shift: $shift, assignedOwnerId: $assignedOwnerId)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AssignmentRuleImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.defectCategoryId, defectCategoryId) ||
                other.defectCategoryId == defectCategoryId) &&
            (identical(other.shift, shift) || other.shift == shift) &&
            (identical(other.assignedOwnerId, assignedOwnerId) ||
                other.assignedOwnerId == assignedOwnerId));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    lineId,
    defectCategoryId,
    shift,
    assignedOwnerId,
  );

  /// Create a copy of AssignmentRule
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AssignmentRuleImplCopyWith<_$AssignmentRuleImpl> get copyWith =>
      __$$AssignmentRuleImplCopyWithImpl<_$AssignmentRuleImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$AssignmentRuleImplToJson(this);
  }
}

abstract class _AssignmentRule implements AssignmentRule {
  const factory _AssignmentRule({
    required final String id,
    required final String lineId,
    required final String defectCategoryId,
    final String? shift,
    required final String assignedOwnerId,
  }) = _$AssignmentRuleImpl;

  factory _AssignmentRule.fromJson(Map<String, dynamic> json) =
      _$AssignmentRuleImpl.fromJson;

  @override
  String get id;
  @override
  String get lineId;
  @override
  String get defectCategoryId;
  @override
  String? get shift;
  @override
  String get assignedOwnerId;

  /// Create a copy of AssignmentRule
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AssignmentRuleImplCopyWith<_$AssignmentRuleImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

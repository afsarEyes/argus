// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sla_target.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

SlaTarget _$SlaTargetFromJson(Map<String, dynamic> json) {
  return _SlaTarget.fromJson(json);
}

/// @nodoc
mixin _$SlaTarget {
  String get id => throw _privateConstructorUsedError;
  TicketSeverity get severity => throw _privateConstructorUsedError;
  int get targetMinutes => throw _privateConstructorUsedError;

  /// Serializes this SlaTarget to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of SlaTarget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $SlaTargetCopyWith<SlaTarget> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $SlaTargetCopyWith<$Res> {
  factory $SlaTargetCopyWith(SlaTarget value, $Res Function(SlaTarget) then) =
      _$SlaTargetCopyWithImpl<$Res, SlaTarget>;
  @useResult
  $Res call({String id, TicketSeverity severity, int targetMinutes});
}

/// @nodoc
class _$SlaTargetCopyWithImpl<$Res, $Val extends SlaTarget>
    implements $SlaTargetCopyWith<$Res> {
  _$SlaTargetCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of SlaTarget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? severity = null,
    Object? targetMinutes = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as TicketSeverity,
            targetMinutes: null == targetMinutes
                ? _value.targetMinutes
                : targetMinutes // ignore: cast_nullable_to_non_nullable
                      as int,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$SlaTargetImplCopyWith<$Res>
    implements $SlaTargetCopyWith<$Res> {
  factory _$$SlaTargetImplCopyWith(
    _$SlaTargetImpl value,
    $Res Function(_$SlaTargetImpl) then,
  ) = __$$SlaTargetImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, TicketSeverity severity, int targetMinutes});
}

/// @nodoc
class __$$SlaTargetImplCopyWithImpl<$Res>
    extends _$SlaTargetCopyWithImpl<$Res, _$SlaTargetImpl>
    implements _$$SlaTargetImplCopyWith<$Res> {
  __$$SlaTargetImplCopyWithImpl(
    _$SlaTargetImpl _value,
    $Res Function(_$SlaTargetImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of SlaTarget
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? severity = null,
    Object? targetMinutes = null,
  }) {
    return _then(
      _$SlaTargetImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as TicketSeverity,
        targetMinutes: null == targetMinutes
            ? _value.targetMinutes
            : targetMinutes // ignore: cast_nullable_to_non_nullable
                  as int,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$SlaTargetImpl implements _SlaTarget {
  const _$SlaTargetImpl({
    required this.id,
    required this.severity,
    required this.targetMinutes,
  });

  factory _$SlaTargetImpl.fromJson(Map<String, dynamic> json) =>
      _$$SlaTargetImplFromJson(json);

  @override
  final String id;
  @override
  final TicketSeverity severity;
  @override
  final int targetMinutes;

  @override
  String toString() {
    return 'SlaTarget(id: $id, severity: $severity, targetMinutes: $targetMinutes)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$SlaTargetImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            (identical(other.targetMinutes, targetMinutes) ||
                other.targetMinutes == targetMinutes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, severity, targetMinutes);

  /// Create a copy of SlaTarget
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$SlaTargetImplCopyWith<_$SlaTargetImpl> get copyWith =>
      __$$SlaTargetImplCopyWithImpl<_$SlaTargetImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$SlaTargetImplToJson(this);
  }
}

abstract class _SlaTarget implements SlaTarget {
  const factory _SlaTarget({
    required final String id,
    required final TicketSeverity severity,
    required final int targetMinutes,
  }) = _$SlaTargetImpl;

  factory _SlaTarget.fromJson(Map<String, dynamic> json) =
      _$SlaTargetImpl.fromJson;

  @override
  String get id;
  @override
  TicketSeverity get severity;
  @override
  int get targetMinutes;

  /// Create a copy of SlaTarget
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$SlaTargetImplCopyWith<_$SlaTargetImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

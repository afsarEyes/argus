// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket_event.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

TicketEvent _$TicketEventFromJson(Map<String, dynamic> json) {
  return _TicketEvent.fromJson(json);
}

/// @nodoc
mixin _$TicketEvent {
  String get id => throw _privateConstructorUsedError;
  String get ticketId => throw _privateConstructorUsedError;
  String get actorId => throw _privateConstructorUsedError;
  String get eventType => throw _privateConstructorUsedError;
  String? get oldValue => throw _privateConstructorUsedError;
  String? get newValue => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;

  /// Serializes this TicketEvent to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of TicketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketEventCopyWith<TicketEvent> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketEventCopyWith<$Res> {
  factory $TicketEventCopyWith(
    TicketEvent value,
    $Res Function(TicketEvent) then,
  ) = _$TicketEventCopyWithImpl<$Res, TicketEvent>;
  @useResult
  $Res call({
    String id,
    String ticketId,
    String actorId,
    String eventType,
    String? oldValue,
    String? newValue,
    DateTime createdAt,
  });
}

/// @nodoc
class _$TicketEventCopyWithImpl<$Res, $Val extends TicketEvent>
    implements $TicketEventCopyWith<$Res> {
  _$TicketEventCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of TicketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? actorId = null,
    Object? eventType = null,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            ticketId: null == ticketId
                ? _value.ticketId
                : ticketId // ignore: cast_nullable_to_non_nullable
                      as String,
            actorId: null == actorId
                ? _value.actorId
                : actorId // ignore: cast_nullable_to_non_nullable
                      as String,
            eventType: null == eventType
                ? _value.eventType
                : eventType // ignore: cast_nullable_to_non_nullable
                      as String,
            oldValue: freezed == oldValue
                ? _value.oldValue
                : oldValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            newValue: freezed == newValue
                ? _value.newValue
                : newValue // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TicketEventImplCopyWith<$Res>
    implements $TicketEventCopyWith<$Res> {
  factory _$$TicketEventImplCopyWith(
    _$TicketEventImpl value,
    $Res Function(_$TicketEventImpl) then,
  ) = __$$TicketEventImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String ticketId,
    String actorId,
    String eventType,
    String? oldValue,
    String? newValue,
    DateTime createdAt,
  });
}

/// @nodoc
class __$$TicketEventImplCopyWithImpl<$Res>
    extends _$TicketEventCopyWithImpl<$Res, _$TicketEventImpl>
    implements _$$TicketEventImplCopyWith<$Res> {
  __$$TicketEventImplCopyWithImpl(
    _$TicketEventImpl _value,
    $Res Function(_$TicketEventImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of TicketEvent
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? ticketId = null,
    Object? actorId = null,
    Object? eventType = null,
    Object? oldValue = freezed,
    Object? newValue = freezed,
    Object? createdAt = null,
  }) {
    return _then(
      _$TicketEventImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        ticketId: null == ticketId
            ? _value.ticketId
            : ticketId // ignore: cast_nullable_to_non_nullable
                  as String,
        actorId: null == actorId
            ? _value.actorId
            : actorId // ignore: cast_nullable_to_non_nullable
                  as String,
        eventType: null == eventType
            ? _value.eventType
            : eventType // ignore: cast_nullable_to_non_nullable
                  as String,
        oldValue: freezed == oldValue
            ? _value.oldValue
            : oldValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        newValue: freezed == newValue
            ? _value.newValue
            : newValue // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketEventImpl implements _TicketEvent {
  const _$TicketEventImpl({
    required this.id,
    required this.ticketId,
    required this.actorId,
    required this.eventType,
    this.oldValue,
    this.newValue,
    required this.createdAt,
  });

  factory _$TicketEventImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketEventImplFromJson(json);

  @override
  final String id;
  @override
  final String ticketId;
  @override
  final String actorId;
  @override
  final String eventType;
  @override
  final String? oldValue;
  @override
  final String? newValue;
  @override
  final DateTime createdAt;

  @override
  String toString() {
    return 'TicketEvent(id: $id, ticketId: $ticketId, actorId: $actorId, eventType: $eventType, oldValue: $oldValue, newValue: $newValue, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketEventImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.actorId, actorId) || other.actorId == actorId) &&
            (identical(other.eventType, eventType) ||
                other.eventType == eventType) &&
            (identical(other.oldValue, oldValue) ||
                other.oldValue == oldValue) &&
            (identical(other.newValue, newValue) ||
                other.newValue == newValue) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    ticketId,
    actorId,
    eventType,
    oldValue,
    newValue,
    createdAt,
  );

  /// Create a copy of TicketEvent
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketEventImplCopyWith<_$TicketEventImpl> get copyWith =>
      __$$TicketEventImplCopyWithImpl<_$TicketEventImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketEventImplToJson(this);
  }
}

abstract class _TicketEvent implements TicketEvent {
  const factory _TicketEvent({
    required final String id,
    required final String ticketId,
    required final String actorId,
    required final String eventType,
    final String? oldValue,
    final String? newValue,
    required final DateTime createdAt,
  }) = _$TicketEventImpl;

  factory _TicketEvent.fromJson(Map<String, dynamic> json) =
      _$TicketEventImpl.fromJson;

  @override
  String get id;
  @override
  String get ticketId;
  @override
  String get actorId;
  @override
  String get eventType;
  @override
  String? get oldValue;
  @override
  String? get newValue;
  @override
  DateTime get createdAt;

  /// Create a copy of TicketEvent
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketEventImplCopyWith<_$TicketEventImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

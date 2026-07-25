// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'notification_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

NotificationLog _$NotificationLogFromJson(Map<String, dynamic> json) {
  return _NotificationLog.fromJson(json);
}

/// @nodoc
mixin _$NotificationLog {
  String get id => throw _privateConstructorUsedError;
  String get userId => throw _privateConstructorUsedError;
  String? get ticketId => throw _privateConstructorUsedError;
  String get title => throw _privateConstructorUsedError;
  String get body => throw _privateConstructorUsedError;
  DateTime get sentAt => throw _privateConstructorUsedError;

  /// Serializes this NotificationLog to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $NotificationLogCopyWith<NotificationLog> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $NotificationLogCopyWith<$Res> {
  factory $NotificationLogCopyWith(
    NotificationLog value,
    $Res Function(NotificationLog) then,
  ) = _$NotificationLogCopyWithImpl<$Res, NotificationLog>;
  @useResult
  $Res call({
    String id,
    String userId,
    String? ticketId,
    String title,
    String body,
    DateTime sentAt,
  });
}

/// @nodoc
class _$NotificationLogCopyWithImpl<$Res, $Val extends NotificationLog>
    implements $NotificationLogCopyWith<$Res> {
  _$NotificationLogCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ticketId = freezed,
    Object? title = null,
    Object? body = null,
    Object? sentAt = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            ticketId: freezed == ticketId
                ? _value.ticketId
                : ticketId // ignore: cast_nullable_to_non_nullable
                      as String?,
            title: null == title
                ? _value.title
                : title // ignore: cast_nullable_to_non_nullable
                      as String,
            body: null == body
                ? _value.body
                : body // ignore: cast_nullable_to_non_nullable
                      as String,
            sentAt: null == sentAt
                ? _value.sentAt
                : sentAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$NotificationLogImplCopyWith<$Res>
    implements $NotificationLogCopyWith<$Res> {
  factory _$$NotificationLogImplCopyWith(
    _$NotificationLogImpl value,
    $Res Function(_$NotificationLogImpl) then,
  ) = __$$NotificationLogImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String userId,
    String? ticketId,
    String title,
    String body,
    DateTime sentAt,
  });
}

/// @nodoc
class __$$NotificationLogImplCopyWithImpl<$Res>
    extends _$NotificationLogCopyWithImpl<$Res, _$NotificationLogImpl>
    implements _$$NotificationLogImplCopyWith<$Res> {
  __$$NotificationLogImplCopyWithImpl(
    _$NotificationLogImpl _value,
    $Res Function(_$NotificationLogImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? ticketId = freezed,
    Object? title = null,
    Object? body = null,
    Object? sentAt = null,
  }) {
    return _then(
      _$NotificationLogImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        ticketId: freezed == ticketId
            ? _value.ticketId
            : ticketId // ignore: cast_nullable_to_non_nullable
                  as String?,
        title: null == title
            ? _value.title
            : title // ignore: cast_nullable_to_non_nullable
                  as String,
        body: null == body
            ? _value.body
            : body // ignore: cast_nullable_to_non_nullable
                  as String,
        sentAt: null == sentAt
            ? _value.sentAt
            : sentAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$NotificationLogImpl implements _NotificationLog {
  const _$NotificationLogImpl({
    required this.id,
    required this.userId,
    this.ticketId,
    required this.title,
    required this.body,
    required this.sentAt,
  });

  factory _$NotificationLogImpl.fromJson(Map<String, dynamic> json) =>
      _$$NotificationLogImplFromJson(json);

  @override
  final String id;
  @override
  final String userId;
  @override
  final String? ticketId;
  @override
  final String title;
  @override
  final String body;
  @override
  final DateTime sentAt;

  @override
  String toString() {
    return 'NotificationLog(id: $id, userId: $userId, ticketId: $ticketId, title: $title, body: $body, sentAt: $sentAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$NotificationLogImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.ticketId, ticketId) ||
                other.ticketId == ticketId) &&
            (identical(other.title, title) || other.title == title) &&
            (identical(other.body, body) || other.body == body) &&
            (identical(other.sentAt, sentAt) || other.sentAt == sentAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, userId, ticketId, title, body, sentAt);

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$NotificationLogImplCopyWith<_$NotificationLogImpl> get copyWith =>
      __$$NotificationLogImplCopyWithImpl<_$NotificationLogImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$NotificationLogImplToJson(this);
  }
}

abstract class _NotificationLog implements NotificationLog {
  const factory _NotificationLog({
    required final String id,
    required final String userId,
    final String? ticketId,
    required final String title,
    required final String body,
    required final DateTime sentAt,
  }) = _$NotificationLogImpl;

  factory _NotificationLog.fromJson(Map<String, dynamic> json) =
      _$NotificationLogImpl.fromJson;

  @override
  String get id;
  @override
  String get userId;
  @override
  String? get ticketId;
  @override
  String get title;
  @override
  String get body;
  @override
  DateTime get sentAt;

  /// Create a copy of NotificationLog
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$NotificationLogImplCopyWith<_$NotificationLogImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

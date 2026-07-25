// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'ticket.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Ticket _$TicketFromJson(Map<String, dynamic> json) {
  return _Ticket.fromJson(json);
}

/// @nodoc
mixin _$Ticket {
  String get id => throw _privateConstructorUsedError;
  String get reporterId => throw _privateConstructorUsedError;
  String get lineId => throw _privateConstructorUsedError;
  String get stationId => throw _privateConstructorUsedError;
  String get defectCategoryId => throw _privateConstructorUsedError;
  TicketSeverity get severity => throw _privateConstructorUsedError;
  List<String> get photos => throw _privateConstructorUsedError;
  String? get voiceNoteUrl => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  TicketStatus get status => throw _privateConstructorUsedError;
  String? get assignedOwnerId => throw _privateConstructorUsedError;
  String? get offlineId => throw _privateConstructorUsedError;
  DateTime get createdAt => throw _privateConstructorUsedError;
  DateTime? get acknowledgedAt => throw _privateConstructorUsedError;
  DateTime? get resolvedAt => throw _privateConstructorUsedError;
  DateTime? get closedAt => throw _privateConstructorUsedError;
  String? get rootCause => throw _privateConstructorUsedError;
  String? get correctiveAction => throw _privateConstructorUsedError;
  TicketSyncStatus get syncStatus => throw _privateConstructorUsedError;

  /// Serializes this Ticket to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $TicketCopyWith<Ticket> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $TicketCopyWith<$Res> {
  factory $TicketCopyWith(Ticket value, $Res Function(Ticket) then) =
      _$TicketCopyWithImpl<$Res, Ticket>;
  @useResult
  $Res call({
    String id,
    String reporterId,
    String lineId,
    String stationId,
    String defectCategoryId,
    TicketSeverity severity,
    List<String> photos,
    String? voiceNoteUrl,
    String description,
    TicketStatus status,
    String? assignedOwnerId,
    String? offlineId,
    DateTime createdAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    DateTime? closedAt,
    String? rootCause,
    String? correctiveAction,
    TicketSyncStatus syncStatus,
  });
}

/// @nodoc
class _$TicketCopyWithImpl<$Res, $Val extends Ticket>
    implements $TicketCopyWith<$Res> {
  _$TicketCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? lineId = null,
    Object? stationId = null,
    Object? defectCategoryId = null,
    Object? severity = null,
    Object? photos = null,
    Object? voiceNoteUrl = freezed,
    Object? description = null,
    Object? status = null,
    Object? assignedOwnerId = freezed,
    Object? offlineId = freezed,
    Object? createdAt = null,
    Object? acknowledgedAt = freezed,
    Object? resolvedAt = freezed,
    Object? closedAt = freezed,
    Object? rootCause = freezed,
    Object? correctiveAction = freezed,
    Object? syncStatus = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            reporterId: null == reporterId
                ? _value.reporterId
                : reporterId // ignore: cast_nullable_to_non_nullable
                      as String,
            lineId: null == lineId
                ? _value.lineId
                : lineId // ignore: cast_nullable_to_non_nullable
                      as String,
            stationId: null == stationId
                ? _value.stationId
                : stationId // ignore: cast_nullable_to_non_nullable
                      as String,
            defectCategoryId: null == defectCategoryId
                ? _value.defectCategoryId
                : defectCategoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            severity: null == severity
                ? _value.severity
                : severity // ignore: cast_nullable_to_non_nullable
                      as TicketSeverity,
            photos: null == photos
                ? _value.photos
                : photos // ignore: cast_nullable_to_non_nullable
                      as List<String>,
            voiceNoteUrl: freezed == voiceNoteUrl
                ? _value.voiceNoteUrl
                : voiceNoteUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            description: null == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as TicketStatus,
            assignedOwnerId: freezed == assignedOwnerId
                ? _value.assignedOwnerId
                : assignedOwnerId // ignore: cast_nullable_to_non_nullable
                      as String?,
            offlineId: freezed == offlineId
                ? _value.offlineId
                : offlineId // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            acknowledgedAt: freezed == acknowledgedAt
                ? _value.acknowledgedAt
                : acknowledgedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            resolvedAt: freezed == resolvedAt
                ? _value.resolvedAt
                : resolvedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            closedAt: freezed == closedAt
                ? _value.closedAt
                : closedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            rootCause: freezed == rootCause
                ? _value.rootCause
                : rootCause // ignore: cast_nullable_to_non_nullable
                      as String?,
            correctiveAction: freezed == correctiveAction
                ? _value.correctiveAction
                : correctiveAction // ignore: cast_nullable_to_non_nullable
                      as String?,
            syncStatus: null == syncStatus
                ? _value.syncStatus
                : syncStatus // ignore: cast_nullable_to_non_nullable
                      as TicketSyncStatus,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$TicketImplCopyWith<$Res> implements $TicketCopyWith<$Res> {
  factory _$$TicketImplCopyWith(
    _$TicketImpl value,
    $Res Function(_$TicketImpl) then,
  ) = __$$TicketImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String reporterId,
    String lineId,
    String stationId,
    String defectCategoryId,
    TicketSeverity severity,
    List<String> photos,
    String? voiceNoteUrl,
    String description,
    TicketStatus status,
    String? assignedOwnerId,
    String? offlineId,
    DateTime createdAt,
    DateTime? acknowledgedAt,
    DateTime? resolvedAt,
    DateTime? closedAt,
    String? rootCause,
    String? correctiveAction,
    TicketSyncStatus syncStatus,
  });
}

/// @nodoc
class __$$TicketImplCopyWithImpl<$Res>
    extends _$TicketCopyWithImpl<$Res, _$TicketImpl>
    implements _$$TicketImplCopyWith<$Res> {
  __$$TicketImplCopyWithImpl(
    _$TicketImpl _value,
    $Res Function(_$TicketImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? reporterId = null,
    Object? lineId = null,
    Object? stationId = null,
    Object? defectCategoryId = null,
    Object? severity = null,
    Object? photos = null,
    Object? voiceNoteUrl = freezed,
    Object? description = null,
    Object? status = null,
    Object? assignedOwnerId = freezed,
    Object? offlineId = freezed,
    Object? createdAt = null,
    Object? acknowledgedAt = freezed,
    Object? resolvedAt = freezed,
    Object? closedAt = freezed,
    Object? rootCause = freezed,
    Object? correctiveAction = freezed,
    Object? syncStatus = null,
  }) {
    return _then(
      _$TicketImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        reporterId: null == reporterId
            ? _value.reporterId
            : reporterId // ignore: cast_nullable_to_non_nullable
                  as String,
        lineId: null == lineId
            ? _value.lineId
            : lineId // ignore: cast_nullable_to_non_nullable
                  as String,
        stationId: null == stationId
            ? _value.stationId
            : stationId // ignore: cast_nullable_to_non_nullable
                  as String,
        defectCategoryId: null == defectCategoryId
            ? _value.defectCategoryId
            : defectCategoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        severity: null == severity
            ? _value.severity
            : severity // ignore: cast_nullable_to_non_nullable
                  as TicketSeverity,
        photos: null == photos
            ? _value._photos
            : photos // ignore: cast_nullable_to_non_nullable
                  as List<String>,
        voiceNoteUrl: freezed == voiceNoteUrl
            ? _value.voiceNoteUrl
            : voiceNoteUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        description: null == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as TicketStatus,
        assignedOwnerId: freezed == assignedOwnerId
            ? _value.assignedOwnerId
            : assignedOwnerId // ignore: cast_nullable_to_non_nullable
                  as String?,
        offlineId: freezed == offlineId
            ? _value.offlineId
            : offlineId // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        acknowledgedAt: freezed == acknowledgedAt
            ? _value.acknowledgedAt
            : acknowledgedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        resolvedAt: freezed == resolvedAt
            ? _value.resolvedAt
            : resolvedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        closedAt: freezed == closedAt
            ? _value.closedAt
            : closedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        rootCause: freezed == rootCause
            ? _value.rootCause
            : rootCause // ignore: cast_nullable_to_non_nullable
                  as String?,
        correctiveAction: freezed == correctiveAction
            ? _value.correctiveAction
            : correctiveAction // ignore: cast_nullable_to_non_nullable
                  as String?,
        syncStatus: null == syncStatus
            ? _value.syncStatus
            : syncStatus // ignore: cast_nullable_to_non_nullable
                  as TicketSyncStatus,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$TicketImpl implements _Ticket {
  const _$TicketImpl({
    required this.id,
    required this.reporterId,
    required this.lineId,
    required this.stationId,
    required this.defectCategoryId,
    required this.severity,
    required final List<String> photos,
    this.voiceNoteUrl,
    required this.description,
    required this.status,
    this.assignedOwnerId,
    this.offlineId,
    required this.createdAt,
    this.acknowledgedAt,
    this.resolvedAt,
    this.closedAt,
    this.rootCause,
    this.correctiveAction,
    this.syncStatus = TicketSyncStatus.synced,
  }) : _photos = photos;

  factory _$TicketImpl.fromJson(Map<String, dynamic> json) =>
      _$$TicketImplFromJson(json);

  @override
  final String id;
  @override
  final String reporterId;
  @override
  final String lineId;
  @override
  final String stationId;
  @override
  final String defectCategoryId;
  @override
  final TicketSeverity severity;
  final List<String> _photos;
  @override
  List<String> get photos {
    if (_photos is EqualUnmodifiableListView) return _photos;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_photos);
  }

  @override
  final String? voiceNoteUrl;
  @override
  final String description;
  @override
  final TicketStatus status;
  @override
  final String? assignedOwnerId;
  @override
  final String? offlineId;
  @override
  final DateTime createdAt;
  @override
  final DateTime? acknowledgedAt;
  @override
  final DateTime? resolvedAt;
  @override
  final DateTime? closedAt;
  @override
  final String? rootCause;
  @override
  final String? correctiveAction;
  @override
  @JsonKey()
  final TicketSyncStatus syncStatus;

  @override
  String toString() {
    return 'Ticket(id: $id, reporterId: $reporterId, lineId: $lineId, stationId: $stationId, defectCategoryId: $defectCategoryId, severity: $severity, photos: $photos, voiceNoteUrl: $voiceNoteUrl, description: $description, status: $status, assignedOwnerId: $assignedOwnerId, offlineId: $offlineId, createdAt: $createdAt, acknowledgedAt: $acknowledgedAt, resolvedAt: $resolvedAt, closedAt: $closedAt, rootCause: $rootCause, correctiveAction: $correctiveAction, syncStatus: $syncStatus)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$TicketImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.reporterId, reporterId) ||
                other.reporterId == reporterId) &&
            (identical(other.lineId, lineId) || other.lineId == lineId) &&
            (identical(other.stationId, stationId) ||
                other.stationId == stationId) &&
            (identical(other.defectCategoryId, defectCategoryId) ||
                other.defectCategoryId == defectCategoryId) &&
            (identical(other.severity, severity) ||
                other.severity == severity) &&
            const DeepCollectionEquality().equals(other._photos, _photos) &&
            (identical(other.voiceNoteUrl, voiceNoteUrl) ||
                other.voiceNoteUrl == voiceNoteUrl) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.assignedOwnerId, assignedOwnerId) ||
                other.assignedOwnerId == assignedOwnerId) &&
            (identical(other.offlineId, offlineId) ||
                other.offlineId == offlineId) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.acknowledgedAt, acknowledgedAt) ||
                other.acknowledgedAt == acknowledgedAt) &&
            (identical(other.resolvedAt, resolvedAt) ||
                other.resolvedAt == resolvedAt) &&
            (identical(other.closedAt, closedAt) ||
                other.closedAt == closedAt) &&
            (identical(other.rootCause, rootCause) ||
                other.rootCause == rootCause) &&
            (identical(other.correctiveAction, correctiveAction) ||
                other.correctiveAction == correctiveAction) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hashAll([
    runtimeType,
    id,
    reporterId,
    lineId,
    stationId,
    defectCategoryId,
    severity,
    const DeepCollectionEquality().hash(_photos),
    voiceNoteUrl,
    description,
    status,
    assignedOwnerId,
    offlineId,
    createdAt,
    acknowledgedAt,
    resolvedAt,
    closedAt,
    rootCause,
    correctiveAction,
    syncStatus,
  ]);

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$TicketImplCopyWith<_$TicketImpl> get copyWith =>
      __$$TicketImplCopyWithImpl<_$TicketImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$TicketImplToJson(this);
  }
}

abstract class _Ticket implements Ticket {
  const factory _Ticket({
    required final String id,
    required final String reporterId,
    required final String lineId,
    required final String stationId,
    required final String defectCategoryId,
    required final TicketSeverity severity,
    required final List<String> photos,
    final String? voiceNoteUrl,
    required final String description,
    required final TicketStatus status,
    final String? assignedOwnerId,
    final String? offlineId,
    required final DateTime createdAt,
    final DateTime? acknowledgedAt,
    final DateTime? resolvedAt,
    final DateTime? closedAt,
    final String? rootCause,
    final String? correctiveAction,
    final TicketSyncStatus syncStatus,
  }) = _$TicketImpl;

  factory _Ticket.fromJson(Map<String, dynamic> json) = _$TicketImpl.fromJson;

  @override
  String get id;
  @override
  String get reporterId;
  @override
  String get lineId;
  @override
  String get stationId;
  @override
  String get defectCategoryId;
  @override
  TicketSeverity get severity;
  @override
  List<String> get photos;
  @override
  String? get voiceNoteUrl;
  @override
  String get description;
  @override
  TicketStatus get status;
  @override
  String? get assignedOwnerId;
  @override
  String? get offlineId;
  @override
  DateTime get createdAt;
  @override
  DateTime? get acknowledgedAt;
  @override
  DateTime? get resolvedAt;
  @override
  DateTime? get closedAt;
  @override
  String? get rootCause;
  @override
  String? get correctiveAction;
  @override
  TicketSyncStatus get syncStatus;

  /// Create a copy of Ticket
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$TicketImplCopyWith<_$TicketImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

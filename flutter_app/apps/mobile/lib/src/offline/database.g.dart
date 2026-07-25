// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $OfflineTicketsTable extends OfflineTickets
    with TableInfo<$OfflineTicketsTable, OfflineTicket> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineTicketsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _humanReadableIdMeta = const VerificationMeta(
    'humanReadableId',
  );
  @override
  late final GeneratedColumn<String> humanReadableId = GeneratedColumn<String>(
    'human_readable_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _reporterIdMeta = const VerificationMeta(
    'reporterId',
  );
  @override
  late final GeneratedColumn<String> reporterId = GeneratedColumn<String>(
    'reporter_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
    'line_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stationIdMeta = const VerificationMeta(
    'stationId',
  );
  @override
  late final GeneratedColumn<String> stationId = GeneratedColumn<String>(
    'station_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _defectCategoryIdMeta = const VerificationMeta(
    'defectCategoryId',
  );
  @override
  late final GeneratedColumn<String> defectCategoryId = GeneratedColumn<String>(
    'defect_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _severityMeta = const VerificationMeta(
    'severity',
  );
  @override
  late final GeneratedColumn<String> severity = GeneratedColumn<String>(
    'severity',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> photoPaths =
      GeneratedColumn<String>(
        'photo_paths',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      ).withConverter<List<String>>($OfflineTicketsTable.$converterphotoPaths);
  static const VerificationMeta _voiceNotePathMeta = const VerificationMeta(
    'voiceNotePath',
  );
  @override
  late final GeneratedColumn<String> voiceNotePath = GeneratedColumn<String>(
    'voice_note_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
    'status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('open'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<String> syncStatus = GeneratedColumn<String>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('pending_sync'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    humanReadableId,
    reporterId,
    lineId,
    stationId,
    defectCategoryId,
    severity,
    photoPaths,
    voiceNotePath,
    description,
    status,
    createdAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_tickets';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineTicket> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('human_readable_id')) {
      context.handle(
        _humanReadableIdMeta,
        humanReadableId.isAcceptableOrUnknown(
          data['human_readable_id']!,
          _humanReadableIdMeta,
        ),
      );
    }
    if (data.containsKey('reporter_id')) {
      context.handle(
        _reporterIdMeta,
        reporterId.isAcceptableOrUnknown(data['reporter_id']!, _reporterIdMeta),
      );
    } else if (isInserting) {
      context.missing(_reporterIdMeta);
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('station_id')) {
      context.handle(
        _stationIdMeta,
        stationId.isAcceptableOrUnknown(data['station_id']!, _stationIdMeta),
      );
    } else if (isInserting) {
      context.missing(_stationIdMeta);
    }
    if (data.containsKey('defect_category_id')) {
      context.handle(
        _defectCategoryIdMeta,
        defectCategoryId.isAcceptableOrUnknown(
          data['defect_category_id']!,
          _defectCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_defectCategoryIdMeta);
    }
    if (data.containsKey('severity')) {
      context.handle(
        _severityMeta,
        severity.isAcceptableOrUnknown(data['severity']!, _severityMeta),
      );
    } else if (isInserting) {
      context.missing(_severityMeta);
    }
    if (data.containsKey('voice_note_path')) {
      context.handle(
        _voiceNotePathMeta,
        voiceNotePath.isAcceptableOrUnknown(
          data['voice_note_path']!,
          _voiceNotePathMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('status')) {
      context.handle(
        _statusMeta,
        status.isAcceptableOrUnknown(data['status']!, _statusMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineTicket map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineTicket(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      humanReadableId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}human_readable_id'],
      ),
      reporterId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reporter_id'],
      )!,
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_id'],
      )!,
      stationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}station_id'],
      )!,
      defectCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}defect_category_id'],
      )!,
      severity: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}severity'],
      )!,
      photoPaths: $OfflineTicketsTable.$converterphotoPaths.fromSql(
        attachedDatabase.typeMapping.read(
          DriftSqlType.string,
          data['${effectivePrefix}photo_paths'],
        )!,
      ),
      voiceNotePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}voice_note_path'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      status: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}status'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $OfflineTicketsTable createAlias(String alias) {
    return $OfflineTicketsTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $converterphotoPaths =
      const StringListConverter();
}

class OfflineTicket extends DataClass implements Insertable<OfflineTicket> {
  final String id;
  final String? humanReadableId;
  final String reporterId;
  final String lineId;
  final String stationId;
  final String defectCategoryId;
  final String severity;
  final List<String> photoPaths;
  final String? voiceNotePath;
  final String description;
  final String status;
  final DateTime createdAt;
  final String syncStatus;
  const OfflineTicket({
    required this.id,
    this.humanReadableId,
    required this.reporterId,
    required this.lineId,
    required this.stationId,
    required this.defectCategoryId,
    required this.severity,
    required this.photoPaths,
    this.voiceNotePath,
    required this.description,
    required this.status,
    required this.createdAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    if (!nullToAbsent || humanReadableId != null) {
      map['human_readable_id'] = Variable<String>(humanReadableId);
    }
    map['reporter_id'] = Variable<String>(reporterId);
    map['line_id'] = Variable<String>(lineId);
    map['station_id'] = Variable<String>(stationId);
    map['defect_category_id'] = Variable<String>(defectCategoryId);
    map['severity'] = Variable<String>(severity);
    {
      map['photo_paths'] = Variable<String>(
        $OfflineTicketsTable.$converterphotoPaths.toSql(photoPaths),
      );
    }
    if (!nullToAbsent || voiceNotePath != null) {
      map['voice_note_path'] = Variable<String>(voiceNotePath);
    }
    map['description'] = Variable<String>(description);
    map['status'] = Variable<String>(status);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['sync_status'] = Variable<String>(syncStatus);
    return map;
  }

  OfflineTicketsCompanion toCompanion(bool nullToAbsent) {
    return OfflineTicketsCompanion(
      id: Value(id),
      humanReadableId: humanReadableId == null && nullToAbsent
          ? const Value.absent()
          : Value(humanReadableId),
      reporterId: Value(reporterId),
      lineId: Value(lineId),
      stationId: Value(stationId),
      defectCategoryId: Value(defectCategoryId),
      severity: Value(severity),
      photoPaths: Value(photoPaths),
      voiceNotePath: voiceNotePath == null && nullToAbsent
          ? const Value.absent()
          : Value(voiceNotePath),
      description: Value(description),
      status: Value(status),
      createdAt: Value(createdAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory OfflineTicket.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineTicket(
      id: serializer.fromJson<String>(json['id']),
      humanReadableId: serializer.fromJson<String?>(json['humanReadableId']),
      reporterId: serializer.fromJson<String>(json['reporterId']),
      lineId: serializer.fromJson<String>(json['lineId']),
      stationId: serializer.fromJson<String>(json['stationId']),
      defectCategoryId: serializer.fromJson<String>(json['defectCategoryId']),
      severity: serializer.fromJson<String>(json['severity']),
      photoPaths: serializer.fromJson<List<String>>(json['photoPaths']),
      voiceNotePath: serializer.fromJson<String?>(json['voiceNotePath']),
      description: serializer.fromJson<String>(json['description']),
      status: serializer.fromJson<String>(json['status']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      syncStatus: serializer.fromJson<String>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'humanReadableId': serializer.toJson<String?>(humanReadableId),
      'reporterId': serializer.toJson<String>(reporterId),
      'lineId': serializer.toJson<String>(lineId),
      'stationId': serializer.toJson<String>(stationId),
      'defectCategoryId': serializer.toJson<String>(defectCategoryId),
      'severity': serializer.toJson<String>(severity),
      'photoPaths': serializer.toJson<List<String>>(photoPaths),
      'voiceNotePath': serializer.toJson<String?>(voiceNotePath),
      'description': serializer.toJson<String>(description),
      'status': serializer.toJson<String>(status),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'syncStatus': serializer.toJson<String>(syncStatus),
    };
  }

  OfflineTicket copyWith({
    String? id,
    Value<String?> humanReadableId = const Value.absent(),
    String? reporterId,
    String? lineId,
    String? stationId,
    String? defectCategoryId,
    String? severity,
    List<String>? photoPaths,
    Value<String?> voiceNotePath = const Value.absent(),
    String? description,
    String? status,
    DateTime? createdAt,
    String? syncStatus,
  }) => OfflineTicket(
    id: id ?? this.id,
    humanReadableId: humanReadableId.present
        ? humanReadableId.value
        : this.humanReadableId,
    reporterId: reporterId ?? this.reporterId,
    lineId: lineId ?? this.lineId,
    stationId: stationId ?? this.stationId,
    defectCategoryId: defectCategoryId ?? this.defectCategoryId,
    severity: severity ?? this.severity,
    photoPaths: photoPaths ?? this.photoPaths,
    voiceNotePath: voiceNotePath.present
        ? voiceNotePath.value
        : this.voiceNotePath,
    description: description ?? this.description,
    status: status ?? this.status,
    createdAt: createdAt ?? this.createdAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  OfflineTicket copyWithCompanion(OfflineTicketsCompanion data) {
    return OfflineTicket(
      id: data.id.present ? data.id.value : this.id,
      humanReadableId: data.humanReadableId.present
          ? data.humanReadableId.value
          : this.humanReadableId,
      reporterId: data.reporterId.present
          ? data.reporterId.value
          : this.reporterId,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      stationId: data.stationId.present ? data.stationId.value : this.stationId,
      defectCategoryId: data.defectCategoryId.present
          ? data.defectCategoryId.value
          : this.defectCategoryId,
      severity: data.severity.present ? data.severity.value : this.severity,
      photoPaths: data.photoPaths.present
          ? data.photoPaths.value
          : this.photoPaths,
      voiceNotePath: data.voiceNotePath.present
          ? data.voiceNotePath.value
          : this.voiceNotePath,
      description: data.description.present
          ? data.description.value
          : this.description,
      status: data.status.present ? data.status.value : this.status,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineTicket(')
          ..write('id: $id, ')
          ..write('humanReadableId: $humanReadableId, ')
          ..write('reporterId: $reporterId, ')
          ..write('lineId: $lineId, ')
          ..write('stationId: $stationId, ')
          ..write('defectCategoryId: $defectCategoryId, ')
          ..write('severity: $severity, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    humanReadableId,
    reporterId,
    lineId,
    stationId,
    defectCategoryId,
    severity,
    photoPaths,
    voiceNotePath,
    description,
    status,
    createdAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineTicket &&
          other.id == this.id &&
          other.humanReadableId == this.humanReadableId &&
          other.reporterId == this.reporterId &&
          other.lineId == this.lineId &&
          other.stationId == this.stationId &&
          other.defectCategoryId == this.defectCategoryId &&
          other.severity == this.severity &&
          other.photoPaths == this.photoPaths &&
          other.voiceNotePath == this.voiceNotePath &&
          other.description == this.description &&
          other.status == this.status &&
          other.createdAt == this.createdAt &&
          other.syncStatus == this.syncStatus);
}

class OfflineTicketsCompanion extends UpdateCompanion<OfflineTicket> {
  final Value<String> id;
  final Value<String?> humanReadableId;
  final Value<String> reporterId;
  final Value<String> lineId;
  final Value<String> stationId;
  final Value<String> defectCategoryId;
  final Value<String> severity;
  final Value<List<String>> photoPaths;
  final Value<String?> voiceNotePath;
  final Value<String> description;
  final Value<String> status;
  final Value<DateTime> createdAt;
  final Value<String> syncStatus;
  final Value<int> rowid;
  const OfflineTicketsCompanion({
    this.id = const Value.absent(),
    this.humanReadableId = const Value.absent(),
    this.reporterId = const Value.absent(),
    this.lineId = const Value.absent(),
    this.stationId = const Value.absent(),
    this.defectCategoryId = const Value.absent(),
    this.severity = const Value.absent(),
    this.photoPaths = const Value.absent(),
    this.voiceNotePath = const Value.absent(),
    this.description = const Value.absent(),
    this.status = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineTicketsCompanion.insert({
    required String id,
    this.humanReadableId = const Value.absent(),
    required String reporterId,
    required String lineId,
    required String stationId,
    required String defectCategoryId,
    required String severity,
    required List<String> photoPaths,
    this.voiceNotePath = const Value.absent(),
    required String description,
    this.status = const Value.absent(),
    required DateTime createdAt,
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       reporterId = Value(reporterId),
       lineId = Value(lineId),
       stationId = Value(stationId),
       defectCategoryId = Value(defectCategoryId),
       severity = Value(severity),
       photoPaths = Value(photoPaths),
       description = Value(description),
       createdAt = Value(createdAt);
  static Insertable<OfflineTicket> custom({
    Expression<String>? id,
    Expression<String>? humanReadableId,
    Expression<String>? reporterId,
    Expression<String>? lineId,
    Expression<String>? stationId,
    Expression<String>? defectCategoryId,
    Expression<String>? severity,
    Expression<String>? photoPaths,
    Expression<String>? voiceNotePath,
    Expression<String>? description,
    Expression<String>? status,
    Expression<DateTime>? createdAt,
    Expression<String>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (humanReadableId != null) 'human_readable_id': humanReadableId,
      if (reporterId != null) 'reporter_id': reporterId,
      if (lineId != null) 'line_id': lineId,
      if (stationId != null) 'station_id': stationId,
      if (defectCategoryId != null) 'defect_category_id': defectCategoryId,
      if (severity != null) 'severity': severity,
      if (photoPaths != null) 'photo_paths': photoPaths,
      if (voiceNotePath != null) 'voice_note_path': voiceNotePath,
      if (description != null) 'description': description,
      if (status != null) 'status': status,
      if (createdAt != null) 'created_at': createdAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineTicketsCompanion copyWith({
    Value<String>? id,
    Value<String?>? humanReadableId,
    Value<String>? reporterId,
    Value<String>? lineId,
    Value<String>? stationId,
    Value<String>? defectCategoryId,
    Value<String>? severity,
    Value<List<String>>? photoPaths,
    Value<String?>? voiceNotePath,
    Value<String>? description,
    Value<String>? status,
    Value<DateTime>? createdAt,
    Value<String>? syncStatus,
    Value<int>? rowid,
  }) {
    return OfflineTicketsCompanion(
      id: id ?? this.id,
      humanReadableId: humanReadableId ?? this.humanReadableId,
      reporterId: reporterId ?? this.reporterId,
      lineId: lineId ?? this.lineId,
      stationId: stationId ?? this.stationId,
      defectCategoryId: defectCategoryId ?? this.defectCategoryId,
      severity: severity ?? this.severity,
      photoPaths: photoPaths ?? this.photoPaths,
      voiceNotePath: voiceNotePath ?? this.voiceNotePath,
      description: description ?? this.description,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (humanReadableId.present) {
      map['human_readable_id'] = Variable<String>(humanReadableId.value);
    }
    if (reporterId.present) {
      map['reporter_id'] = Variable<String>(reporterId.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (stationId.present) {
      map['station_id'] = Variable<String>(stationId.value);
    }
    if (defectCategoryId.present) {
      map['defect_category_id'] = Variable<String>(defectCategoryId.value);
    }
    if (severity.present) {
      map['severity'] = Variable<String>(severity.value);
    }
    if (photoPaths.present) {
      map['photo_paths'] = Variable<String>(
        $OfflineTicketsTable.$converterphotoPaths.toSql(photoPaths.value),
      );
    }
    if (voiceNotePath.present) {
      map['voice_note_path'] = Variable<String>(voiceNotePath.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<String>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineTicketsCompanion(')
          ..write('id: $id, ')
          ..write('humanReadableId: $humanReadableId, ')
          ..write('reporterId: $reporterId, ')
          ..write('lineId: $lineId, ')
          ..write('stationId: $stationId, ')
          ..write('defectCategoryId: $defectCategoryId, ')
          ..write('severity: $severity, ')
          ..write('photoPaths: $photoPaths, ')
          ..write('voiceNotePath: $voiceNotePath, ')
          ..write('description: $description, ')
          ..write('status: $status, ')
          ..write('createdAt: $createdAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflinePlantsTable extends OfflinePlants
    with TableInfo<$OfflinePlantsTable, OfflinePlant> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflinePlantsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _locationMeta = const VerificationMeta(
    'location',
  );
  @override
  late final GeneratedColumn<String> location = GeneratedColumn<String>(
    'location',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, location, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_plants';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflinePlant> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('location')) {
      context.handle(
        _locationMeta,
        location.isAcceptableOrUnknown(data['location']!, _locationMeta),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflinePlant map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflinePlant(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      location: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}location'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $OfflinePlantsTable createAlias(String alias) {
    return $OfflinePlantsTable(attachedDatabase, alias);
  }
}

class OfflinePlant extends DataClass implements Insertable<OfflinePlant> {
  final String id;
  final String name;
  final String? location;
  final bool active;
  const OfflinePlant({
    required this.id,
    required this.name,
    this.location,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || location != null) {
      map['location'] = Variable<String>(location);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  OfflinePlantsCompanion toCompanion(bool nullToAbsent) {
    return OfflinePlantsCompanion(
      id: Value(id),
      name: Value(name),
      location: location == null && nullToAbsent
          ? const Value.absent()
          : Value(location),
      active: Value(active),
    );
  }

  factory OfflinePlant.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflinePlant(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      location: serializer.fromJson<String?>(json['location']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'location': serializer.toJson<String?>(location),
      'active': serializer.toJson<bool>(active),
    };
  }

  OfflinePlant copyWith({
    String? id,
    String? name,
    Value<String?> location = const Value.absent(),
    bool? active,
  }) => OfflinePlant(
    id: id ?? this.id,
    name: name ?? this.name,
    location: location.present ? location.value : this.location,
    active: active ?? this.active,
  );
  OfflinePlant copyWithCompanion(OfflinePlantsCompanion data) {
    return OfflinePlant(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      location: data.location.present ? data.location.value : this.location,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflinePlant(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, location, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflinePlant &&
          other.id == this.id &&
          other.name == this.name &&
          other.location == this.location &&
          other.active == this.active);
}

class OfflinePlantsCompanion extends UpdateCompanion<OfflinePlant> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> location;
  final Value<bool> active;
  final Value<int> rowid;
  const OfflinePlantsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.location = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflinePlantsCompanion.insert({
    required String id,
    required String name,
    this.location = const Value.absent(),
    required bool active,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       active = Value(active);
  static Insertable<OfflinePlant> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? location,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (location != null) 'location': location,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflinePlantsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? location,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return OfflinePlantsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      location: location ?? this.location,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (location.present) {
      map['location'] = Variable<String>(location.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflinePlantsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('location: $location, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineLinesTable extends OfflineLines
    with TableInfo<$OfflineLinesTable, OfflineLine> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineLinesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _plantIdMeta = const VerificationMeta(
    'plantId',
  );
  @override
  late final GeneratedColumn<String> plantId = GeneratedColumn<String>(
    'plant_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, plantId, name, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_lines';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineLine> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('plant_id')) {
      context.handle(
        _plantIdMeta,
        plantId.isAcceptableOrUnknown(data['plant_id']!, _plantIdMeta),
      );
    } else if (isInserting) {
      context.missing(_plantIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineLine map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineLine(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      plantId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}plant_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $OfflineLinesTable createAlias(String alias) {
    return $OfflineLinesTable(attachedDatabase, alias);
  }
}

class OfflineLine extends DataClass implements Insertable<OfflineLine> {
  final String id;
  final String plantId;
  final String name;
  final bool active;
  const OfflineLine({
    required this.id,
    required this.plantId,
    required this.name,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['plant_id'] = Variable<String>(plantId);
    map['name'] = Variable<String>(name);
    map['active'] = Variable<bool>(active);
    return map;
  }

  OfflineLinesCompanion toCompanion(bool nullToAbsent) {
    return OfflineLinesCompanion(
      id: Value(id),
      plantId: Value(plantId),
      name: Value(name),
      active: Value(active),
    );
  }

  factory OfflineLine.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineLine(
      id: serializer.fromJson<String>(json['id']),
      plantId: serializer.fromJson<String>(json['plantId']),
      name: serializer.fromJson<String>(json['name']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'plantId': serializer.toJson<String>(plantId),
      'name': serializer.toJson<String>(name),
      'active': serializer.toJson<bool>(active),
    };
  }

  OfflineLine copyWith({
    String? id,
    String? plantId,
    String? name,
    bool? active,
  }) => OfflineLine(
    id: id ?? this.id,
    plantId: plantId ?? this.plantId,
    name: name ?? this.name,
    active: active ?? this.active,
  );
  OfflineLine copyWithCompanion(OfflineLinesCompanion data) {
    return OfflineLine(
      id: data.id.present ? data.id.value : this.id,
      plantId: data.plantId.present ? data.plantId.value : this.plantId,
      name: data.name.present ? data.name.value : this.name,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineLine(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('name: $name, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, plantId, name, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineLine &&
          other.id == this.id &&
          other.plantId == this.plantId &&
          other.name == this.name &&
          other.active == this.active);
}

class OfflineLinesCompanion extends UpdateCompanion<OfflineLine> {
  final Value<String> id;
  final Value<String> plantId;
  final Value<String> name;
  final Value<bool> active;
  final Value<int> rowid;
  const OfflineLinesCompanion({
    this.id = const Value.absent(),
    this.plantId = const Value.absent(),
    this.name = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineLinesCompanion.insert({
    required String id,
    required String plantId,
    required String name,
    required bool active,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       plantId = Value(plantId),
       name = Value(name),
       active = Value(active);
  static Insertable<OfflineLine> custom({
    Expression<String>? id,
    Expression<String>? plantId,
    Expression<String>? name,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (plantId != null) 'plant_id': plantId,
      if (name != null) 'name': name,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineLinesCompanion copyWith({
    Value<String>? id,
    Value<String>? plantId,
    Value<String>? name,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return OfflineLinesCompanion(
      id: id ?? this.id,
      plantId: plantId ?? this.plantId,
      name: name ?? this.name,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (plantId.present) {
      map['plant_id'] = Variable<String>(plantId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineLinesCompanion(')
          ..write('id: $id, ')
          ..write('plantId: $plantId, ')
          ..write('name: $name, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineStationsTable extends OfflineStations
    with TableInfo<$OfflineStationsTable, OfflineStation> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineStationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lineIdMeta = const VerificationMeta('lineId');
  @override
  late final GeneratedColumn<String> lineId = GeneratedColumn<String>(
    'line_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, lineId, name, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_stations';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineStation> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('line_id')) {
      context.handle(
        _lineIdMeta,
        lineId.isAcceptableOrUnknown(data['line_id']!, _lineIdMeta),
      );
    } else if (isInserting) {
      context.missing(_lineIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineStation map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineStation(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      lineId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}line_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $OfflineStationsTable createAlias(String alias) {
    return $OfflineStationsTable(attachedDatabase, alias);
  }
}

class OfflineStation extends DataClass implements Insertable<OfflineStation> {
  final String id;
  final String lineId;
  final String name;
  final bool active;
  const OfflineStation({
    required this.id,
    required this.lineId,
    required this.name,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['line_id'] = Variable<String>(lineId);
    map['name'] = Variable<String>(name);
    map['active'] = Variable<bool>(active);
    return map;
  }

  OfflineStationsCompanion toCompanion(bool nullToAbsent) {
    return OfflineStationsCompanion(
      id: Value(id),
      lineId: Value(lineId),
      name: Value(name),
      active: Value(active),
    );
  }

  factory OfflineStation.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineStation(
      id: serializer.fromJson<String>(json['id']),
      lineId: serializer.fromJson<String>(json['lineId']),
      name: serializer.fromJson<String>(json['name']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'lineId': serializer.toJson<String>(lineId),
      'name': serializer.toJson<String>(name),
      'active': serializer.toJson<bool>(active),
    };
  }

  OfflineStation copyWith({
    String? id,
    String? lineId,
    String? name,
    bool? active,
  }) => OfflineStation(
    id: id ?? this.id,
    lineId: lineId ?? this.lineId,
    name: name ?? this.name,
    active: active ?? this.active,
  );
  OfflineStation copyWithCompanion(OfflineStationsCompanion data) {
    return OfflineStation(
      id: data.id.present ? data.id.value : this.id,
      lineId: data.lineId.present ? data.lineId.value : this.lineId,
      name: data.name.present ? data.name.value : this.name,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineStation(')
          ..write('id: $id, ')
          ..write('lineId: $lineId, ')
          ..write('name: $name, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, lineId, name, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineStation &&
          other.id == this.id &&
          other.lineId == this.lineId &&
          other.name == this.name &&
          other.active == this.active);
}

class OfflineStationsCompanion extends UpdateCompanion<OfflineStation> {
  final Value<String> id;
  final Value<String> lineId;
  final Value<String> name;
  final Value<bool> active;
  final Value<int> rowid;
  const OfflineStationsCompanion({
    this.id = const Value.absent(),
    this.lineId = const Value.absent(),
    this.name = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineStationsCompanion.insert({
    required String id,
    required String lineId,
    required String name,
    required bool active,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       lineId = Value(lineId),
       name = Value(name),
       active = Value(active);
  static Insertable<OfflineStation> custom({
    Expression<String>? id,
    Expression<String>? lineId,
    Expression<String>? name,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (lineId != null) 'line_id': lineId,
      if (name != null) 'name': name,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineStationsCompanion copyWith({
    Value<String>? id,
    Value<String>? lineId,
    Value<String>? name,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return OfflineStationsCompanion(
      id: id ?? this.id,
      lineId: lineId ?? this.lineId,
      name: name ?? this.name,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (lineId.present) {
      map['line_id'] = Variable<String>(lineId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineStationsCompanion(')
          ..write('id: $id, ')
          ..write('lineId: $lineId, ')
          ..write('name: $name, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $OfflineDefectCategoriesTable extends OfflineDefectCategories
    with TableInfo<$OfflineDefectCategoriesTable, OfflineDefectCategory> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OfflineDefectCategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, active];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'offline_defect_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<OfflineDefectCategory> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    } else if (isInserting) {
      context.missing(_activeMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OfflineDefectCategory map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OfflineDefectCategory(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
    );
  }

  @override
  $OfflineDefectCategoriesTable createAlias(String alias) {
    return $OfflineDefectCategoriesTable(attachedDatabase, alias);
  }
}

class OfflineDefectCategory extends DataClass
    implements Insertable<OfflineDefectCategory> {
  final String id;
  final String name;
  final String? description;
  final bool active;
  const OfflineDefectCategory({
    required this.id,
    required this.name,
    this.description,
    required this.active,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['active'] = Variable<bool>(active);
    return map;
  }

  OfflineDefectCategoriesCompanion toCompanion(bool nullToAbsent) {
    return OfflineDefectCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      active: Value(active),
    );
  }

  factory OfflineDefectCategory.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OfflineDefectCategory(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      active: serializer.fromJson<bool>(json['active']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'active': serializer.toJson<bool>(active),
    };
  }

  OfflineDefectCategory copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    bool? active,
  }) => OfflineDefectCategory(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    active: active ?? this.active,
  );
  OfflineDefectCategory copyWithCompanion(
    OfflineDefectCategoriesCompanion data,
  ) {
    return OfflineDefectCategory(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      active: data.active.present ? data.active.value : this.active,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OfflineDefectCategory(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, active);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OfflineDefectCategory &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.active == this.active);
}

class OfflineDefectCategoriesCompanion
    extends UpdateCompanion<OfflineDefectCategory> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<bool> active;
  final Value<int> rowid;
  const OfflineDefectCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.active = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OfflineDefectCategoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    required bool active,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       active = Value(active);
  static Insertable<OfflineDefectCategory> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<bool>? active,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (active != null) 'active': active,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OfflineDefectCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<bool>? active,
    Value<int>? rowid,
  }) {
    return OfflineDefectCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      active: active ?? this.active,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OfflineDefectCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('active: $active, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $OfflineTicketsTable offlineTickets = $OfflineTicketsTable(this);
  late final $OfflinePlantsTable offlinePlants = $OfflinePlantsTable(this);
  late final $OfflineLinesTable offlineLines = $OfflineLinesTable(this);
  late final $OfflineStationsTable offlineStations = $OfflineStationsTable(
    this,
  );
  late final $OfflineDefectCategoriesTable offlineDefectCategories =
      $OfflineDefectCategoriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    offlineTickets,
    offlinePlants,
    offlineLines,
    offlineStations,
    offlineDefectCategories,
  ];
}

typedef $$OfflineTicketsTableCreateCompanionBuilder =
    OfflineTicketsCompanion Function({
      required String id,
      Value<String?> humanReadableId,
      required String reporterId,
      required String lineId,
      required String stationId,
      required String defectCategoryId,
      required String severity,
      required List<String> photoPaths,
      Value<String?> voiceNotePath,
      required String description,
      Value<String> status,
      required DateTime createdAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });
typedef $$OfflineTicketsTableUpdateCompanionBuilder =
    OfflineTicketsCompanion Function({
      Value<String> id,
      Value<String?> humanReadableId,
      Value<String> reporterId,
      Value<String> lineId,
      Value<String> stationId,
      Value<String> defectCategoryId,
      Value<String> severity,
      Value<List<String>> photoPaths,
      Value<String?> voiceNotePath,
      Value<String> description,
      Value<String> status,
      Value<DateTime> createdAt,
      Value<String> syncStatus,
      Value<int> rowid,
    });

class $$OfflineTicketsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineTicketsTable> {
  $$OfflineTicketsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get humanReadableId => $composableBuilder(
    column: $table.humanReadableId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reporterId => $composableBuilder(
    column: $table.reporterId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get defectCategoryId => $composableBuilder(
    column: $table.defectCategoryId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
  get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnWithTypeConverterFilters(column),
  );

  ColumnFilters<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineTicketsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineTicketsTable> {
  $$OfflineTicketsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get humanReadableId => $composableBuilder(
    column: $table.humanReadableId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reporterId => $composableBuilder(
    column: $table.reporterId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get stationId => $composableBuilder(
    column: $table.stationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get defectCategoryId => $composableBuilder(
    column: $table.defectCategoryId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get severity => $composableBuilder(
    column: $table.severity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPaths => $composableBuilder(
    column: $table.photoPaths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get status => $composableBuilder(
    column: $table.status,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineTicketsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineTicketsTable> {
  $$OfflineTicketsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get humanReadableId => $composableBuilder(
    column: $table.humanReadableId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reporterId => $composableBuilder(
    column: $table.reporterId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lineId =>
      $composableBuilder(column: $table.lineId, builder: (column) => column);

  GeneratedColumn<String> get stationId =>
      $composableBuilder(column: $table.stationId, builder: (column) => column);

  GeneratedColumn<String> get defectCategoryId => $composableBuilder(
    column: $table.defectCategoryId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get severity =>
      $composableBuilder(column: $table.severity, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get photoPaths =>
      $composableBuilder(
        column: $table.photoPaths,
        builder: (column) => column,
      );

  GeneratedColumn<String> get voiceNotePath => $composableBuilder(
    column: $table.voiceNotePath,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<String> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$OfflineTicketsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineTicketsTable,
          OfflineTicket,
          $$OfflineTicketsTableFilterComposer,
          $$OfflineTicketsTableOrderingComposer,
          $$OfflineTicketsTableAnnotationComposer,
          $$OfflineTicketsTableCreateCompanionBuilder,
          $$OfflineTicketsTableUpdateCompanionBuilder,
          (
            OfflineTicket,
            BaseReferences<_$AppDatabase, $OfflineTicketsTable, OfflineTicket>,
          ),
          OfflineTicket,
          PrefetchHooks Function()
        > {
  $$OfflineTicketsTableTableManager(
    _$AppDatabase db,
    $OfflineTicketsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineTicketsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineTicketsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineTicketsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String?> humanReadableId = const Value.absent(),
                Value<String> reporterId = const Value.absent(),
                Value<String> lineId = const Value.absent(),
                Value<String> stationId = const Value.absent(),
                Value<String> defectCategoryId = const Value.absent(),
                Value<String> severity = const Value.absent(),
                Value<List<String>> photoPaths = const Value.absent(),
                Value<String?> voiceNotePath = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> status = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineTicketsCompanion(
                id: id,
                humanReadableId: humanReadableId,
                reporterId: reporterId,
                lineId: lineId,
                stationId: stationId,
                defectCategoryId: defectCategoryId,
                severity: severity,
                photoPaths: photoPaths,
                voiceNotePath: voiceNotePath,
                description: description,
                status: status,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String?> humanReadableId = const Value.absent(),
                required String reporterId,
                required String lineId,
                required String stationId,
                required String defectCategoryId,
                required String severity,
                required List<String> photoPaths,
                Value<String?> voiceNotePath = const Value.absent(),
                required String description,
                Value<String> status = const Value.absent(),
                required DateTime createdAt,
                Value<String> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineTicketsCompanion.insert(
                id: id,
                humanReadableId: humanReadableId,
                reporterId: reporterId,
                lineId: lineId,
                stationId: stationId,
                defectCategoryId: defectCategoryId,
                severity: severity,
                photoPaths: photoPaths,
                voiceNotePath: voiceNotePath,
                description: description,
                status: status,
                createdAt: createdAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineTicketsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineTicketsTable,
      OfflineTicket,
      $$OfflineTicketsTableFilterComposer,
      $$OfflineTicketsTableOrderingComposer,
      $$OfflineTicketsTableAnnotationComposer,
      $$OfflineTicketsTableCreateCompanionBuilder,
      $$OfflineTicketsTableUpdateCompanionBuilder,
      (
        OfflineTicket,
        BaseReferences<_$AppDatabase, $OfflineTicketsTable, OfflineTicket>,
      ),
      OfflineTicket,
      PrefetchHooks Function()
    >;
typedef $$OfflinePlantsTableCreateCompanionBuilder =
    OfflinePlantsCompanion Function({
      required String id,
      required String name,
      Value<String?> location,
      required bool active,
      Value<int> rowid,
    });
typedef $$OfflinePlantsTableUpdateCompanionBuilder =
    OfflinePlantsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> location,
      Value<bool> active,
      Value<int> rowid,
    });

class $$OfflinePlantsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflinePlantsTable> {
  $$OfflinePlantsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflinePlantsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflinePlantsTable> {
  $$OfflinePlantsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get location => $composableBuilder(
    column: $table.location,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflinePlantsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflinePlantsTable> {
  $$OfflinePlantsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get location =>
      $composableBuilder(column: $table.location, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$OfflinePlantsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflinePlantsTable,
          OfflinePlant,
          $$OfflinePlantsTableFilterComposer,
          $$OfflinePlantsTableOrderingComposer,
          $$OfflinePlantsTableAnnotationComposer,
          $$OfflinePlantsTableCreateCompanionBuilder,
          $$OfflinePlantsTableUpdateCompanionBuilder,
          (
            OfflinePlant,
            BaseReferences<_$AppDatabase, $OfflinePlantsTable, OfflinePlant>,
          ),
          OfflinePlant,
          PrefetchHooks Function()
        > {
  $$OfflinePlantsTableTableManager(_$AppDatabase db, $OfflinePlantsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflinePlantsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflinePlantsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflinePlantsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> location = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflinePlantsCompanion(
                id: id,
                name: name,
                location: location,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> location = const Value.absent(),
                required bool active,
                Value<int> rowid = const Value.absent(),
              }) => OfflinePlantsCompanion.insert(
                id: id,
                name: name,
                location: location,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflinePlantsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflinePlantsTable,
      OfflinePlant,
      $$OfflinePlantsTableFilterComposer,
      $$OfflinePlantsTableOrderingComposer,
      $$OfflinePlantsTableAnnotationComposer,
      $$OfflinePlantsTableCreateCompanionBuilder,
      $$OfflinePlantsTableUpdateCompanionBuilder,
      (
        OfflinePlant,
        BaseReferences<_$AppDatabase, $OfflinePlantsTable, OfflinePlant>,
      ),
      OfflinePlant,
      PrefetchHooks Function()
    >;
typedef $$OfflineLinesTableCreateCompanionBuilder =
    OfflineLinesCompanion Function({
      required String id,
      required String plantId,
      required String name,
      required bool active,
      Value<int> rowid,
    });
typedef $$OfflineLinesTableUpdateCompanionBuilder =
    OfflineLinesCompanion Function({
      Value<String> id,
      Value<String> plantId,
      Value<String> name,
      Value<bool> active,
      Value<int> rowid,
    });

class $$OfflineLinesTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineLinesTable> {
  $$OfflineLinesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get plantId => $composableBuilder(
    column: $table.plantId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineLinesTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineLinesTable> {
  $$OfflineLinesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get plantId => $composableBuilder(
    column: $table.plantId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineLinesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineLinesTable> {
  $$OfflineLinesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get plantId =>
      $composableBuilder(column: $table.plantId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$OfflineLinesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineLinesTable,
          OfflineLine,
          $$OfflineLinesTableFilterComposer,
          $$OfflineLinesTableOrderingComposer,
          $$OfflineLinesTableAnnotationComposer,
          $$OfflineLinesTableCreateCompanionBuilder,
          $$OfflineLinesTableUpdateCompanionBuilder,
          (
            OfflineLine,
            BaseReferences<_$AppDatabase, $OfflineLinesTable, OfflineLine>,
          ),
          OfflineLine,
          PrefetchHooks Function()
        > {
  $$OfflineLinesTableTableManager(_$AppDatabase db, $OfflineLinesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineLinesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineLinesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineLinesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> plantId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineLinesCompanion(
                id: id,
                plantId: plantId,
                name: name,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String plantId,
                required String name,
                required bool active,
                Value<int> rowid = const Value.absent(),
              }) => OfflineLinesCompanion.insert(
                id: id,
                plantId: plantId,
                name: name,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineLinesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineLinesTable,
      OfflineLine,
      $$OfflineLinesTableFilterComposer,
      $$OfflineLinesTableOrderingComposer,
      $$OfflineLinesTableAnnotationComposer,
      $$OfflineLinesTableCreateCompanionBuilder,
      $$OfflineLinesTableUpdateCompanionBuilder,
      (
        OfflineLine,
        BaseReferences<_$AppDatabase, $OfflineLinesTable, OfflineLine>,
      ),
      OfflineLine,
      PrefetchHooks Function()
    >;
typedef $$OfflineStationsTableCreateCompanionBuilder =
    OfflineStationsCompanion Function({
      required String id,
      required String lineId,
      required String name,
      required bool active,
      Value<int> rowid,
    });
typedef $$OfflineStationsTableUpdateCompanionBuilder =
    OfflineStationsCompanion Function({
      Value<String> id,
      Value<String> lineId,
      Value<String> name,
      Value<bool> active,
      Value<int> rowid,
    });

class $$OfflineStationsTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineStationsTable> {
  $$OfflineStationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineStationsTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineStationsTable> {
  $$OfflineStationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lineId => $composableBuilder(
    column: $table.lineId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineStationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineStationsTable> {
  $$OfflineStationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get lineId =>
      $composableBuilder(column: $table.lineId, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$OfflineStationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineStationsTable,
          OfflineStation,
          $$OfflineStationsTableFilterComposer,
          $$OfflineStationsTableOrderingComposer,
          $$OfflineStationsTableAnnotationComposer,
          $$OfflineStationsTableCreateCompanionBuilder,
          $$OfflineStationsTableUpdateCompanionBuilder,
          (
            OfflineStation,
            BaseReferences<
              _$AppDatabase,
              $OfflineStationsTable,
              OfflineStation
            >,
          ),
          OfflineStation,
          PrefetchHooks Function()
        > {
  $$OfflineStationsTableTableManager(
    _$AppDatabase db,
    $OfflineStationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineStationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OfflineStationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OfflineStationsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> lineId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineStationsCompanion(
                id: id,
                lineId: lineId,
                name: name,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String lineId,
                required String name,
                required bool active,
                Value<int> rowid = const Value.absent(),
              }) => OfflineStationsCompanion.insert(
                id: id,
                lineId: lineId,
                name: name,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineStationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineStationsTable,
      OfflineStation,
      $$OfflineStationsTableFilterComposer,
      $$OfflineStationsTableOrderingComposer,
      $$OfflineStationsTableAnnotationComposer,
      $$OfflineStationsTableCreateCompanionBuilder,
      $$OfflineStationsTableUpdateCompanionBuilder,
      (
        OfflineStation,
        BaseReferences<_$AppDatabase, $OfflineStationsTable, OfflineStation>,
      ),
      OfflineStation,
      PrefetchHooks Function()
    >;
typedef $$OfflineDefectCategoriesTableCreateCompanionBuilder =
    OfflineDefectCategoriesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      required bool active,
      Value<int> rowid,
    });
typedef $$OfflineDefectCategoriesTableUpdateCompanionBuilder =
    OfflineDefectCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<bool> active,
      Value<int> rowid,
    });

class $$OfflineDefectCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $OfflineDefectCategoriesTable> {
  $$OfflineDefectCategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );
}

class $$OfflineDefectCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $OfflineDefectCategoriesTable> {
  $$OfflineDefectCategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$OfflineDefectCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $OfflineDefectCategoriesTable> {
  $$OfflineDefectCategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);
}

class $$OfflineDefectCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $OfflineDefectCategoriesTable,
          OfflineDefectCategory,
          $$OfflineDefectCategoriesTableFilterComposer,
          $$OfflineDefectCategoriesTableOrderingComposer,
          $$OfflineDefectCategoriesTableAnnotationComposer,
          $$OfflineDefectCategoriesTableCreateCompanionBuilder,
          $$OfflineDefectCategoriesTableUpdateCompanionBuilder,
          (
            OfflineDefectCategory,
            BaseReferences<
              _$AppDatabase,
              $OfflineDefectCategoriesTable,
              OfflineDefectCategory
            >,
          ),
          OfflineDefectCategory,
          PrefetchHooks Function()
        > {
  $$OfflineDefectCategoriesTableTableManager(
    _$AppDatabase db,
    $OfflineDefectCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OfflineDefectCategoriesTableFilterComposer(
                $db: db,
                $table: table,
              ),
          createOrderingComposer: () =>
              $$OfflineDefectCategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$OfflineDefectCategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => OfflineDefectCategoriesCompanion(
                id: id,
                name: name,
                description: description,
                active: active,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                required bool active,
                Value<int> rowid = const Value.absent(),
              }) => OfflineDefectCategoriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                active: active,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$OfflineDefectCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $OfflineDefectCategoriesTable,
      OfflineDefectCategory,
      $$OfflineDefectCategoriesTableFilterComposer,
      $$OfflineDefectCategoriesTableOrderingComposer,
      $$OfflineDefectCategoriesTableAnnotationComposer,
      $$OfflineDefectCategoriesTableCreateCompanionBuilder,
      $$OfflineDefectCategoriesTableUpdateCompanionBuilder,
      (
        OfflineDefectCategory,
        BaseReferences<
          _$AppDatabase,
          $OfflineDefectCategoriesTable,
          OfflineDefectCategory
        >,
      ),
      OfflineDefectCategory,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$OfflineTicketsTableTableManager get offlineTickets =>
      $$OfflineTicketsTableTableManager(_db, _db.offlineTickets);
  $$OfflinePlantsTableTableManager get offlinePlants =>
      $$OfflinePlantsTableTableManager(_db, _db.offlinePlants);
  $$OfflineLinesTableTableManager get offlineLines =>
      $$OfflineLinesTableTableManager(_db, _db.offlineLines);
  $$OfflineStationsTableTableManager get offlineStations =>
      $$OfflineStationsTableTableManager(_db, _db.offlineStations);
  $$OfflineDefectCategoriesTableTableManager get offlineDefectCategories =>
      $$OfflineDefectCategoriesTableTableManager(
        _db,
        _db.offlineDefectCategories,
      );
}

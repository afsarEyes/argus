import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

part 'database.g.dart';

// Type converter to store photo paths list as JSON text in SQLite
class StringListConverter extends TypeConverter<List<String>, String> {
  const StringListConverter();

  @override
  List<String> fromSql(String fromDb) {
    try {
      final decoded = json.decode(fromDb);
      if (decoded is List) {
        return List<String>.from(decoded);
      }
    } catch (_) {}
    return [];
  }

  @override
  String toSql(List<String> value) {
    return json.encode(value);
  }
}

// 1. Offline Tickets Table
class OfflineTickets extends Table {
  TextColumn get id => text()(); // UUID generated locally
  TextColumn get humanReadableId => text().nullable()(); // ARG-YYYY-XXXXX populated upon sync
  TextColumn get reporterId => text()();
  TextColumn get lineId => text()();
  TextColumn get stationId => text()();
  TextColumn get defectCategoryId => text()();
  TextColumn get severity => text()(); // critical, major, minor
  TextColumn get photoPaths => text().map(const StringListConverter())();
  TextColumn get voiceNotePath => text().nullable()();
  TextColumn get description => text()();
  TextColumn get status => text().withDefault(const Constant('open'))(); // open, assigned, in_progress, resolved, closed
  DateTimeColumn get createdAt => dateTime()();
  TextColumn get syncStatus => text().withDefault(const Constant('pending_sync'))(); // pending_sync, syncing, error

  @override
  Set<Column> get primaryKey => {id};
}

// 2. Offline Plants Table
class OfflinePlants extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get location => text().nullable()();
  BoolColumn get active => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

// 3. Offline Lines Table
class OfflineLines extends Table {
  TextColumn get id => text()();
  TextColumn get plantId => text()();
  TextColumn get name => text()();
  BoolColumn get active => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

// 4. Offline Stations Table
class OfflineStations extends Table {
  TextColumn get id => text()();
  TextColumn get lineId => text()();
  TextColumn get name => text()();
  BoolColumn get active => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

// 5. Offline Defect Categories Table
class OfflineDefectCategories extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get description => text().nullable()();
  BoolColumn get active => boolean()();

  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(tables: [
  OfflineTickets,
  OfflinePlants,
  OfflineLines,
  OfflineStations,
  OfflineDefectCategories,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'argus_local_db');
  }
}

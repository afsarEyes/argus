import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:argus_core/argus_core.dart';
import '../offline/database.dart';
import '../offline/sync_manager.dart';
import '../services/attachment_service.dart';

part 'local_providers.g.dart';

@riverpod
AppDatabase database(DatabaseRef ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
}

@riverpod
SyncManager syncManager(SyncManagerRef ref) {
  final db = ref.watch(databaseProvider);
  final client = ref.watch(supabaseClientProvider);
  return SyncManager(db, client);
}

@riverpod
AttachmentService attachmentService(AttachmentServiceRef ref) {
  return AttachmentService();
}

@riverpod
class ThemeModeState extends _$ThemeModeState {
  @override
  ThemeMode build() {
    return ThemeMode.dark; // Default to dark mode for industrial feel
  }

  void toggleTheme() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

@riverpod
Future<List<Line>> linesList(LinesListRef ref) {
  return ref.watch(masterDataRepositoryProvider).getLines();
}

@riverpod
Future<List<Station>> stationsList(StationsListRef ref) {
  return ref.watch(masterDataRepositoryProvider).getStations();
}

@riverpod
Future<List<DefectCategory>> defectCategoriesList(DefectCategoriesListRef ref) {
  return ref.watch(masterDataRepositoryProvider).getDefectCategories();
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide User;
import 'package:argus_core/argus_core.dart';

// Repositories
final consoleAuthRepositoryProvider = Provider<AuthRepository>((ref) {
  return SupabaseAuthRepository(Supabase.instance.client);
});

final consoleTicketRepositoryProvider = Provider<TicketRepository>((ref) {
  return SupabaseTicketRepository(Supabase.instance.client);
});

final consoleMasterDataRepositoryProvider = Provider<MasterDataRepository>((ref) {
  return SupabaseMasterDataRepository(Supabase.instance.client);
});

// App State
final consoleUserProvider = StreamProvider<User?>((ref) {
  return ref.watch(consoleAuthRepositoryProvider).currentUserStream;
});

final consoleSelectedPlantProvider = StateProvider<String>((ref) => 'all');

final consoleRealtimeConnectedProvider = StateProvider<bool>((ref) => true);

final consoleThemeModeProvider = StateNotifierProvider<ConsoleThemeModeNotifier, ThemeMode>((ref) {
  return ConsoleThemeModeNotifier();
});

class ConsoleThemeModeNotifier extends StateNotifier<ThemeMode> {
  ConsoleThemeModeNotifier() : super(ThemeMode.dark);

  void toggle() {
    state = state == ThemeMode.dark ? ThemeMode.light : ThemeMode.dark;
  }
}

// Master Data Lists
final consolePlantsListProvider = FutureProvider<List<Plant>>((ref) {
  return ref.watch(consoleMasterDataRepositoryProvider).getPlants();
});

final consoleLinesListProvider = FutureProvider<List<Line>>((ref) {
  return ref.watch(consoleMasterDataRepositoryProvider).getLines();
});

final consoleStationsListProvider = FutureProvider<List<Station>>((ref) {
  return ref.watch(consoleMasterDataRepositoryProvider).getStations();
});

final consoleCategoriesListProvider = FutureProvider<List<DefectCategory>>((ref) {
  return ref.watch(consoleMasterDataRepositoryProvider).getDefectCategories();
});

import 'package:argus_core/argus_core.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:drift/drift.dart';
import '../offline/database.dart';

class OfflineFirstMasterDataRepository implements MasterDataRepository {
  OfflineFirstMasterDataRepository({
    required this.remoteRepository,
    required this.db,
  });

  final MasterDataRepository remoteRepository;
  final AppDatabase db;

  @override
  Future<List<Plant>> getPlants() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasConnection = connectivity.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        final plants = await remoteRepository.getPlants();
        await db.batch((batch) {
          for (final plant in plants) {
            batch.insert(
              db.offlinePlants,
              OfflinePlantsCompanion.insert(
                id: plant.id,
                name: plant.name,
                location: Value(plant.location),
                active: plant.active,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
        return plants;
      }
    } catch (_) {}

    // Fallback: Read plants from local Drift cache
    final cached = await db.select(db.offlinePlants).get();
    return cached
        .map((p) => Plant(
              id: p.id,
              name: p.name,
              location: p.location,
              active: p.active,
            ))
        .toList();
  }

  @override
  Future<List<Line>> getLines() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasConnection = connectivity.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        final lines = await remoteRepository.getLines();
        await db.batch((batch) {
          for (final line in lines) {
            batch.insert(
              db.offlineLines,
              OfflineLinesCompanion.insert(
                id: line.id,
                plantId: line.plantId,
                name: line.name,
                active: line.active,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
        return lines;
      }
    } catch (_) {}

    // Fallback: Read lines from local Drift cache
    final cached = await db.select(db.offlineLines).get();
    return cached
        .map((l) => Line(
              id: l.id,
              plantId: l.plantId,
              name: l.name,
              active: l.active,
            ))
        .toList();
  }

  @override
  Future<List<Station>> getStations() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasConnection = connectivity.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        final stations = await remoteRepository.getStations();
        await db.batch((batch) {
          for (final station in stations) {
            batch.insert(
              db.offlineStations,
              OfflineStationsCompanion.insert(
                id: station.id,
                lineId: station.lineId,
                name: station.name,
                active: station.active,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
        return stations;
      }
    } catch (_) {}

    // Fallback: Read stations from local Drift cache
    final cached = await db.select(db.offlineStations).get();
    return cached
        .map((s) => Station(
              id: s.id,
              lineId: s.lineId,
              name: s.name,
              active: s.active,
            ))
        .toList();
  }

  @override
  Future<List<DefectCategory>> getDefectCategories() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasConnection = connectivity.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        final categories = await remoteRepository.getDefectCategories();
        await db.batch((batch) {
          for (final category in categories) {
            batch.insert(
              db.offlineDefectCategories,
              OfflineDefectCategoriesCompanion.insert(
                id: category.id,
                name: category.name,
                description: Value(category.description),
                active: category.active,
              ),
              mode: InsertMode.insertOrReplace,
            );
          }
        });
        return categories;
      }
    } catch (_) {}

    // Fallback: Read defect categories from local Drift cache
    final cached = await db.select(db.offlineDefectCategories).get();
    return cached
        .map((c) => DefectCategory(
              id: c.id,
              name: c.name,
              description: c.description,
              active: c.active,
            ))
        .toList();
  }

  @override
  Future<List<AssignmentRule>> getAssignmentRules() async {
    try {
      final connectivity = await Connectivity().checkConnectivity();
      final hasConnection = connectivity.any((r) => r != ConnectivityResult.none);

      if (hasConnection) {
        return await remoteRepository.getAssignmentRules();
      }
    } catch (_) {}
    return [];
  }
}

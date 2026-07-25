import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart' as supabase;
import '../models/plant.dart';
import '../models/line.dart';
import '../models/station.dart';
import '../models/defect_category.dart';
import '../models/assignment_rule.dart';
import '../services/supabase_client_provider.dart';

part 'master_data_repository.g.dart';

abstract class MasterDataRepository {
  Future<List<Plant>> getPlants();
  Future<List<Line>> getLines();
  Future<List<Station>> getStations();
  Future<List<DefectCategory>> getDefectCategories();
  Future<List<AssignmentRule>> getAssignmentRules();
}

class SupabaseMasterDataRepository implements MasterDataRepository {
  SupabaseMasterDataRepository(this._client);
  final supabase.SupabaseClient _client;

  @override
  Future<List<Plant>> getPlants() async {
    final List<dynamic> data = await _client.from('plants').select().order('name');
    return data.map((json) => Plant.fromJson(json)).toList();
  }

  @override
  Future<List<Line>> getLines() async {
    final List<dynamic> data = await _client.from('lines').select().order('name');
    return data.map((json) => Line.fromJson(json)).toList();
  }

  @override
  Future<List<Station>> getStations() async {
    final List<dynamic> data = await _client.from('stations').select().order('name');
    return data.map((json) => Station.fromJson(json)).toList();
  }

  @override
  Future<List<DefectCategory>> getDefectCategories() async {
    final List<dynamic> data = await _client.from('defect_categories').select().order('name');
    return data.map((json) => DefectCategory.fromJson(json)).toList();
  }

  @override
  Future<List<AssignmentRule>> getAssignmentRules() async {
    final List<dynamic> data = await _client.from('assignment_rules').select();
    return data.map((json) => AssignmentRule.fromJson(json)).toList();
  }
}

@riverpod
MasterDataRepository masterDataRepository(MasterDataRepositoryRef ref) {
  final client = ref.watch(supabaseClientProvider);
  return SupabaseMasterDataRepository(client);
}

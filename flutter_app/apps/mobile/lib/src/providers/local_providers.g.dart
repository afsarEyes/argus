// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$databaseHash() => r'fe9e31a41cdfd29367d156df6a56b19b72fe5540';

/// See also [database].
@ProviderFor(database)
final databaseProvider = AutoDisposeProvider<AppDatabase>.internal(
  database,
  name: r'databaseProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$databaseHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DatabaseRef = AutoDisposeProviderRef<AppDatabase>;
String _$syncManagerHash() => r'46b259e42c3b2f4a560d7ea917948e2180727778';

/// See also [syncManager].
@ProviderFor(syncManager)
final syncManagerProvider = AutoDisposeProvider<SyncManager>.internal(
  syncManager,
  name: r'syncManagerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncManagerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef SyncManagerRef = AutoDisposeProviderRef<SyncManager>;
String _$attachmentServiceHash() => r'1954ba5878ce184258bb6df4d52023d985f1f9f6';

/// See also [attachmentService].
@ProviderFor(attachmentService)
final attachmentServiceProvider =
    AutoDisposeProvider<AttachmentService>.internal(
      attachmentService,
      name: r'attachmentServiceProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$attachmentServiceHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AttachmentServiceRef = AutoDisposeProviderRef<AttachmentService>;
String _$linesListHash() => r'8d15012d311e81901120f1293b34cb3b502b60bc';

/// See also [linesList].
@ProviderFor(linesList)
final linesListProvider = AutoDisposeFutureProvider<List<Line>>.internal(
  linesList,
  name: r'linesListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$linesListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef LinesListRef = AutoDisposeFutureProviderRef<List<Line>>;
String _$stationsListHash() => r'c00686fc810e979a5141d12608aa922fb66f3e38';

/// See also [stationsList].
@ProviderFor(stationsList)
final stationsListProvider = AutoDisposeFutureProvider<List<Station>>.internal(
  stationsList,
  name: r'stationsListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$stationsListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef StationsListRef = AutoDisposeFutureProviderRef<List<Station>>;
String _$defectCategoriesListHash() =>
    r'dfe7129bccfb4df67ea1bfffe8de09a48f11031a';

/// See also [defectCategoriesList].
@ProviderFor(defectCategoriesList)
final defectCategoriesListProvider =
    AutoDisposeFutureProvider<List<DefectCategory>>.internal(
      defectCategoriesList,
      name: r'defectCategoriesListProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$defectCategoriesListHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef DefectCategoriesListRef =
    AutoDisposeFutureProviderRef<List<DefectCategory>>;
String _$themeModeStateHash() => r'4e9a18141b3bcbd34d3aed54419338a6d3cfc460';

/// See also [ThemeModeState].
@ProviderFor(ThemeModeState)
final themeModeStateProvider =
    AutoDisposeNotifierProvider<ThemeModeState, ThemeMode>.internal(
      ThemeModeState.new,
      name: r'themeModeStateProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$themeModeStateHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ThemeModeState = AutoDisposeNotifier<ThemeMode>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import 'src/providers/local_providers.dart';
import 'src/repositories/offline_first_ticket_repository.dart';
import 'src/repositories/offline_first_master_data_repository.dart';
import 'src/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'https://prcgbbytixlaxuhmfurk.supabase.co',
  );

  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_9VXQPDYhY6rnKuuTyltApQ_bwMaphrY',
  );

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  runApp(
    ProviderScope(
      overrides: [
        ticketRepositoryProvider.overrideWith((ref) {
          final remote = SupabaseTicketRepository(ref.watch(supabaseClientProvider));
          final db = ref.watch(databaseProvider);
          final sync = ref.watch(syncManagerProvider);
          return OfflineFirstTicketRepository(
            remoteRepository: remote,
            db: db,
            syncManager: sync,
          );
        }),
        masterDataRepositoryProvider.overrideWith((ref) {
          final remote = SupabaseMasterDataRepository(ref.watch(supabaseClientProvider));
          final db = ref.watch(databaseProvider);
          return OfflineFirstMasterDataRepository(
            remoteRepository: remote,
            db: db,
          );
        }),
      ],
      child: const ArgusAppBootstrap(),
    ),
  );
}

class ArgusAppBootstrap extends ConsumerStatefulWidget {
  const ArgusAppBootstrap({super.key});

  @override
  ConsumerState<ArgusAppBootstrap> createState() => _ArgusAppBootstrapState();
}

class _ArgusAppBootstrapState extends ConsumerState<ArgusAppBootstrap> {
  @override
  void initState() {
    super.initState();
    // Start listening to network connectivity and trigger syncs automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(syncManagerProvider).startMonitoring();
    });
  }

  @override
  void dispose() {
    // Stop sync network monitoring safely
    ref.read(syncManagerProvider).stopMonitoring();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final router = ref.watch(appRouterProvider);
    final themeMode = ref.watch(themeModeStateProvider);

    return MaterialApp.router(
      title: 'Argus QC System',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ArgusTheme.light,
      darkTheme: ArgusTheme.dark,
      routerConfig: router,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:argus_ui/argus_ui.dart';
import 'src/providers/console_providers.dart';
import 'src/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase client
  const supabaseUrl = String.fromEnvironment(
    'SUPABASE_URL',
    defaultValue: 'http://127.0.0.1:54321',
  );
  const supabaseAnonKey = String.fromEnvironment(
    'SUPABASE_ANON_KEY',
    defaultValue: 'sb_publishable_ACJWlzQHlZjBrEguHvfOxg_3BJgxAaH',
  );

  await Supabase.initialize(
    url: supabaseUrl,
    anonKey: supabaseAnonKey,
  );

  // Turn off Google Fonts runtime HTTP fetching
  GoogleFonts.config.allowRuntimeFetching = false;

  runApp(
    const ProviderScope(
      child: ConsoleAppBootstrap(),
    ),
  );
}

class ConsoleAppBootstrap extends ConsumerWidget {
  const ConsoleAppBootstrap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(consoleRouterProvider);
    final themeMode = ref.watch(consoleThemeModeProvider);

    return MaterialApp.router(
      title: 'Argus Control Tower',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,
      theme: ArgusTheme.light,
      darkTheme: ArgusTheme.dark,
      routerConfig: router,
    );
  }
}

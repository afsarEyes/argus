import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';
import '../providers/console_providers.dart';

class ConsoleLoginScreen extends ConsumerStatefulWidget {
  const ConsoleLoginScreen({super.key});

  @override
  ConsumerState<ConsoleLoginScreen> createState() => _ConsoleLoginScreenState();
}

class _ConsoleLoginScreenState extends ConsumerState<ConsoleLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final repo = ref.read(consoleAuthRepositoryProvider);
      final user = await repo.login(_emailController.text.trim(), _passwordController.text.trim());
      
      // Verify that user is authorized to use console (e.g. not a staff member)
      if (user == null || user.role == UserRole.staff) {
        await repo.logout();
        throw Exception('Access Denied: Operators are restricted to mobile terminals.');
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SizedBox(
          width: 440,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Logo
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.security, color: colors.brandAccent, size: 32),
                  const SizedBox(width: 12),
                  Text(
                    'ARGUS CONTROL TOWER',
                    style: TextStyle(
                      fontFamily: 'SpaceGrotesk',
                      fontWeight: FontWeight.w900,
                      fontSize: 22,
                      color: colors.textPrimary,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Plant QC Supervision & System Management Console',
                style: TextStyle(fontFamily: 'Inter', fontSize: 13, color: colors.textSecondary),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),

              if (_errorMessage != null) ...[
                ArgusErrorState(
                  errorMessage: _errorMessage!,
                  onRetry: () => setState(() => _errorMessage = null),
                ),
                const SizedBox(height: 16),
              ],

              ArgusPanel(
                child: Padding(
                  padding: const EdgeInsets.all(32.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'SYSTEM AUTHENTICATION',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 20),

                        TextFormField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          decoration: const InputDecoration(
                            labelText: 'Enterprise Email',
                            hintText: 'name@signode.com',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Email is required';
                            if (!val.contains('@')) return 'Invalid email address';
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          obscureText: true,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            hintText: '••••••••',
                          ),
                          validator: (val) {
                            if (val == null || val.isEmpty) return 'Password is required';
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),

                        ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.brandAccent,
                            padding: const EdgeInsets.symmetric(vertical: 20),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                                )
                              : const Text(
                                  'AUTHENTICATE ACCESS',
                                  style: TextStyle(fontFamily: 'SpaceGrotesk', fontWeight: FontWeight.bold),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

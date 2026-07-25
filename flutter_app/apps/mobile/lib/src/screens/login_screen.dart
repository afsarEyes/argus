import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:argus_core/argus_core.dart';
import 'package:argus_ui/argus_ui.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  
  bool _isLoading = false;
  String? _errorMessage;
  bool _isPinMode = false;
  final _pinController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    debugPrint('--------------------------------------------------');
    debugPrint('LoginScreen: SECURE ACCESS CLICKED. email=${_emailController.text.trim()}, password=${_passwordController.text}');
    debugPrint('--------------------------------------------------');
    if (!_formKey.currentState!.validate()) {
      debugPrint('LoginScreen: Form validation failed.');
      return;
    }
    
    // Subtle haptic feedback
    HapticFeedback.lightImpact();

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final authRepo = ref.read(authRepositoryProvider);
      User? user;
      if (_isPinMode) {
        debugPrint('LoginScreen: Trying PIN login...');
        user = await authRepo.loginWithPin(_pinController.text);
      } else {
        debugPrint('LoginScreen: Trying email login...');
        user = await authRepo.login(
          _emailController.text.trim(),
          _passwordController.text,
        );
      }

      debugPrint('--------------------------------------------------');
      debugPrint('LoginScreen: Login response User object is: $user');
      debugPrint('--------------------------------------------------');

      if (user == null) {
        debugPrint('LoginScreen: Auth returned null profile.');
        setState(() {
          _errorMessage = 'Authentication failed. Please verify credentials.';
        });
      } else {
        debugPrint('LoginScreen: Auth successful, user details: $user');
      }
    } catch (e) {
      debugPrint('-------------------- ERROR DURING LOGIN --------------------');
      debugPrint('LoginScreen: Caught error: $e');
      debugPrint('------------------------------------------------------------');
      setState(() {
        _errorMessage = e.toString().replaceAll('Exception: ', '');
      });
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).extension<ArgusColors>()!;
    
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Industrial Brand Logo Header
              Text(
                'ARGUS // QC SYSTEM',
                style: TextStyle(
                  fontFamily: 'SpaceGrotesk',
                  fontWeight: FontWeight.w700,
                  fontSize: 28,
                  color: colors.brandAccent,
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'QC Issue Tracking & Offline Sync Engine',
                style: TextStyle(
                  fontFamily: 'Inter',
                  fontSize: 14,
                  color: colors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 36),
              
              if (_errorMessage != null) ...[
                ArgusErrorState(
                  errorMessage: _errorMessage!,
                  onRetry: () {
                    setState(() {
                      _errorMessage = null;
                    });
                  },
                ),
                const SizedBox(height: 16),
              ],

              ArgusPanel(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          _isPinMode ? 'PIN ENTRY' : 'CREDENTIAL SIGN IN',
                          style: TextStyle(
                            fontFamily: 'SpaceGrotesk',
                            fontWeight: FontWeight.w700,
                            fontSize: 16,
                            color: colors.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 16),
                        
                        if (!_isPinMode) ...[
                          TextFormField(
                            controller: _emailController,
                            style: TextStyle(color: colors.textPrimary, fontFamily: 'Inter'),
                            decoration: InputDecoration(
                              labelText: 'Plant Email Address',
                              labelStyle: TextStyle(color: colors.textSecondary),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colors.panelBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colors.brandAccent),
                              ),
                            ),
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) => value == null || !value.contains('@') 
                                ? 'Enter a valid plant email' 
                                : null,
                          ),
                          const SizedBox(height: 16),
                          TextFormField(
                            controller: _passwordController,
                            style: TextStyle(color: colors.textPrimary, fontFamily: 'Inter'),
                            decoration: InputDecoration(
                              labelText: 'Security Password',
                              labelStyle: TextStyle(color: colors.textSecondary),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colors.panelBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colors.brandAccent),
                              ),
                            ),
                            obscureText: true,
                            validator: (value) => value == null || value.length < 6 
                                ? 'Password must be at least 6 characters' 
                                : null,
                          ),
                        ] else ...[
                          TextFormField(
                            controller: _pinController,
                            style: TextStyle(color: colors.textPrimary, fontFamily: 'JetBrainsMono'),
                            decoration: InputDecoration(
                              labelText: '4-Digit Operator PIN',
                              labelStyle: TextStyle(color: colors.textSecondary),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colors.panelBorder),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: colors.brandAccent),
                              ),
                            ),
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 4,
                            validator: (value) => value == null || value.length != 4 
                                ? 'PIN must be exactly 4 digits' 
                                : null,
                          ),
                        ],
                        
                        const SizedBox(height: 24),
                        
                        ElevatedButton(
                          onPressed: _isLoading ? null : _handleLogin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.brandAccent,
                            foregroundColor: Colors.black,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.all(Radius.circular(6)),
                            ),
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                                  ),
                                )
                              : Text(
                                  _isPinMode ? 'START WORK' : 'SECURE ACCESS',
                                  style: const TextStyle(
                                    fontFamily: 'SpaceGrotesk',
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 1,
                                  ),
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  HapticFeedback.lightImpact();
                  setState(() {
                    _isPinMode = !_isPinMode;
                    _errorMessage = null;
                  });
                },
                child: Text(
                  _isPinMode ? 'Switch to Email Sign In' : 'Switch to Quick Operator PIN Mode',
                  style: TextStyle(
                    fontFamily: 'Inter',
                    color: colors.brandAccent,
                    fontWeight: FontWeight.w600,
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

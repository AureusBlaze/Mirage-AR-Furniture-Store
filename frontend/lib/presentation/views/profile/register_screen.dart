import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';

/// Register screen.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _obscure = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      body: BackgroundLayer(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back, color: theme.brightness == Brightness.dark ? theme.textOnDark : theme.textPrimary),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'CREATE\nACCOUNT',
                    style: MirageTypography.displayMedium(
                      color: theme.textOnDark,
                    ).copyWith(height: 1.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join the Mirage experience',
                    style: MirageTypography.bodyMedium(
                      color: theme.textOnDark.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 36),
                  _buildField('Full Name', _nameController, Icons.person_outline,
                      theme: theme,
                      validator: (v) => v == null || v.isEmpty ? 'Required' : null),
                  const SizedBox(height: 14),
                  _buildField('Email', _emailController, Icons.email_outlined,
                      theme: theme,
                      keyboardType: TextInputType.emailAddress,
                      validator: (v) =>
                          v == null || !v.contains('@') ? 'Valid email required' : null),
                  const SizedBox(height: 14),
                  _buildField('Password', _passwordController, Icons.lock_outline,
                      theme: theme,
                      obscure: _obscure,
                      suffix: IconButton(
                        icon: Icon(
                          _obscure ? Icons.visibility_off : Icons.visibility,
                          color: theme.textOnDark.withValues(alpha: 0.5),
                          size: 20,
                        ),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                      validator: (v) =>
                          v == null || v.length < 6 ? 'Min 6 characters' : null),
                  const SizedBox(height: 14),
                  _buildField(
                      'Confirm Password', _confirmController, Icons.lock_outline,
                      theme: theme,
                      obscure: _obscure,
                      validator: (v) => v != _passwordController.text
                          ? 'Passwords don\'t match'
                          : null),
                  const SizedBox(height: 28),
                  Consumer<AuthViewModel>(
                    builder: (_, authVm, __) {
                      return Column(
                        children: [
                          if (authVm.error != null)
                            Padding(
                              padding: const EdgeInsets.only(bottom: 16),
                              child: Text(authVm.error!,
                                  style: TextStyle(color: theme.error)),
                            ),
                          SizedBox(
                            width: double.infinity,
                            height: 52,
                            child: ElevatedButton(
                              onPressed: authVm.isLoading
                                  ? null
                                  : () async {
                                      if (_formKey.currentState!.validate()) {
                                        final success = await authVm.register(
                                          name: _nameController.text,
                                          email: _emailController.text,
                                          password: _passwordController.text,
                                          passwordConfirmation:
                                              _confirmController.text,
                                        );
                                        if (success && mounted) {
                                          Navigator.pop(context);
                                        }
                                      }
                                    },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.accent,
                                foregroundColor: theme.primaryDark,
                              ),
                              child: authVm.isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                          strokeWidth: 2),
                                    )
                                  : const Text('CREATE ACCOUNT'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pushReplacementNamed('/login');
                      },
                      child: Text.rich(
                        TextSpan(
                          text: 'Already have an account? ',
                          style: TextStyle(
                            color: theme.textOnDark.withValues(alpha: 0.5),
                          ),
                          children: [
                            TextSpan(
                              text: 'Sign In',
                              style: TextStyle(
                                color: theme.accent,
                                fontWeight: FontWeight.w600,
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
        ),
      ),
    );
  }

  Widget _buildField(
    String label,
    TextEditingController controller,
    IconData icon, {
    required dynamic theme,
    bool obscure = false,
    Widget? suffix,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
      style: TextStyle(color: theme.textOnDark),
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: theme.textOnDark.withValues(alpha: 0.5)),
        prefixIcon:
            Icon(icon, color: theme.textOnDark.withValues(alpha: 0.5), size: 20),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.1)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: theme.accent),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/auth_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';

/// Profile screen — user info, theme navigation, and logout.
/// Shows login prompt if unauthenticated.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _versionTapCount = 0;
  Timer? _tapResetTimer;

  void _onVersionTap() {
    // Only active in debug mode
    if (!kDebugMode) return;

    _versionTapCount++;
    _tapResetTimer?.cancel();
    _tapResetTimer = Timer(const Duration(seconds: 3), () {
      _versionTapCount = 0;
    });

    if (_versionTapCount >= 5) {
      _versionTapCount = 0;
      _tapResetTimer?.cancel();
      Navigator.of(context).pushNamed('/dev-settings');
    }
  }

  @override
  void dispose() {
    _tapResetTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Container(
      color: theme.surface,
      child: Consumer<AuthViewModel>(
        builder: (_, authVm, __) {
          if (!authVm.isAuthenticated) {
            return _buildLoginPrompt(context, theme);
          }
          return _buildProfile(context, authVm, theme);
        },
      ),
    );
  }

  Widget _buildLoginPrompt(BuildContext context, dynamic theme) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.person_outline,
              size: 64,
              color: theme.textSecondary.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'Welcome to Mirage',
              style: MirageTypography.displaySmall(color: theme.textPrimary),
            ),
            const SizedBox(height: 8),
            Text(
              'Sign in to access your profile and order history',
              textAlign: TextAlign.center,
              style: MirageTypography.bodyMedium(color: theme.textSecondary),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pushNamed('/login'),
                child: const Text('SIGN IN'),
              ),
            ),
            const SizedBox(height: 12),
            TextButton(
              onPressed: () => Navigator.of(context).pushNamed('/register'),
              child: Text(
                'CREATE ACCOUNT',
                style: TextStyle(
                  color: theme.accentWarm,
                  letterSpacing: 2,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(height: 40),
            // Theme config navigation
            _buildThemeNavButton(context, theme),
            const SizedBox(height: 24),
            // Hidden version tap target
            _buildVersionLabel(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProfile(
    BuildContext context,
    AuthViewModel authVm,
    dynamic theme,
  ) {
    return ListView(
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 20,
        right: 20,
        bottom: 100,
      ),
      children: [
        // User info header
        BevelContainer(
          borderRadius: 20,
          padding: EdgeInsets.zero,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: theme.primaryDark,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: theme.accentWarm,
                  child: Text(
                    authVm.user?.name.substring(0, 1).toUpperCase() ?? '?',
                    style: MirageTypography.headingLarge(
                      color: theme.textOnDark,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        authVm.user?.name ?? '',
                        style: MirageTypography.headingMedium(
                          color: theme.textOnDark,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        authVm.user?.email ?? '',
                        style: MirageTypography.bodySmall(
                          color: theme.textOnDark.withValues(alpha: 0.6),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // Menu items
        _buildMenuItem(
          theme,
          icon: Icons.receipt_long_outlined,
          label: 'Order History',
          onTap: () => Navigator.of(context).pushNamed('/order-history'),
        ),
        _buildMenuItem(
          theme,
          icon: Icons.shield_outlined,
          label: 'Privacy Policy',
          onTap: () => _showContentDialog(
            context,
            theme,
            'Privacy Policy',
            'Your privacy matters to us at Aureus Studio. We collect only essential data to provide our services. Your personal information is encrypted and never shared with third parties without your consent. For detailed information, please visit our website.',
          ),
        ),
        _buildMenuItem(
          theme,
          icon: Icons.description_outlined,
          label: 'Terms of Service',
          onTap: () => _showContentDialog(
            context,
            theme,
            'Terms of Service',
            'By using Mirage, you agree to our terms of service. All products displayed are subject to availability. Prices may vary and are confirmed at checkout. AR visualizations are approximations and may differ from actual product dimensions. For complete terms, please visit our website.',
          ),
        ),

        const SizedBox(height: 24),

        // Theme config navigation
        _buildThemeNavButton(context, theme),

        const SizedBox(height: 24),

        // Logout
        TextButton.icon(
          onPressed: () => authVm.logout(),
          icon: Icon(Icons.logout, color: theme.error, size: 18),
          label: Text(
            'SIGN OUT',
            style: TextStyle(
              color: theme.error,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Hidden version tap target (at bottom of profile)
        _buildVersionLabel(theme),
      ],
    );
  }

  Widget _buildMenuItem(
    dynamic theme, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return BevelContainer(
      borderRadius: 12,
      padding: EdgeInsets.zero,
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: theme.textSecondary, size: 22),
        title: Text(
          label,
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        trailing: Icon(
          Icons.chevron_right,
          color: theme.textSecondary,
          size: 20,
        ),
        onTap: onTap,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  /// Navigation button to Theme Config Screen.
  Widget _buildThemeNavButton(BuildContext context, dynamic theme) {
    return BevelContainer(
      borderRadius: 16,
      padding: EdgeInsets.zero,
      child: ListTile(
        leading: Icon(Icons.palette_outlined, color: theme.accent, size: 22),
        title: Text(
          'Customize Theme',
          style: TextStyle(
            color: theme.textPrimary,
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Text(
          context.watch<ThemeProvider>().currentTheme.name,
          style: TextStyle(color: theme.textSecondary, fontSize: 12),
        ),
        trailing: Icon(Icons.chevron_right, color: theme.accent, size: 20),
        onTap: () => Navigator.of(context).pushNamed('/theme-config'),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
      ),
    );
  }

  /// Version label that acts as a hidden 5-tap dev settings entry point.
  Widget _buildVersionLabel(dynamic theme) {
    return Center(
      child: GestureDetector(
        onTap: _onVersionTap,
        behavior: HitTestBehavior.opaque,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: Text(
            'v1.0.0',
            style: MirageTypography.caption(
              color: theme.textSecondary.withValues(alpha: 0.35),
            ),
          ),
        ),
      ),
    );
  }

  /// Shows a premium-styled dialog for policy/terms content.
  void _showContentDialog(
    BuildContext context,
    dynamic theme,
    String title,
    String content,
  ) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: theme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Text(
          title.toUpperCase(),
          style: MirageTypography.headingSmall(
            color: theme.textPrimary,
          ).copyWith(letterSpacing: 2),
        ),
        content: SingleChildScrollView(
          child: Text(
            content,
            style: MirageTypography.bodyMedium(
              color: theme.textSecondary,
            ).copyWith(height: 1.7),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'CLOSE',
              style: TextStyle(
                color: theme.accent,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

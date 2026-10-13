import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/core/dev/dev_settings_provider.dart';

/// Hidden developer settings screen for runtime API base URL switching.
///
/// Only accessible in debug builds via:
///   1. Shaking the device
///   2. Tapping the version label 5 times on the Profile screen
class DevSettingsScreen extends StatefulWidget {
  const DevSettingsScreen({super.key});

  @override
  State<DevSettingsScreen> createState() => _DevSettingsScreenState();
}

class _DevSettingsScreenState extends State<DevSettingsScreen> {
  late TextEditingController _urlController;
  bool _saved = false;

  @override
  void initState() {
    super.initState();
    final provider = context.read<DevSettingsProvider>();
    _urlController = TextEditingController(text: provider.activeBaseUrl);
  }

  @override
  void dispose() {
    _urlController.dispose();
    super.dispose();
  }

  Future<void> _onSave() async {
    final url = _urlController.text.trim();
    if (url.isEmpty) return;

    final provider = context.read<DevSettingsProvider>();
    await provider.setBaseUrl(url);

    setState(() => _saved = true);
    Timer(const Duration(seconds: 2), () {
      if (mounted) setState(() => _saved = false);
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'API base URL updated successfully',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF2E7D32),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  Future<void> _onReset() async {
    final provider = context.read<DevSettingsProvider>();
    await provider.resetBaseUrl();
    _urlController.text = provider.defaultBaseUrl;

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Reset to default URL',
            style: GoogleFonts.manrope(fontWeight: FontWeight.w500),
          ),
          backgroundColor: const Color(0xFF5D4037),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      backgroundColor: theme.surface,
      appBar: AppBar(
        backgroundColor: theme.primaryDark,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new, color: theme.textOnDark, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.developer_mode, color: theme.accentWarm, size: 22),
            const SizedBox(width: 8),
            Text(
              'Developer Settings',
              style: MirageTypography.headingMedium(color: theme.textOnDark),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: Consumer<DevSettingsProvider>(
        builder: (_, devSettings, __) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),

                // ─── Debug Banner ────────────────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: theme.accentWarm.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: theme.accentWarm.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.bug_report_outlined,
                          size: 18, color: theme.accentWarm),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Debug mode only — this screen is removed in release builds.',
                          style: MirageTypography.bodySmall(
                            color: theme.accentWarm,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // ─── Section Label ───────────────────────────────────
                Text(
                  'API BASE URL',
                  style: MirageTypography.labelLarge(color: theme.textPrimary)
                      .copyWith(letterSpacing: 3),
                ),
                const SizedBox(height: 6),
                Text(
                  'Change the base URL used for all network requests.',
                  style: MirageTypography.bodySmall(color: theme.textSecondary),
                ),
                const SizedBox(height: 16),

                // ─── URL Input ───────────────────────────────────────
                Container(
                  decoration: BoxDecoration(
                    color: theme.primaryDark.withValues(alpha: 0.3),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: devSettings.isOverridden
                          ? theme.accentWarm.withValues(alpha: 0.5)
                          : theme.textSecondary.withValues(alpha: 0.15),
                    ),
                  ),
                  child: TextFormField(
                    controller: _urlController,
                    style: GoogleFonts.spaceGrotesk(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: theme.textPrimary,
                    ),
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 16),
                      border: InputBorder.none,
                      hintText: 'http://192.168.x.x:8000/api',
                      hintStyle: GoogleFonts.spaceGrotesk(
                        fontSize: 14,
                        color: theme.textSecondary.withValues(alpha: 0.4),
                      ),
                      prefixIcon: Icon(
                        Icons.link,
                        color: theme.textSecondary,
                        size: 20,
                      ),
                    ),
                    keyboardType: TextInputType.url,
                    autocorrect: false,
                  ),
                ),
                const SizedBox(height: 10),

                // ─── Status Indicator ────────────────────────────────
                if (devSettings.isOverridden)
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: theme.accentWarm,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          'Custom URL active — differs from default',
                          style: MirageTypography.bodySmall(
                            color: theme.accentWarm,
                          ),
                        ),
                      ),
                    ],
                  ),

                const SizedBox(height: 8),

                // ─── Default URL Reference ───────────────────────────
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: theme.primaryDark.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DEFAULT',
                        style: MirageTypography.labelSmall(
                          color: theme.textSecondary,
                        ).copyWith(letterSpacing: 2),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        devSettings.defaultBaseUrl,
                        style: GoogleFonts.spaceGrotesk(
                          fontSize: 12,
                          color: theme.textSecondary,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ─── Buttons ─────────────────────────────────────────
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton.icon(
                    onPressed: _onSave,
                    icon: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 200),
                      child: _saved
                          ? const Icon(Icons.check, key: ValueKey('check'))
                          : const Icon(Icons.save_outlined,
                              key: ValueKey('save')),
                    ),
                    label: Text(
                      _saved ? 'SAVED' : 'SAVE',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.accentWarm,
                      foregroundColor: theme.textOnDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: OutlinedButton.icon(
                    onPressed: _onReset,
                    icon: Icon(Icons.restore, color: theme.textSecondary),
                    label: Text(
                      'RESET TO DEFAULT',
                      style: GoogleFonts.manrope(
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: theme.textSecondary,
                      ),
                    ),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(
                        color: theme.textSecondary.withValues(alpha: 0.3),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // ─── Active Connection Info ──────────────────────────
                Text(
                  'ACTIVE CONNECTION',
                  style: MirageTypography.labelLarge(color: theme.textPrimary)
                      .copyWith(letterSpacing: 3),
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: theme.primaryDark,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _infoRow(theme, 'Base URL', devSettings.activeBaseUrl),
                      const SizedBox(height: 8),
                      _infoRow(
                        theme,
                        'Status',
                        devSettings.isOverridden ? 'Overridden' : 'Default',
                      ),
                      const SizedBox(height: 8),
                      _infoRow(theme, 'Build Mode',
                          kDebugMode ? 'Debug' : 'Release'),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _infoRow(dynamic theme, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 80,
          child: Text(
            label,
            style: MirageTypography.bodySmall(color: theme.textOnDark)
                .copyWith(fontWeight: FontWeight.w600),
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.spaceGrotesk(
              fontSize: 12,
              color: theme.textOnDark.withValues(alpha: 0.7),
            ),
          ),
        ),
      ],
    );
  }
}

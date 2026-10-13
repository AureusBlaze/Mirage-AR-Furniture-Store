import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';

/// Theme configuration screen — allows users to browse themes,
/// toggle dark/light mode, and cycle background images.
class ThemeConfigScreen extends StatelessWidget {
  const ThemeConfigScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final theme = themeProvider.currentTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      body: BackgroundLayer(
        child: SafeArea(
          child: Column(
            children: [
              _buildHeader(context, theme),
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                  children: [
                    // Dark mode toggle
                    _buildDarkModeToggle(context, themeProvider, theme),
                    const SizedBox(height: 24),

                    // Background cycler
                    _buildBackgroundCycler(context, themeProvider, theme),
                    const SizedBox(height: 24),

                    // Theme grid
                    Text(
                      'THEMES',
                      style: MirageTypography.labelLarge(color: theme.textOnDark)
                          .copyWith(letterSpacing: 4),
                    ),
                    const SizedBox(height: 16),
                    _buildThemeGrid(context, themeProvider, theme),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          BevelContainer(
            isCircular: true,
            backgroundColor: (theme.brightness == Brightness.dark ? theme.primaryDark : theme.surface).withValues(alpha: 0.7),
            padding: EdgeInsets.zero,
            child: IconButton(
              icon: Icon(Icons.close, color: theme.brightness == Brightness.dark ? theme.textOnDark : theme.textPrimary, size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'APPEARANCE',
            style: MirageTypography.labelLarge(color: theme.textOnDark)
                .copyWith(letterSpacing: 6),
          ),
        ],
      ),
    );
  }

  Widget _buildDarkModeToggle(
      BuildContext context, ThemeProvider provider, dynamic theme) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          decoration: BoxDecoration(
            color: theme.glassColor.withValues(alpha: theme.glassOpacity),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.glassBorder, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: theme.bevelHighlight,
                offset: const Offset(-1, -1),
                blurRadius: 2,
              ),
              BoxShadow(
                color: theme.bevelShadow,
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(
                    provider.isDarkMode
                        ? Icons.dark_mode
                        : Icons.light_mode,
                    color: theme.accent,
                    size: 22,
                  ),
                  const SizedBox(width: 12),
                  Text(
                    provider.isDarkMode ? 'DARK MODE' : 'LIGHT MODE',
                    style: MirageTypography.labelLarge(color: theme.textOnDark)
                        .copyWith(letterSpacing: 2),
                  ),
                ],
              ),
              Switch(
                value: provider.isDarkMode,
                onChanged: (_) => provider.toggleDarkMode(),
                activeColor: theme.accent,
                inactiveThumbColor: theme.surfaceVariant,
                inactiveTrackColor:
                    theme.surfaceVariant.withValues(alpha: 0.3),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBackgroundCycler(
      BuildContext context, ThemeProvider provider, dynamic theme) {
    final assets = theme.backgroundAssets as List<String>;
    final currentIndex = provider.currentBackgroundIndex;

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.glassColor.withValues(alpha: theme.glassOpacity),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: theme.glassBorder, width: 0.5),
            boxShadow: [
              BoxShadow(
                color: theme.bevelHighlight,
                offset: const Offset(-1, -1),
                blurRadius: 2,
              ),
              BoxShadow(
                color: theme.bevelShadow,
                offset: const Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'BACKGROUND',
                    style: MirageTypography.labelLarge(color: theme.textOnDark)
                        .copyWith(letterSpacing: 3),
                  ),
                  BevelContainer(
                    borderRadius: 12,
                    backgroundColor: theme.accent.withValues(alpha: 0.2),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    child: GestureDetector(
                      onTap: () => provider.cycleBackground(),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.swap_horiz,
                              color: theme.accent, size: 16),
                          const SizedBox(width: 4),
                          Text(
                            'CYCLE',
                            style: TextStyle(
                              color: theme.accent,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 60,
                child: Row(
                  children: List.generate(assets.length, (index) {
                    final isActive = index == currentIndex;
                    return Expanded(
                      child: GestureDetector(
                        onTap: () => provider.setBackgroundIndex(index),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color:
                                  isActive ? theme.accent : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              assets[index],
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildThemeGrid(
      BuildContext context, ThemeProvider provider, dynamic theme) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 1.3,
      ),
      itemCount: provider.availableThemes.length,
      itemBuilder: (_, index) {
        final t = provider.availableThemes[index];
        final isSelected = t.id == provider.currentTheme.id;

        return GestureDetector(
          onTap: () => provider.setTheme(t.id),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            decoration: BoxDecoration(
              color: t.primaryDark.withValues(alpha: isSelected ? 1.0 : 0.6),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isSelected ? t.accent : Colors.transparent,
                width: 2,
              ),
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: t.accent.withValues(alpha: 0.3),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: theme.bevelHighlight,
                        offset: const Offset(-1, -1),
                        blurRadius: 2,
                      ),
                      BoxShadow(
                        color: theme.bevelShadow,
                        offset: const Offset(1, 1),
                        blurRadius: 2,
                      ),
                    ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // Background preview
                  Image.asset(
                    t.backgroundAssets.first,
                    fit: BoxFit.cover,
                  ),
                  Container(
                    color: t.primaryDark.withValues(alpha: 0.6),
                  ),
                  // Content
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Color dots
                        Row(
                          children: [
                            _colorDot(t.primaryDark),
                            _colorDot(t.accentWarm),
                            _colorDot(t.accent),
                            _colorDot(t.surface),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          t.name,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: t.textOnDark,
                            letterSpacing: 1,
                          ),
                        ),
                        Text(
                          t.description,
                          style: TextStyle(
                            fontSize: 9,
                            color: t.textOnDark.withValues(alpha: 0.6),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  // Selected check
                  if (isSelected)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: t.accent,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.check,
                            size: 14, color: t.primaryDark),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _colorDot(Color color) {
    return Container(
      width: 10,
      height: 10,
      margin: const EdgeInsets.only(right: 3),
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.3),
          width: 0.5,
        ),
      ),
    );
  }
}

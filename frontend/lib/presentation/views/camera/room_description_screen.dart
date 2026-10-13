import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';
import 'package:mirage_by_aurues/presentation/widgets/animated_border.dart';
import 'package:mirage_by_aurues/presentation/widgets/glassmorphic_container.dart';

/// Premium screen displaying the AI-generated room analysis description.
class RoomDescriptionScreen extends StatelessWidget {
  final String description;

  const RoomDescriptionScreen({super.key, required this.description});

  @override
  Widget build(BuildContext context) {
    final theme = context.watch<ThemeProvider>().currentTheme;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 12),
          child: BevelContainer(
            isCircular: true,
            backgroundColor: (theme.brightness == Brightness.dark ? theme.primaryDark : theme.surface).withValues(alpha: 0.85),
            padding: EdgeInsets.zero,
            child: IconButton(
              icon: Icon(Icons.arrow_back,
                  color: theme.brightness == Brightness.dark
                      ? theme.textOnDark
                      : theme.textPrimary,
                  size: 20),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ),
        title: Text(
          'ROOM ANALYSIS',
          style: MirageTypography.labelLarge(
            color: theme.textOnDark,
          ).copyWith(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: BackgroundLayer(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 120,
            left: 20,
            right: 20,
            bottom: 40,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Section label
              Row(
                children: [
                  Icon(
                    Icons.auto_awesome,
                    size: 18,
                    color: theme.accent,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'AI ROOM DESCRIPTION',
                    style: MirageTypography.labelLarge(
                      color: theme.textOnDark,
                    ).copyWith(letterSpacing: 3),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Gold divider
              Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      theme.accent,
                      theme.accent.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Main description card
              AnimatedBorder(
                borderRadius: 20,
                borderWidth: 1.5,
                child: GlassmorphicContainer(
                  borderRadius: 18,
                  padding: const EdgeInsets.all(24),
                  child: Text(
                    description,
                    style: MirageTypography.bodyLarge(
                      color: theme.textOnDark,
                    ).copyWith(height: 1.8),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              // Footer attribution
              BevelContainer(
                borderRadius: 16,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: theme.accent.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.smart_toy_outlined,
                        size: 18,
                        color: theme.accent,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Analyzed by',
                            style: MirageTypography.caption(
                              color: theme.textOnDark.withValues(alpha: 0.5),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Mirage AI Engine',
                            style: MirageTypography.headingSmall(
                              color: theme.textOnDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

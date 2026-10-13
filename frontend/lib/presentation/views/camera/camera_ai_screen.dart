import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mirage_by_aurues/app/theme/theme_provider.dart';
import 'package:mirage_by_aurues/app/theme/mirage_typography.dart';
import 'package:mirage_by_aurues/presentation/viewmodels/camera_viewmodel.dart';
import 'package:mirage_by_aurues/presentation/widgets/product_card.dart';
import 'package:mirage_by_aurues/presentation/widgets/glassmorphic_container.dart';
import 'package:mirage_by_aurues/presentation/widgets/background_layer.dart';
import 'package:mirage_by_aurues/presentation/widgets/animated_border.dart';
import 'package:mirage_by_aurues/presentation/widgets/bevel_container.dart';

/// Camera AI screen — capture a room photo and get furniture suggestions.
/// Consistent bevels and padding, solid color buttons.
class CameraAiScreen extends StatelessWidget {
  const CameraAiScreen({super.key});

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
          'AI ROOM ANALYSIS',
          style: MirageTypography.labelLarge(
            color: theme.textOnDark,
          ).copyWith(letterSpacing: 4),
        ),
        centerTitle: true,
      ),
      body: BackgroundLayer(
        child: Consumer<CameraViewModel>(
          builder: (_, vm, __) {
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(
                  top: 100,
                  left: 20,
                  right: 20,
                  bottom: 40,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildImageSection(context, vm, theme),
                    const SizedBox(height: 20),
                    if (vm.capturedImage != null && !vm.isAnalyzing)
                      _buildActionButtons(vm, theme),
                    if (vm.isAnalyzing) _buildLoading(theme),
                    if (vm.error != null) _buildError(vm, theme),
                    if (vm.roomDescription != null && vm.suggestions.isNotEmpty)
                      _buildRoomAnalysisButton(context, vm, theme),
                    if (vm.suggestions.isNotEmpty)
                      _buildSuggestions(context, vm, theme),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildImageSection(
    BuildContext context,
    CameraViewModel vm,
    dynamic theme,
  ) {
    if (vm.capturedImage != null) {
      return AnimatedBorder(
        borderRadius: 20,
        borderWidth: 2.5,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: Image.file(
            vm.capturedImage!,
            height: 300,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      );
    }

    return AnimatedBorder(
      borderRadius: 20,
      borderWidth: 2,
      child: GestureDetector(
        onTap: () => _showCaptureOptions(context, vm),
        child: GlassmorphicContainer(
          height: 300,
          borderRadius: 18,
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.camera_alt_outlined,
                size: 64,
                color: theme.textOnDark.withValues(alpha: 0.5),
              ),
              const SizedBox(height: 16),
              Text(
                'CAPTURE YOUR ROOM',
                style: MirageTypography.labelLarge(color: theme.textOnDark),
              ),
              const SizedBox(height: 8),
              Text(
                'Take a photo of your room and our AI\nwill suggest matching furniture',
                textAlign: TextAlign.center,
                style: MirageTypography.bodySmall(
                  color: theme.textOnDark.withValues(alpha: 0.5),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showCaptureOptions(BuildContext context, CameraViewModel vm) {
    final theme = context.read<ThemeProvider>().currentTheme;
    showModalBottomSheet(
      context: context,
      backgroundColor: theme.primaryDark,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag indicator
              Container(
                width: 32,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: theme.surfaceVariant,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              // Camera option
              BevelContainer(
                borderRadius: 12,
                padding: EdgeInsets.zero,
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Icon(Icons.camera_alt, color: theme.accent),
                  title: Text(
                    'Camera',
                    style: TextStyle(color: theme.textOnDark),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    vm.captureFromCamera();
                  },
                ),
              ),
              // Gallery option
              BevelContainer(
                borderRadius: 12,
                padding: EdgeInsets.zero,
                child: ListTile(
                  leading: Icon(Icons.photo_library, color: theme.accent),
                  title: Text(
                    'Gallery',
                    style: TextStyle(color: theme.textOnDark),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    vm.pickFromGallery();
                  },
                ),
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(CameraViewModel vm, dynamic theme) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: vm.reset,
            icon: Icon(Icons.refresh, color: theme.textOnDark, size: 18),
            label: Text(
              'RETAKE',
              style: TextStyle(color: theme.textOnDark, letterSpacing: 1),
            ),
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: theme.accentWarm),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton.icon(
            onPressed: vm.analyzeRoom,
            icon: const Icon(Icons.auto_awesome, size: 18),
            label: const Text('ANALYZE ROOM'),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.accentWarm,
              foregroundColor: theme.textOnDark,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoading(dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          CircularProgressIndicator(color: theme.accent, strokeWidth: 2),
          const SizedBox(height: 16),
          Text(
            'Analyzing your room...',
            style: MirageTypography.bodyMedium(color: theme.textOnDark),
          ),
        ],
      ),
    );
  }

  Widget _buildError(CameraViewModel vm, dynamic theme) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: BevelContainer(
        borderRadius: 16,
        padding: const EdgeInsets.all(16),
        backgroundColor: theme.error.withValues(alpha: 0.15),
        child: Row(
          children: [
            Icon(Icons.error_outline, color: theme.error, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                vm.error!,
                style: TextStyle(color: theme.error, fontSize: 13),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRoomAnalysisButton(
    BuildContext context,
    CameraViewModel vm,
    dynamic theme,
  ) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 4),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () {
            Navigator.of(context).pushNamed(
              '/room-description',
              arguments: vm.roomDescription,
            );
          },
          icon: Icon(Icons.auto_awesome, size: 18, color: theme.accent),
          label: Text(
            'VIEW ROOM ANALYSIS',
            style: TextStyle(
              color: theme.accent,
              letterSpacing: 2,
              fontWeight: FontWeight.w600,
            ),
          ),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: theme.accent, width: 1.5),
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: theme.accent.withValues(alpha: 0.08),
          ),
        ),
      ),
    );
  }

  Widget _buildSuggestions(
    BuildContext context,
    CameraViewModel vm,
    dynamic theme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 24),
        Text(
          'SUGGESTED FURNITURE',
          style: MirageTypography.labelLarge(
            color: theme.textOnDark,
          ).copyWith(letterSpacing: 3),
        ),
        const SizedBox(height: 4),
        Text(
          '${vm.suggestions.length} items match your room',
          style: MirageTypography.bodySmall(
            color: theme.textOnDark.withValues(alpha: 0.5),
          ),
        ),
        const SizedBox(height: 16),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(vertical: 0),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 16,
            crossAxisSpacing: 16,
            childAspectRatio: 0.6,
          ),
          itemCount: vm.suggestions.length,
          itemBuilder: (_, index) {
            final product = vm.suggestions[index];
            return RepaintBoundary(
              child: ProductCard(
                product: product,
                onTap: () => Navigator.of(
                  context,
                ).pushNamed('/product', arguments: product.id),
              ),
            );
          },
        ),
      ],
    );
  }
}

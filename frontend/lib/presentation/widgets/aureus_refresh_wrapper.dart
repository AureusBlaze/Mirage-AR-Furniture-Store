import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

/// A globally reusable, luxurious pull-to-refresh wrapper.
/// Replaces the default Material RefreshIndicator with a sleek, 
/// highly-styled Cupertino sliver implementation aligned with the brand identity.
class AureusRefreshWrapper extends StatelessWidget {
  final Future<void> Function() onRefresh;
  final Widget? child;
  final List<Widget>? slivers;
  final ScrollController? controller;
  
  /// Set to true if the child passed is a Sliver widget (like SliverList or SliverGrid)
  final bool isSliver;

  const AureusRefreshWrapper({
    super.key,
    required this.onRefresh,
    this.child,
    this.slivers,
    this.controller,
    this.isSliver = false,
  }) : assert(child != null || slivers != null, 'Must provide either child or slivers');

  @override
  Widget build(BuildContext context) {
    // Access core aesthetics securely from your ThemeProvider context
    final theme = Theme.of(context);
    final primaryColor = theme.primaryColor;
    final backgroundColor = theme.scaffoldBackgroundColor;

    final refreshControl = CupertinoSliverRefreshControl(
      onRefresh: onRefresh,
      builder: (context, refreshState, pulledExtent, refreshTriggerPullDistance, refreshIndicatorExtent) {
        // Calculate a seamless progress ratio for microscopic animations
        final double percentage = (pulledExtent / refreshTriggerPullDistance).clamp(0.0, 1.0);
        
        return Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 24.0),
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: percentage > 0.1 ? 1.0 : 0.0,
              child: Transform.scale(
                scale: percentage,
                child: Container(
                  padding: const EdgeInsets.all(10.0),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04), // Subtle, high-end shadow
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                    border: Border.all(
                      color: primaryColor.withOpacity(0.08), // Barely visible border ring
                      width: 1.0,
                    ),
                  ),
                  child: CupertinoActivityIndicator(
                    color: primaryColor, // Utilizes brand theme seamlessly
                    radius: 12,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );

    return CustomScrollView(
      controller: controller,
      physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
      slivers: [
        refreshControl,
        if (slivers != null)
          ...slivers!
        else if (isSliver && child != null)
          child!
        else if (child != null)
          SliverToBoxAdapter(child: child!),
      ],
    );
  }
}

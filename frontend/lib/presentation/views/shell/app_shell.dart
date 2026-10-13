import 'package:flutter/material.dart';
import 'package:mirage_by_aurues/presentation/widgets/mirage_top_bar.dart';
import 'package:mirage_by_aurues/presentation/widgets/mirage_bottom_nav_bar.dart';
import 'package:mirage_by_aurues/presentation/views/home/home_screen.dart';
import 'package:mirage_by_aurues/presentation/views/catalog/catalog_screen.dart';
import 'package:mirage_by_aurues/presentation/views/ar/ar_list_screen.dart';
import 'package:mirage_by_aurues/presentation/views/profile/profile_screen.dart';
import 'package:mirage_by_aurues/presentation/widgets/aureus_navigation_guard.dart';

/// App Shell — hosts TopBar + BottomNav + body via IndexedStack.
/// Performance: Screens are created once in initState (not re-allocated per
/// build) and each is wrapped in RepaintBoundary to isolate GPU compositing.
class AppShell extends StatefulWidget {
  final int initialTab;

  const AppShell({super.key, this.initialTab = 0});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _currentIndex;

  /// Created once — not re-allocated on every build().
  /// Each screen is wrapped in RepaintBoundary to prevent background
  /// BackdropFilter re-compositing when the active tab changes or
  /// a ChangeNotifier fires a notification that touches the shell.
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialTab;
    _screens = const [
      RepaintBoundary(child: HomeScreen()),
      RepaintBoundary(child: CatalogScreen()),
      RepaintBoundary(child: ArListScreen()),
      RepaintBoundary(child: ProfileScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return AureusNavigationGuard(
      child: Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: MirageTopBar(
        onNavHubTap: () =>
            Navigator.of(context).pushReplacementNamed('/navigation'),
        onCartTap: () => Navigator.of(context).pushNamed('/cart'),
        onSearchTap: () => Navigator.of(context).pushNamed('/search'),
        onCameraTap: () => Navigator.of(context).pushNamed('/camera'),
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: MirageBottomNavBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
      ),
    ));
  }
}

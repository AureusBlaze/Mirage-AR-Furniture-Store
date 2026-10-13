import 'package:flutter/material.dart';

/// A wrapper to securely handle system back-swipes and hardware back buttons.
/// Prevents the application from forcefully terminating during navigation transitions
/// or when swiping back from a nested screen.
class AureusNavigationGuard extends StatelessWidget {
  final Widget child;
  
  const AureusNavigationGuard({
    super.key, 
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    // Check if the current native route has a history to pop.
    final ModalRoute<dynamic>? parentRoute = ModalRoute.of(context);
    final bool canPop = parentRoute?.canPop ?? false;

    return PopScope(
      // 'canPop' allows native iOS/Android gestures to run smoothly if there is a history stack.
      // If false, it intercepts the gesture to prevent sudden app termination.
      canPop: canPop,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (didPop) return;
        
        final navigator = Navigator.maybeOf(context);
        if (navigator != null) {
          if (navigator.canPop()) {
             navigator.pop(result);
          } else {
             // Push the circle navigation screen (hub) instead of closing the app
             navigator.pushReplacementNamed('/navigation');
          }
        }
      },
      // Ensure the rest of the gesture tree functions uninterrupted.
      child: child,
    );
  }
}

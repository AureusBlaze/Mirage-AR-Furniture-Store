import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shake/shake.dart';

/// Wraps a child widget with a global shake-gesture listener.
///
/// When a shake is detected (debug mode only), navigates to the
/// Developer Settings screen via the provided [navigatorKey].
///
/// The detector is started **after the first frame** to avoid
/// native sensor crashes during engine initialization. A 2-second
/// cooldown prevents rapid re-triggers.
class ShakeDetectorWrapper extends StatefulWidget {
  final Widget child;
  final GlobalKey<NavigatorState> navigatorKey;

  const ShakeDetectorWrapper({
    super.key,
    required this.child,
    required this.navigatorKey,
  });

  @override
  State<ShakeDetectorWrapper> createState() => _ShakeDetectorWrapperState();
}

class _ShakeDetectorWrapperState extends State<ShakeDetectorWrapper>
    with WidgetsBindingObserver {
  ShakeDetector? _detector;
  bool _cooldown = false;
  bool _isListening = false;

  @override
  void initState() {
    super.initState();
    if (!kDebugMode) return;

    WidgetsBinding.instance.addObserver(this);

    // Delay sensor start until after the first frame is fully rendered.
    // This prevents native crashes on some Android devices where the
    // sensor subsystem isn't ready during early engine initialization.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startListening();
    });
  }

  void _startListening() {
    if (_isListening || !mounted) return;
    try {
      _detector = ShakeDetector.waitForStart(
        onPhoneShake: (_) => _onShake(),
        shakeThresholdGravity: 2.5,
        minimumShakeCount: 2,
        shakeSlopTimeMS: 500,
      );
      _detector!.startListening();
      _isListening = true;
    } catch (e) {
      // Gracefully handle devices without an accelerometer
      // (e.g. emulators, tablets, or permissions issues).
      debugPrint('[DevSettings] Shake detection unavailable: $e');
      _isListening = false;
    }
  }

  void _stopListening() {
    if (!_isListening) return;
    try {
      _detector?.stopListening();
    } catch (_) {}
    _isListening = false;
  }

  /// Pause / resume the sensor when the app goes to background / foreground
  /// to save battery and avoid stale listeners.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!kDebugMode) return;
    switch (state) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopListening();
        break;
      case AppLifecycleState.resumed:
        _startListening();
        break;
      default:
        break;
    }
  }

  void _onShake() {
    if (_cooldown || !mounted) return;
    _cooldown = true;

    // Navigate to dev settings
    widget.navigatorKey.currentState?.pushNamed('/dev-settings');

    // 2-second cooldown to avoid rapid re-triggers
    Timer(const Duration(seconds: 2), () {
      if (mounted) _cooldown = false;
    });
  }

  @override
  void dispose() {
    _stopListening();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

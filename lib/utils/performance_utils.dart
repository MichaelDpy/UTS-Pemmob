import 'package:flutter/material.dart';

/// Utilities untuk performance optimization.
class PerformanceUtils {
  // ─── Widget Optimization ───────────────────────────────────────

  /// Wrapper untuk widget yang jarang berubah agar tidak rebuild
  static Widget buildOnce({
    required Widget Function() builder,
  }) {
    return _BuildOnceWidget(builder: builder);
  }

  /// Debounce function calls (berguna untuk search, text input, dll)
  static void Function() debounce(
    VoidCallback callback, {
    Duration delay = const Duration(milliseconds: 300),
  }) {
    DateTime? lastCallTime;
    
    return () {
      final now = DateTime.now();
      if (lastCallTime == null || 
          now.difference(lastCallTime!) > delay) {
        lastCallTime = now;
        callback();
      }
    };
  }

  /// Throttle function calls (maksimal sekali per duration)
  static VoidCallback throttle(
    VoidCallback callback, {
    Duration duration = const Duration(milliseconds: 300),
  }) {
    DateTime? lastCallTime;
    
    return () {
      final now = DateTime.now();
      if (lastCallTime == null || 
          now.difference(lastCallTime!) >= duration) {
        lastCallTime = now;
        callback();
      }
    };
  }

  // ─── Memory Management ─────────────────────────────────────────

  /// Clear image cache (berguna jika ada banyak images)
  static void clearImageCache() {
    PaintingBinding.instance.imageCache.clear();
    PaintingBinding.instance.imageCache.clearLiveImages();
  }

  /// Get current memory usage info
  static String getMemoryInfo() {
    final cache = PaintingBinding.instance.imageCache;
    return 'Image Cache: ${cache.currentSize} / ${cache.maximumSize}';
  }

  // ─── List Optimization ─────────────────────────────────────────

  /// Optimized ListView builder dengan caching
  static Widget optimizedListView({
    required int itemCount,
    required Widget Function(BuildContext, int) itemBuilder,
    ScrollPhysics? physics,
    EdgeInsets? padding,
  }) {
    return ListView.builder(
      itemCount: itemCount,
      itemBuilder: itemBuilder,
      physics: physics,
      padding: padding,
      // Performance optimizations
      cacheExtent: 500, // Cache 500px ahead
      addAutomaticKeepAlives: true,
      addRepaintBoundaries: true,
      addSemanticIndexes: true,
    );
  }

  // ─── Render Optimization ───────────────────────────────────────

  /// RepaintBoundary wrapper untuk isolasi repaint
  static Widget isolateRepaint({
    required Widget child,
  }) {
    return RepaintBoundary(
      child: child,
    );
  }

  /// Key generator untuk list items (stable keys)
  static Key generateKey(String prefix, dynamic id) {
    return ValueKey('${prefix}_$id');
  }
}

/// Widget yang hanya build sekali dan cache hasilnya
class _BuildOnceWidget extends StatefulWidget {
  final Widget Function() builder;

  const _BuildOnceWidget({required this.builder});

  @override
  State<_BuildOnceWidget> createState() => _BuildOnceWidgetState();
}

class _BuildOnceWidgetState extends State<_BuildOnceWidget> {
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedWidget = widget.builder();
  }

  @override
  Widget build(BuildContext context) {
    return _cachedWidget;
  }
}

/// Extension untuk BuildContext performance utilities
extension PerformanceExtension on BuildContext {
  /// Check if widget is mounted and safe to call setState
  bool get isMounted => mounted;
  
  /// Safe setState that checks if mounted
  void safeSetState(VoidCallback fn) {
    if (mounted) {
      // ignore: invalid_use_of_protected_member
      (this as State).setState(fn);
    }
  }
}

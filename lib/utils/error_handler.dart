import 'package:flutter/material.dart';

/// Error handler utility untuk aplikasi Quizify.
/// Menyediakan centralized error handling dan logging.
class ErrorHandler {
  // ─── Error Logging ─────────────────────────────────────────────

  /// Log error ke console (development)
  static void logError(
    String message, {
    Object? error,
    StackTrace? stackTrace,
  }) {
    debugPrint('❌ ERROR: $message');
    if (error != null) {
      debugPrint('   Error: $error');
    }
    if (stackTrace != null) {
      debugPrint('   Stack: $stackTrace');
    }
  }

  /// Log warning ke console
  static void logWarning(String message) {
    debugPrint('⚠️  WARNING: $message');
  }

  /// Log info ke console
  static void logInfo(String message) {
    debugPrint('ℹ️  INFO: $message');
  }

  // ─── Error Dialogs ─────────────────────────────────────────────

  /// Tampilkan error dialog kepada user
  static void showErrorDialog(
    BuildContext context, {
    required String title,
    required String message,
    VoidCallback? onRetry,
  }) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.error,
              size: 28,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  fontSize: 18,
                ),
              ),
            ),
          ],
        ),
        content: Text(
          message,
          style: TextStyle(
            fontFamily: 'Poppins',
            fontSize: 14,
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
            height: 1.5,
          ),
        ),
        actions: [
          if (onRetry != null)
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
                onRetry();
              },
              child: Text(
                'Coba Lagi',
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Theme.of(context).colorScheme.onPrimary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'OK',
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Tampilkan simple snackbar error
  static void showErrorSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              Icons.error_outline,
              color: Theme.of(context).colorScheme.onError,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w500,
                  color: Theme.of(context).colorScheme.onError,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Theme.of(context).colorScheme.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(16),
        duration: duration,
      ),
    );
  }

  // ─── Error Boundaries ──────────────────────────────────────────

  /// Wrap widget dengan error boundary
  static Widget errorBoundary({
    required Widget child,
    Widget? fallback,
  }) {
    return ErrorBoundaryWidget(
      fallback: fallback,
      child: child,
    );
  }

  // ─── Safe Operations ───────────────────────────────────────────

  /// Safely execute async operation dengan error handling
  static Future<T?> safeAsync<T>(
    Future<T> Function() operation, {
    String? errorMessage,
    Function(Object error)? onError,
  }) async {
    try {
      return await operation();
    } catch (e, stackTrace) {
      logError(
        errorMessage ?? 'Async operation failed',
        error: e,
        stackTrace: stackTrace,
      );
      onError?.call(e);
      return null;
    }
  }

  /// Safely execute sync operation dengan error handling
  static T? safeSync<T>(
    T Function() operation, {
    String? errorMessage,
    Function(Object error)? onError,
  }) {
    try {
      return operation();
    } catch (e, stackTrace) {
      logError(
        errorMessage ?? 'Sync operation failed',
        error: e,
        stackTrace: stackTrace,
      );
      onError?.call(e);
      return null;
    }
  }
}

/// Widget untuk error boundary
class ErrorBoundaryWidget extends StatefulWidget {
  final Widget child;
  final Widget? fallback;

  const ErrorBoundaryWidget({
    super.key,
    required this.child,
    this.fallback,
  });

  @override
  State<ErrorBoundaryWidget> createState() => _ErrorBoundaryWidgetState();
}

class _ErrorBoundaryWidgetState extends State<ErrorBoundaryWidget> {
  Object? _error;

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return widget.fallback ??
          Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.error_outline,
                    size: 64,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Terjadi Kesalahan',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Mohon restart aplikasi',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 14,
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                    ),
                  ),
                ],
              ),
            ),
          );
    }

    return widget.child;
  }
}

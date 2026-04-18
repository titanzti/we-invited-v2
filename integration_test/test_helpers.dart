import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Helper utilities for integration tests
class TestHelpers {
  TestHelpers._();

  /// Generate unique test email to avoid conflicts
  static String generateTestEmail() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'test_$timestamp@example.com';
  }

  /// Wait for a widget to appear with timeout
  static Future<bool> waitForWidget(
    WidgetTester tester,
    Finder finder, {
    Duration timeout = const Duration(seconds: 5),
    Duration pollInterval = const Duration(milliseconds: 100),
  }) async {
    final stopwatch = Stopwatch()..start();
    while (stopwatch.elapsed < timeout) {
      await tester.pump(pollInterval);
      if (finder.evaluate().isNotEmpty) {
        stopwatch.stop();
        return true;
      }
    }
    stopwatch.stop();
    return false;
  }

  /// Find widget by Key
  static Finder byKey(String key) {
    return find.byKey(ValueKey(key));
  }

  /// Safely tap a widget, only if it exists
  static Future<bool> safeTap(WidgetTester tester, Finder finder) async {
    if (finder.evaluate().isEmpty) return false;
    await tester.tap(finder);
    return true;
  }

  /// Scroll until widget is visible
  static Future<void> scrollUntilVisible(
    WidgetTester tester,
    Finder targetFinder,
    Finder scrollableFinder, {
    double step = 300,
    int maxAttempts = 20,
  }) async {
    for (int i = 0; i < maxAttempts; i++) {
      if (targetFinder.evaluate().isNotEmpty) return;
      await tester.drag(scrollableFinder, Offset(0, -step));
      await tester.pump(const Duration(milliseconds: 300));
    }
  }
}

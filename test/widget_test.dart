import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:laundrygo_flow/main.dart';

void main() {
  testWidgets('App boots to Splash and shows the LaundryGo wordmark', (WidgetTester tester) async {
    await tester.pumpWidget(const LaundryGoFlowApp());
    await tester.pump();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.text('LaundryGo'), findsOneWidget);

    // Drain the Splash sequence's Future.delayed timers (and its own
    // navigation) before the test ends, so none are left pending.
    await tester.pump(const Duration(milliseconds: 3200));
  });
}

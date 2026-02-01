// Widget tests for the Deflection Calculator app.

import 'package:flutter_test/flutter_test.dart';
import 'package:deflection_calculator/main.dart';

void main() {
  testWidgets('App loads and displays title', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const DeflectionCalculatorApp());

    // Wait for the widget to settle
    await tester.pumpAndSettle();

    // Verify that the app title is displayed
    expect(find.text('Deflection Calculator'), findsOneWidget);
  });
}

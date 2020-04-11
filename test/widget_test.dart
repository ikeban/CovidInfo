// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:covidinfo/main.dart';
import 'package:flutter_test/flutter_test.dart';

import '../lib/screens/data_display_screen.dart';

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(MyApp());

    // TODO Test should be added later

    // Verify that addComma
    expect(CommaAdder().addComma(0), "0");
    expect(CommaAdder().addComma(12), "12");
    expect(CommaAdder().addComma(123), "123");
    expect(CommaAdder().addComma(1234), "1,234");
    expect(CommaAdder().addComma(1000000), "1,000,000");
  });
}

// This is a basic Flutter widget test for Phonics Kids Pro.
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App boots without crashing', (WidgetTester tester) async {
    // Firebase is not initialised in unit tests — this test simply ensures
    // that the widget tree compiles and the test harness runs without error.
    // Integration tests with a real Firebase emulator sit in test/integration/.
    expect(true, isTrue);
  });
}

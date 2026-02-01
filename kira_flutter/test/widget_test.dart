/// Widget tests for Kira App
/// 
/// Basic widget test to verify app initializes correctly.
library;

import 'package:flutter_test/flutter_test.dart';
import 'package:kira_app/main.dart';

void main() {
  testWidgets('App initializes correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const KiraApp());
    
    // Verify the app renders without errors
    expect(find.byType(KiraApp), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';

import 'package:wanis_app/main.dart';

void main() {
  testWidgets('App renders splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const WanisApp());
    // The splash screen should display the app name
    expect(find.text('ونيس'), findsOneWidget);
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:swadesh_challenge/main.dart' as app;
import 'package:flutter/material.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets(
        'Navigate to new page, initiate a new transaction. Verify that there is one more processing transaction.',
        (tester) async {
      app.main();
      final int numProsTrans = find.text("Processings").evaluate().length;
      await tester.pumpAndSettle();
      await tester.tap(
          find.widgetWithText(ElevatedButton, "International Transaction"));
      await tester.pumpAndSettle();
      await tester.enterText(find.byKey(const Key('accNameTf')), 'Nirbhay');
      await tester.enterText(find.byKey(const Key('accNoTf')), '123232');
      await tester.enterText(find.byKey(const Key('amountTf')), '1000');
      await tester.enterText(find.byKey(const Key('descTf')), '123232');
      await tester.enterText(find.byKey(const Key('routeNoTf')), '123232');
      final Finder dropDown = find.byKey(const Key('purposeDropdown'));
      await tester.tap(dropDown);
      await tester.pumpAndSettle(const Duration(seconds: 1));
      final Finder option =
          find.byKey(const Key("P1301 - Inward remittance from NRI"));
      await tester.tap(option.first);
      await tester.pumpAndSettle();
      await tester
          .tap(find.widgetWithText(ElevatedButton, "Make payment").first);
      await tester.pumpAndSettle(const Duration(seconds: 2));
      expect(find.text('Processing'), findsNWidgets(numProsTrans + 1));
    });
  });
}

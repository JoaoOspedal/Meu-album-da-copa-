import 'package:flutter_test/flutter_test.dart';

import 'package:meu_album_da_copa/main.dart';

void main() {
  testWidgets('Home screen shows the country grid', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();

    expect(find.text('Brasil'), findsOneWidget);
    expect(find.text('Argentina'), findsOneWidget);
  });

  testWidgets('Tapping a country expands its sticker album', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const RootApp());
    await tester.pumpAndSettle();

    expect(find.text('Alisson'), findsNothing);

    await tester.tap(find.text('Brasil'));
    await tester.pumpAndSettle();

    expect(find.text('Alisson'), findsOneWidget);
  });
}

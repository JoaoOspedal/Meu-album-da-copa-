import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:meu_album_da_copa/main.dart';

void main() {
  testWidgets('shows the login screen when there is no saved session', (
    WidgetTester tester,
  ) async {
    // Sem token salvo -> o app deve cair na tela de login (sem tocar a rede).
    SharedPreferences.setMockInitialValues({});

    await tester.pumpWidget(const RootApp());

    // Deixa o auto-login (assíncrono) resolver para "não autenticado".
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 200));

    // "Entrar" aparece no título e no botão da tela de login.
    expect(find.text('Entrar'), findsWidgets);
  });
}

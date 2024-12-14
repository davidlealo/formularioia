import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:formularioia/main.dart';

void main() {
  testWidgets('Check ChatFormScreen UI elements', (WidgetTester tester) async {
    // Construye la app y espera a que se renderice.
    await tester.pumpWidget(MyApp());

    // Verifica que el título del AppBar está presente.
    expect(find.text('Chat & Form'), findsOneWidget);

    // Verifica que hay un campo de texto para mensajes en el chat.
    expect(find.byType(TextField), findsWidgets); // Hay varios TextField

    // Verifica que el botón de enviar mensaje está presente.
    expect(find.byIcon(Icons.send), findsOneWidget);

    // Verifica que el formulario también está presente.
    expect(find.byType(ListView), findsOneWidget);
  });
}

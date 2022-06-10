import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:integration_test/integration_test.dart';

import 'package:gps_routes/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('end-to-end test', () {
    testWidgets('teste widgets', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle();
      await Future.delayed(const Duration(seconds: 10));

      final Finder appBar = find.byType(AppBar);
      expect(appBar, findsOneWidget);

      final Finder textGps = find.text('GPS');
      expect(textGps, findsOneWidget);

      final Finder googleMap = find.byType(GoogleMap);
      expect(googleMap, findsOneWidget);

      final Finder buttonIniciar = find.byType(ElevatedButton);
      expect(buttonIniciar, findsOneWidget);

      final Finder textIniciar = find.text('Iniciar');
      expect(textIniciar, findsOneWidget);

      final Finder buttonOn = find.byType(ElevatedButton);
      await tester.tap(buttonOn);
      await Future.delayed(const Duration(seconds: 10));
      final Finder buttonOff = find.byType(ElevatedButton);
      await tester.tap(buttonOff);
      await Future.delayed(const Duration(seconds: 2));
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:radar_sismico_ecuador/logic/sismo_logic.dart';
import 'package:radar_sismico_ecuador/models/sismo.dart';
import 'package:radar_sismico_ecuador/screens/lista_sismos_screen.dart';

void main() {
  testWidgets('la lista filtra por magnitud y abre el detalle', (tester) async {
    final sismoFuerte = SismoConDistancia(
      sismo: Sismo(
        id: 'evento-fuerte',
        magnitud: 5.2,
        lugar: 'Costa de Ecuador',
        fecha: DateTime(2026, 11, 10, 8),
        latitud: -1.5,
        longitud: -80.0,
        profundidadKm: 20,
        urlDetalle: 'https://earthquake.usgs.gov/earthquakes/eventpage/test',
      ),
      distanciaKm: 80,
    );
    final sismoLeve = SismoConDistancia(
      sismo: Sismo(
        id: 'evento-leve',
        magnitud: 3.2,
        lugar: 'Sierra de Ecuador',
        fecha: DateTime(2026, 11, 9, 14),
        latitud: -0.5,
        longitud: -78.0,
        profundidadKm: 10,
        urlDetalle: 'https://earthquake.usgs.gov/earthquakes/eventpage/test2',
      ),
      distanciaKm: 50,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: ListaSismosScreen(
          futuroSismos: Future.value([sismoFuerte, sismoLeve]),
          onReintentar: () {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Costa de Ecuador'), findsOneWidget);
    expect(find.text('Sierra de Ecuador'), findsOneWidget);

    await tester.tap(find.byType(DropdownButtonFormField<double>));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Magnitud ≥ 4.0').last);
    await tester.pumpAndSettle();

    expect(find.text('Costa de Ecuador'), findsOneWidget);
    expect(find.text('Sierra de Ecuador'), findsNothing);

    await tester.tap(find.text('Costa de Ecuador'));
    await tester.pumpAndSettle();

    expect(find.text('Detalle del sismo'), findsOneWidget);
    expect(find.text('Recomendación de seguridad'), findsOneWidget);
  });
}

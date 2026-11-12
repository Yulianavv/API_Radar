import 'package:flutter_test/flutter_test.dart';
import 'package:radar_sismico_ecuador/logic/alerta_sismo.dart';

void main() {
  group('calcularAlerta', () {
    test('magnitud menor a 3 aunque esté muy cerca es imperceptible', () {
      final alerta = calcularAlerta(2.6, 15);

      expect(alerta.nivel, NivelAlerta.imperceptible);
      expect(alerta.titulo, isNotEmpty);
      expect(alerta.recomendacion, isNotEmpty);
    });

    test('distancia muy grande (>= 500 km) es imperceptible', () {
      final alerta = calcularAlerta(5.4, 520);

      expect(alerta.nivel, NivelAlerta.imperceptible);
    });

    test('magnitud entre 3.0 y 4.5 cercana es leve', () {
      final alerta = calcularAlerta(3.8, 60);

      expect(alerta.nivel, NivelAlerta.leve);
    });

    test('sismo grande (>= 6.0) pero lejano (300-499 km) se atenúa a leve', () {
      final alerta = calcularAlerta(6.2, 400);

      expect(alerta.nivel, NivelAlerta.leve);
    });

    test('magnitud entre 4.5 y 6.0 cercana es moderada', () {
      final alerta = calcularAlerta(4.8, 50);

      expect(alerta.nivel, NivelAlerta.moderada);
    });

    test('magnitud >= 5.0 a menos de 100 km es alta', () {
      final alerta = calcularAlerta(5.2, 80);

      expect(alerta.nivel, NivelAlerta.alta);
    });

    test('magnitud >= 6.0 dentro del rango regional es alta', () {
      final alerta = calcularAlerta(6.4, 180);

      expect(alerta.nivel, NivelAlerta.alta);
    });
  });
}


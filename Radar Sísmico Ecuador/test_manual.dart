// ignore_for_file: avoid_print

import 'package:radar_sismico_ecuador/errors/app_exception.dart';
import 'package:radar_sismico_ecuador/logic/sismo_logic.dart';
import 'package:radar_sismico_ecuador/services/usgs_service.dart';
import 'package:radar_sismico_ecuador/utils/distancia.dart';

/// Archivo temporal de prueba en consola para verificar UsgsService sin interfaz gráfica.
/// Ejecutar desde la raíz del proyecto con: dart run test_manual.dart
Future<void> main() async {
  final servicio = UsgsService();
  final logica = SismoLogic();

  print('Consultando sismos recientes en Ecuador (USGS)...');

  try {
    final sismos = await servicio.obtenerSismos();
    final recientes = sismos.take(5).toList();

    print('Total encontrados: ${sismos.length}');
    print('Mostrando los ${recientes.length} más recientes:\n');

    for (var i = 0; i < recientes.length; i++) {
      final sismo = recientes[i];
      final magTexto =
          sismo.magnitud != null ? sismo.magnitud!.toStringAsFixed(1) : 'N/A';

      print('${i + 1}. [$magTexto] ${sismo.lugar}');
      print('   Fecha: ${sismo.fecha}');
      print(
        '   Coords: (${sismo.latitud}, ${sismo.longitud}) | Prof: ${sismo.profundidadKm} km',
      );
      print('   ID: ${sismo.id} | URL: ${sismo.urlDetalle}\n');
    }

    // Prueba de cercanía usando Quito (-0.1807, -78.4678) como punto por defecto.
    final cercanos = logica
        .ordenarPorCercania(sismos, latitudQuito, longitudQuito)
        .take(5)
        .toList();

    print('--- Los ${cercanos.length} más cercanos a Quito ---\n');
    for (var i = 0; i < cercanos.length; i++) {
      final item = cercanos[i];
      final magTexto = item.sismo.magnitud != null
          ? item.sismo.magnitud!.toStringAsFixed(1)
          : 'N/A';
      print(
        '${i + 1}. [${item.distanciaKm.toStringAsFixed(1)} km] '
        '[$magTexto] ${item.sismo.lugar}',
      );
    }
  } on AppException catch (e) {
    print('Error controlado: ${e.mensaje}');
  } catch (e) {
    print('Error inesperado: $e');
  }
}


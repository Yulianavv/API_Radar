import '../models/sismo.dart';
import '../utils/distancia.dart';

/// Agrupa un [Sismo] junto con su distancia en kilómetros respecto al usuario.
class SismoConDistancia {
  final Sismo sismo;
  final double distanciaKm;

  const SismoConDistancia({
    required this.sismo,
    required this.distanciaKm,
  });
}

/// Lógica de negocio para procesar y ordenar los sismos obtenidos del servicio.
class SismoLogic {
  /// Calcula la distancia de cada sismo respecto al usuario y los ordena
  /// del más cercano al más lejano.
  ///
  /// Si no se envían coordenadas, usa Quito (-0.1807, -78.4678) por defecto.
  List<SismoConDistancia> ordenarPorCercania(
    List<Sismo> sismos, [
    double latUsuario = latitudQuito,
    double lonUsuario = longitudQuito,
  ]) {
    final resultado = sismos.map((sismo) {
      return SismoConDistancia(
        sismo: sismo,
        distanciaKm: sismo.distanciaDesde(latUsuario, lonUsuario),
      );
    }).toList();

    resultado.sort((a, b) => a.distanciaKm.compareTo(b.distanciaKm));
    return resultado;
  }
}


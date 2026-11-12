import '../utils/distancia.dart';

/// Modelo que representa un evento sísmico obtenido de la API GeoJSON del USGS.
class Sismo {
  /// Identificador único del sismo asignado por el USGS.
  final String id;

  /// Magnitud del sismo (puede ser null si el USGS aún no la calcula).
  final double? magnitud;

  /// Descripción del lugar cercano al epicentro.
  final String lugar;

  /// Fecha y hora del evento sísmico en hora local.
  final DateTime fecha;

  /// Latitud del epicentro en grados decimales.
  final double latitud;

  /// Longitud del epicentro en grados decimales.
  final double longitud;

  /// Profundidad del hipocentro en kilómetros.
  final double profundidadKm;

  /// Enlace web a la ficha oficial del evento en el USGS.
  final String urlDetalle;

  const Sismo({
    required this.id,
    required this.magnitud,
    required this.lugar,
    required this.fecha,
    required this.latitud,
    required this.longitud,
    required this.profundidadKm,
    required this.urlDetalle,
  });

  /// Construye un [Sismo] a partir de un objeto "Feature" del GeoJSON del USGS.
  factory Sismo.fromGeoJson(Map feature) {
    // Extraemos de forma segura los mapas internos por si vienen nulos o con otro tipo.
    final properties =
        feature['properties'] is Map ? feature['properties'] as Map : const {};
    final geometry =
        feature['geometry'] is Map ? feature['geometry'] as Map : const {};
    final coordinates =
        geometry['coordinates'] is List ? geometry['coordinates'] as List : const [];

    // La magnitud puede llegar como null, int o double; la convertimos de forma segura.
    final magRaw = properties['mag'];
    final double? magnitud = magRaw is num ? magRaw.toDouble() : null;

    // El USGS envía 'time' en milisegundos desde epoch (UTC); lo pasamos a DateTime local.
    final timeRaw = properties['time'];
    final DateTime fecha = timeRaw is num
        ? DateTime.fromMillisecondsSinceEpoch(timeRaw.toInt())
        : DateTime.fromMillisecondsSinceEpoch(0);

    return Sismo(
      id: feature['id']?.toString() ?? '',
      magnitud: magnitud,
      lugar: properties['place']?.toString() ?? 'Ubicación desconocida',
      fecha: fecha,
      // En GeoJSON el orden de coordenadas es [longitud, latitud, profundidad].
      longitud: _leerCoordenada(coordinates, 0),
      latitud: _leerCoordenada(coordinates, 1),
      profundidadKm: _leerCoordenada(coordinates, 2),
      urlDetalle: properties['url']?.toString() ?? '',
    );
  }

  /// Lee una coordenada numérica de la lista evitando errores si falta o es null.
  static double _leerCoordenada(List coords, int indice) {
    if (indice >= coords.length) return 0.0;
    final valor = coords[indice];
    return valor is num ? valor.toDouble() : 0.0;
  }

  /// Calcula la distancia en kilómetros desde la ubicación del usuario hasta este sismo.
  /// Por defecto usa Quito (-0.1807, -78.4678) para pruebas.
  double distanciaDesde([
    double latUsuario = latitudQuito,
    double lonUsuario = longitudQuito,
  ]) {
    return distanciaKm(latUsuario, lonUsuario, latitud, longitud);
  }

  @override
  String toString() {
    return 'Sismo(id: $id, magnitud: $magnitud, lugar: $lugar, fecha: $fecha)';
  }
}


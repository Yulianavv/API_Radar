import 'dart:math';

/// Coordenadas de Quito usadas como punto de referencia por defecto para pruebas.
const double latitudQuito = -0.1807;
const double longitudQuito = -78.4678;

/// Calcula la distancia en kilómetros entre dos coordenadas geográficas
/// usando la fórmula de Haversine (distancia sobre la superficie esférica de la Tierra).
double distanciaKm(double lat1, double lon1, double lat2, double lon2) {
  const double radioTierraKm = 6371.0;

  // Convertimos las diferencias de latitud y longitud de grados a radianes.
  final double dLat = _aRadianes(lat2 - lat1);
  final double dLon = _aRadianes(lon2 - lon1);

  final double lat1Rad = _aRadianes(lat1);
  final double lat2Rad = _aRadianes(lat2);

  // Fórmula de Haversine: calcula el ángulo central entre ambos puntos.
  final double a = sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1Rad) * cos(lat2Rad) * sin(dLon / 2) * sin(dLon / 2);

  // Limitamos entre 0 y 1 para evitar errores de redondeo en puntos opuestos.
  final double aSegura = a.clamp(0.0, 1.0);
  final double c = 2 * atan2(sqrt(aSegura), sqrt(1 - aSegura));

  return radioTierraKm * c;
}

/// Convierte un ángulo de grados decimales a radianes.
double _aRadianes(double grados) => grados * (pi / 180.0);


import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../errors/app_exception.dart';
import '../models/sismo.dart';

/// Servicio encargado de consultar los eventos sísmicos en la API GeoJSON del USGS.
class UsgsService {
  static const String _host = 'earthquake.usgs.gov';
  static const String _ruta = '/fdsnws/event/1/query';
  static const Duration _timeout = Duration(seconds: 10);

  /// Obtiene la lista de sismos filtrados por magnitud, rango de días y zona geográfica.
  ///
  /// Por defecto consulta los últimos 7 días en un radio de 600 km alrededor de Ecuador.
  Future<List<Sismo>> obtenerSismos({
    double minMagnitud = 2.5,
    int dias = 7,
    double latitud = -1.83,
    double longitud = -78.18,
    double radioKm = 600,
    int limite = 200,
  }) async {
    // Calculamos el rango de fechas en UTC para evitar problemas de zona horaria en la URL.
    final ahora = DateTime.now().toUtc();
    final inicio = ahora.subtract(Duration(days: dias));

    final uri = Uri.https(_host, _ruta, {
      'format': 'geojson',
      'starttime': inicio.toIso8601String(),
      'endtime': ahora.toIso8601String(),
      'minmagnitude': minMagnitud.toString(),
      'latitude': latitud.toString(),
      'longitude': longitud.toString(),
      'maxradiuskm': radioKm.toString(),
      'orderby': 'time',
      'limit': limite.toString(),
    });

    try {
      final response = await http.get(uri).timeout(_timeout);

      // Si el servidor no responde 200 OK, lanzamos ErrorServidorException.
      if (response.statusCode != 200) {
        throw ErrorServidorException(
          'El servidor del USGS respondió con código ${response.statusCode}.',
        );
      }

      // Decodificamos en UTF-8 para conservar tildes y caracteres especiales en 'place'.
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      if (data is! Map) {
        throw const ErrorServidorException(
          'La respuesta del servidor no tiene el formato esperado.',
        );
      }

      final features = data['features'];
      if (features is! List || features.isEmpty) {
        throw const SinResultadosException();
      }

      final sismos = features
          .whereType<Map>()
          .map((feature) => Sismo.fromGeoJson(feature))
          .toList();

      if (sismos.isEmpty) {
        throw const SinResultadosException();
      }

      return sismos;
    } on SocketException {
      throw const SinInternetException();
    } on TimeoutException {
      throw const SinInternetException(
        'La conexión tardó demasiado (más de 10 segundos). Revisa tu internet.',
      );
    } on http.ClientException {
      throw const SinInternetException(
        'No se pudo establecer conexión con el servicio del USGS.',
      );
    } on FormatException {
      throw const ErrorServidorException(
        'No se pudo leer la respuesta JSON del servidor.',
      );
    }
  }
}


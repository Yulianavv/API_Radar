/// Excepción base para los errores controlados de la aplicación.
class AppException implements Exception {
  /// Mensaje legible que describe el error ocurrido.
  final String mensaje;

  const AppException(this.mensaje);

  @override
  String toString() => mensaje;
}

/// Se lanza cuando no hay conexión a internet o la red falla al conectar.
class SinInternetException extends AppException {
  const SinInternetException([
    super.mensaje = 'No hay conexión a internet. Verifica tu red e intenta de nuevo.',
  ]);
}

/// Se lanza cuando la API del USGS responde con un código de estado distinto de 200
/// o devuelve una respuesta inválida.
class ErrorServidorException extends AppException {
  const ErrorServidorException([
    super.mensaje = 'El servidor del USGS devolvió un error. Intenta más tarde.',
  ]);
}

/// Se lanza cuando la consulta fue exitosa pero no se encontraron sismos.
class SinResultadosException extends AppException {
  const SinResultadosException([
    super.mensaje = 'No se encontraron sismos con los filtros seleccionados.',
  ]);
}


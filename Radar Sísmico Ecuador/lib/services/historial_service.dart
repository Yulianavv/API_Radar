import 'package:shared_preferences/shared_preferences.dart';

/// Servicio para persistir localmente los IDs de sismos que el usuario ya consultó.
class HistorialService {
  static const String _claveSismosVistos = 'sismos_vistos';

  /// Marca un sismo como visto guardando su [idSismo] en almacenamiento local.
  Future<void> marcarVisto(String idSismo) async {
    if (idSismo.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final vistos = await obtenerVistos();

    // Solo guardamos en disco si el ID no estaba registrado previamente.
    if (vistos.add(idSismo)) {
      await prefs.setStringList(_claveSismosVistos, vistos.toList());
    }
  }

  /// Indica si el sismo con [idSismo] ya fue visto anteriormente.
  Future<bool> fueVisto(String idSismo) async {
    if (idSismo.isEmpty) return false;
    final vistos = await obtenerVistos();
    return vistos.contains(idSismo);
  }

  /// Devuelve el conjunto de todos los IDs de sismos marcados como vistos.
  Future<Set<String>> obtenerVistos() async {
    final prefs = await SharedPreferences.getInstance();
    final lista = prefs.getStringList(_claveSismosVistos) ?? const <String>[];
    return lista.toSet();
  }

  /// Elimina todo el historial de sismos vistos.
  Future<void> limpiarHistorial() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_claveSismosVistos);
  }
}


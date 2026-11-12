import 'package:flutter/material.dart';

import '../errors/app_exception.dart';
import '../logic/sismo_logic.dart';

/// Presenta los estados de carga y error de una consulta compartida de sismos.
class EstadoSismos extends StatelessWidget {
  final Future<List<SismoConDistancia>> futuro;
  final Widget Function(
    BuildContext context,
    List<SismoConDistancia> sismos,
  ) contenido;
  final VoidCallback onReintentar;

  const EstadoSismos({
    super.key,
    required this.futuro,
    required this.contenido,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<SismoConDistancia>>(
      future: futuro,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircularProgressIndicator(),
                SizedBox(height: 12),
                Text('Cargando sismos...'),
              ],
            ),
          );
        }

        if (snapshot.hasError) {
          final error = snapshot.error;
          final mensaje = error is AppException
              ? error.mensaje
              : 'No se pudieron cargar los sismos. Intenta de nuevo.';
          return _EstadoError(
            mensaje: mensaje,
            onReintentar: onReintentar,
          );
        }

        final sismos = snapshot.data;
        if (sismos == null) {
          return _EstadoError(
            mensaje: 'La consulta no devolvió datos.',
            onReintentar: onReintentar,
          );
        }

        return contenido(context, sismos);
      },
    );
  }
}

class _EstadoError extends StatelessWidget {
  final String mensaje;
  final VoidCallback onReintentar;

  const _EstadoError({
    required this.mensaje,
    required this.onReintentar,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.cloud_off_outlined, size: 48),
            const SizedBox(height: 12),
            Text(mensaje, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: onReintentar,
              icon: const Icon(Icons.refresh),
              label: const Text('Reintentar'),
            ),
          ],
        ),
      ),
    );
  }
}

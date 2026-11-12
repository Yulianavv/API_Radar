import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../logic/alerta_sismo.dart';
import '../logic/sismo_logic.dart';
import '../widgets/colores_alerta.dart';

/// Muestra todos los datos disponibles y la recomendación para un sismo.
class DetalleSismoScreen extends StatelessWidget {
  final SismoConDistancia sismoConDistancia;

  const DetalleSismoScreen({
    super.key,
    required this.sismoConDistancia,
  });

  @override
  Widget build(BuildContext context) {
    final sismo = sismoConDistancia.sismo;
    final magnitud = sismo.magnitud;
    final alerta = magnitud == null
        ? null
        : calcularAlerta(magnitud, sismoConDistancia.distanciaKm);
    final tieneUrl = _urlValida(sismo.urlDetalle);

    return Scaffold(
      appBar: AppBar(title: const Text('Detalle del sismo')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    magnitud == null
                        ? 'Magnitud no disponible'
                        : 'Magnitud ${magnitud.toStringAsFixed(1)}',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    sismo.lugar,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (alerta != null) ...[
                    const SizedBox(height: 12),
                    Chip(
                      label: Text(alerta.titulo),
                      backgroundColor: colorDeAlerta(alerta.nivel),
                    ),
                  ],
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _FilaDetalle(
                    icono: Icons.schedule,
                    etiqueta: 'Fecha y hora',
                    valor: _formatearFecha(sismo.fecha),
                  ),
                  _FilaDetalle(
                    icono: Icons.place_outlined,
                    etiqueta: 'Distancia desde Quito',
                    valor:
                        '${sismoConDistancia.distanciaKm.toStringAsFixed(1)} km',
                  ),
                  _FilaDetalle(
                    icono: Icons.public,
                    etiqueta: 'Coordenadas',
                    valor:
                        '${sismo.latitud.toStringAsFixed(4)}, ${sismo.longitud.toStringAsFixed(4)}',
                  ),
                  _FilaDetalle(
                    icono: Icons.arrow_downward,
                    etiqueta: 'Profundidad',
                    valor: '${sismo.profundidadKm.toStringAsFixed(1)} km',
                  ),
                  _FilaDetalle(
                    icono: Icons.fingerprint,
                    etiqueta: 'ID USGS',
                    valor: sismo.id.isEmpty ? 'No disponible' : sismo.id,
                    ultimo: true,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Recomendación de seguridad',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    alerta?.recomendacion ??
                        'No hay magnitud disponible para calcular una recomendación.',
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: tieneUrl ? () => _abrirUrl(context) : null,
            icon: const Icon(Icons.open_in_new),
            label: Text(
              tieneUrl
                  ? 'Abrir ficha oficial del USGS'
                  : 'Enlace no disponible',
            ),
          ),
        ],
      ),
    );
  }

  bool _urlValida(String valor) {
    final uri = Uri.tryParse(valor);
    return uri != null &&
        (uri.scheme == 'https' || uri.scheme == 'http') &&
        uri.host.isNotEmpty;
  }

  Future<void> _abrirUrl(BuildContext context) async {
    final uri = Uri.tryParse(sismoConDistancia.sismo.urlDetalle);
    if (uri == null || !_urlValida(uri.toString())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('El enlace del USGS no es válido.')),
      );
      return;
    }

    final abierto = await launchUrl(uri, mode: LaunchMode.externalApplication);
    if (!context.mounted) return;
    if (!abierto) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo abrir la ficha del USGS.')),
      );
    }
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');
    return '$dia/$mes/${fecha.year} $hora:$minuto';
  }
}

class _FilaDetalle extends StatelessWidget {
  final IconData icono;
  final String etiqueta;
  final String valor;
  final bool ultimo;

  const _FilaDetalle({
    required this.icono,
    required this.etiqueta,
    required this.valor,
    this.ultimo = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: ultimo ? 0 : 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icono, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(etiqueta, style: Theme.of(context).textTheme.bodySmall),
                const SizedBox(height: 2),
                SelectableText(valor),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../logic/alerta_sismo.dart';
import '../logic/sismo_logic.dart';
import 'colores_alerta.dart';

/// Tarjeta que resume los datos principales de un sismo.
class TarjetaSismo extends StatelessWidget {
  final SismoConDistancia sismoConDistancia;

  const TarjetaSismo({
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

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              magnitud == null
                  ? 'Magnitud no disponible'
                  : 'Magnitud ${magnitud.toStringAsFixed(1)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              sismo.lugar,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            if (alerta != null)
              Chip(
                label: Text(alerta.titulo),
                backgroundColor: colorDeAlerta(alerta.nivel),
                visualDensity: VisualDensity.compact,
              )
            else
              const Chip(
                label: Text('Sin datos para calcular alerta'),
                visualDensity: VisualDensity.compact,
              ),
            const SizedBox(height: 4),
            Wrap(
              spacing: 16,
              runSpacing: 8,
              children: [
                _DatoSismo(
                  icono: Icons.schedule,
                  texto: _formatearFecha(sismo.fecha),
                ),
                _DatoSismo(
                  icono: Icons.place_outlined,
                  texto:
                      '${sismoConDistancia.distanciaKm.toStringAsFixed(1)} km',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(DateTime fecha) {
    final dia = fecha.day.toString().padLeft(2, '0');
    final mes = fecha.month.toString().padLeft(2, '0');
    final hora = fecha.hour.toString().padLeft(2, '0');
    final minuto = fecha.minute.toString().padLeft(2, '0');

    return '$dia/$mes/${fecha.year} $hora:$minuto';
  }
}

class _DatoSismo extends StatelessWidget {
  final IconData icono;
  final String texto;

  const _DatoSismo({
    required this.icono,
    required this.texto,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icono, size: 16),
        const SizedBox(width: 4),
        Text(texto, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}

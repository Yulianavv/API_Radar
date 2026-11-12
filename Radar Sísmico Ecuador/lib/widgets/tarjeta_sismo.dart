import 'package:flutter/material.dart';

import '../logic/alerta_sismo.dart';
import '../logic/sismo_logic.dart';
import 'colores_alerta.dart';

/// Tarjeta que resume los datos principales de un sismo.
class TarjetaSismo extends StatelessWidget {
  final SismoConDistancia sismoConDistancia;
  final VoidCallback? onTap;

  const TarjetaSismo({
    super.key,
    required this.sismoConDistancia,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final sismo = sismoConDistancia.sismo;
    final magnitud = sismo.magnitud;
    final alerta = magnitud == null
        ? null
        : calcularAlerta(magnitud, sismoConDistancia.distanciaKm);
    final esquema = Theme.of(context).colorScheme;
    final colorMagnitud = alerta == null
        ? esquema.secondaryContainer
        : colorDeAlerta(alerta.nivel);

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 62,
                    height: 62,
                    decoration: BoxDecoration(
                      color: colorMagnitud,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'MAG',
                          style:
                              Theme.of(context).textTheme.labelSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                        ),
                        Text(
                          magnitud?.toStringAsFixed(1) ?? 'N/D',
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          sismo.lugar,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
                        ),
                        const SizedBox(height: 6),
                        if (alerta != null)
                          Chip(
                            avatar: const Icon(Icons.circle, size: 10),
                            label: Text(alerta.titulo),
                            backgroundColor: colorMagnitud,
                            visualDensity: VisualDensity.compact,
                            side: BorderSide.none,
                            labelStyle: Theme.of(context).textTheme.labelMedium,
                          )
                        else
                          const Chip(
                            label: Text('Alerta no disponible'),
                            visualDensity: VisualDensity.compact,
                          ),
                      ],
                    ),
                  ),
                  if (onTap != null)
                    Icon(
                      Icons.chevron_right,
                      color: esquema.onSurfaceVariant,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(height: 1, color: esquema.outlineVariant),
              const SizedBox(height: 12),
              Wrap(
                spacing: 18,
                runSpacing: 10,
                children: [
                  _DatoSismo(
                    icono: Icons.schedule,
                    texto: _formatearFecha(sismo.fecha),
                  ),
                  _DatoSismo(
                    icono: Icons.place_outlined,
                    texto:
                        '${sismoConDistancia.distanciaKm.toStringAsFixed(1)} km de Quito',
                  ),
                ],
              ),
            ],
          ),
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

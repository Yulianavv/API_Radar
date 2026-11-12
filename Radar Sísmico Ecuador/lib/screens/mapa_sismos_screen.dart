import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../logic/alerta_sismo.dart';
import '../logic/sismo_logic.dart';
import '../widgets/colores_alerta.dart';
import '../widgets/estado_sismos.dart';
import '../widgets/selector_periodo.dart';
import 'detalle_sismo_screen.dart';

/// Mapa de eventos sísmicos sobre OpenStreetMap.
class MapaSismosScreen extends StatelessWidget {
  final Future<List<SismoConDistancia>> futuroSismos;
  final VoidCallback onReintentar;
  final int diasSeleccionados;
  final ValueChanged<int> onDiasChanged;

  const MapaSismosScreen({
    super.key,
    required this.futuroSismos,
    required this.onReintentar,
    required this.diasSeleccionados,
    required this.onDiasChanged,
  });

  static const LatLng _centroEcuador = LatLng(-1.83, -78.18);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mapa de sismos'),
        actions: [
          SelectorPeriodo(
            dias: diasSeleccionados,
            onChanged: onDiasChanged,
          ),
        ],
      ),
      body: EstadoSismos(
        futuro: futuroSismos,
        onReintentar: onReintentar,
        contenido: (context, sismos) {
          final sismosConCoordenadas = sismos.where(_tieneCoordenadas).toList();
          return Stack(
            children: [
              FlutterMap(
                options: const MapOptions(
                  initialCenter: _centroEcuador,
                  initialZoom: 5.2,
                  minZoom: 3,
                  maxZoom: 17,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'radar_sismico_ecuador',
                  ),
                  MarkerLayer(
                    markers: sismosConCoordenadas.map((item) {
                      final magnitud = item.sismo.magnitud;
                      final color = magnitud == null
                          ? Colors.blueGrey
                          : colorDeAlerta(
                              calcularAlerta(magnitud, item.distanciaKm).nivel,
                            );

                      return Marker(
                        point: LatLng(item.sismo.latitud, item.sismo.longitud),
                        width: 44,
                        height: 44,
                        alignment: Alignment.topCenter,
                        child: IconButton(
                          tooltip: item.sismo.lugar,
                          padding: EdgeInsets.zero,
                          onPressed: () => Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => DetalleSismoScreen(
                                sismoConDistancia: item,
                              ),
                            ),
                          ),
                          icon: Icon(
                            Icons.location_on,
                            size: 38,
                            color: color,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution('OpenStreetMap contributors'),
                    ],
                  ),
                ],
              ),
              const Positioned(
                top: 12,
                left: 12,
                right: 12,
                child: _LeyendaMapa(),
              ),
              if (sismosConCoordenadas.isEmpty)
                const Center(
                  child: Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('No hay coordenadas válidas para mostrar.'),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  bool _tieneCoordenadas(SismoConDistancia item) {
    final latitud = item.sismo.latitud;
    final longitud = item.sismo.longitud;
    return latitud >= -90 &&
        latitud <= 90 &&
        longitud >= -180 &&
        longitud <= 180 &&
        (latitud != 0 || longitud != 0);
  }
}

class _LeyendaMapa extends StatelessWidget {
  const _LeyendaMapa();

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Wrap(
          alignment: WrapAlignment.spaceEvenly,
          spacing: 10,
          runSpacing: 4,
          children: NivelAlerta.values.map((nivel) {
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 6,
                  backgroundColor: colorDeAlerta(nivel),
                ),
                const SizedBox(width: 4),
                Text(_nombreNivel(nivel)),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  String _nombreNivel(NivelAlerta nivel) {
    switch (nivel) {
      case NivelAlerta.imperceptible:
        return 'Imperceptible';
      case NivelAlerta.leve:
        return 'Leve';
      case NivelAlerta.moderada:
        return 'Moderada';
      case NivelAlerta.alta:
        return 'Alta';
    }
  }
}

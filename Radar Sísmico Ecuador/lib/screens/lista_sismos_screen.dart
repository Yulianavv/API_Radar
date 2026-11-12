import 'package:flutter/material.dart';

import '../errors/app_exception.dart';
import '../logic/sismo_logic.dart';
import '../services/usgs_service.dart';
import '../widgets/tarjeta_sismo.dart';

/// Pantalla que carga, filtra y muestra sismos ordenados por cercanía a Quito.
class ListaSismosScreen extends StatefulWidget {
  const ListaSismosScreen({super.key});

  @override
  State<ListaSismosScreen> createState() => _ListaSismosScreenState();
}

class _ListaSismosScreenState extends State<ListaSismosScreen> {
  static const List<double> _opcionesMagnitud = [2.5, 3.0, 4.0, 5.0];

  final UsgsService _usgsService = UsgsService();
  final SismoLogic _sismoLogic = SismoLogic();
  double _magnitudMinima = 2.5;
  late Future<List<SismoConDistancia>> _sismosFuture;

  @override
  void initState() {
    super.initState();
    _sismosFuture = _cargarSismos();
  }

  Future<List<SismoConDistancia>> _cargarSismos() async {
    final sismos = await _usgsService.obtenerSismos();
    return _sismoLogic.ordenarPorCercania(sismos);
  }

  void _reintentar() {
    setState(() {
      _sismosFuture = _cargarSismos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radar Sísmico Ecuador'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: DropdownButtonFormField<double>(
              initialValue: _magnitudMinima,
              decoration: const InputDecoration(
                labelText: 'Filtrar por magnitud mínima',
                border: OutlineInputBorder(),
              ),
              items: _opcionesMagnitud
                  .map(
                    (magnitud) => DropdownMenuItem<double>(
                      value: magnitud,
                      child: Text(
                        magnitud == 2.5
                            ? 'Todas (≥ 2.5)'
                            : 'Magnitud ≥ ${magnitud.toStringAsFixed(1)}',
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (magnitud) {
                if (magnitud != null) {
                  setState(() {
                    _magnitudMinima = magnitud;
                  });
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<List<SismoConDistancia>>(
              future: _sismosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (snapshot.hasError) {
                  return _EstadoError(
                    mensaje: _mensajeError(snapshot.error),
                    onReintentar: _reintentar,
                  );
                }

                final sismos = snapshot.data ?? const <SismoConDistancia>[];
                final sismosFiltrados = sismos.where((item) {
                  final magnitud = item.sismo.magnitud;
                  if (magnitud == null) return _magnitudMinima == 2.5;
                  return magnitud >= _magnitudMinima;
                }).toList();

                if (sismosFiltrados.isEmpty) {
                  return const Center(
                    child: Padding(
                      padding: EdgeInsets.all(24),
                      child: Text(
                        'No hay sismos que coincidan con este filtro.',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.only(top: 4, bottom: 16),
                  itemCount: sismosFiltrados.length,
                  itemBuilder: (context, index) {
                    return TarjetaSismo(
                      sismoConDistancia: sismosFiltrados[index],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _mensajeError(Object? error) {
    if (error is AppException) return error.mensaje;
    return 'No se pudieron cargar los sismos. Intenta de nuevo.';
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

import 'package:flutter/material.dart';

import '../logic/sismo_logic.dart';
import '../widgets/estado_sismos.dart';
import '../widgets/selector_periodo.dart';
import '../widgets/tarjeta_sismo.dart';
import 'detalle_sismo_screen.dart';

/// Pantalla que carga, filtra y muestra sismos ordenados por cercanía a Quito.
class ListaSismosScreen extends StatefulWidget {
  final Future<List<SismoConDistancia>> futuroSismos;
  final VoidCallback onReintentar;
  final int diasSeleccionados;
  final ValueChanged<int> onDiasChanged;

  const ListaSismosScreen({
    super.key,
    required this.futuroSismos,
    required this.onReintentar,
    required this.diasSeleccionados,
    required this.onDiasChanged,
  });

  @override
  State<ListaSismosScreen> createState() => _ListaSismosScreenState();
}

class _ListaSismosScreenState extends State<ListaSismosScreen> {
  static const List<double> _opcionesMagnitud = [2.5, 3.0, 4.0, 5.0];

  double _magnitudMinima = 2.5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Radar Sísmico Ecuador'),
        leading: const Icon(Icons.sensors),
        actions: [
          SelectorPeriodo(
            dias: widget.diasSeleccionados,
            onChanged: widget.onDiasChanged,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 20, 12),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Sismos recientes',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        'Ordenados por cercanía a Quito',
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.radar,
                  color: Theme.of(context).colorScheme.primary,
                  size: 28,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: DropdownButtonFormField<double>(
                  initialValue: _magnitudMinima,
                  decoration: const InputDecoration(
                    labelText: 'Magnitud mínima',
                    prefixIcon: Icon(Icons.tune),
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
            ),
          ),
          Expanded(
            child: EstadoSismos(
              futuro: widget.futuroSismos,
              onReintentar: widget.onReintentar,
              contenido: (context, sismos) {
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
                    final sismoConDistancia = sismosFiltrados[index];
                    return TarjetaSismo(
                      sismoConDistancia: sismoConDistancia,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => DetalleSismoScreen(
                              sismoConDistancia: sismoConDistancia,
                            ),
                          ),
                        );
                      },
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
}

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../logic/sismo_logic.dart';
import '../widgets/estado_sismos.dart';
import '../widgets/selector_periodo.dart';
import '../widgets/tarjeta_sismo.dart';
import 'detalle_sismo_screen.dart';

/// Resume la actividad sísmica recibida del servicio del USGS.
class EstadisticasScreen extends StatelessWidget {
  final Future<List<SismoConDistancia>> futuroSismos;
  final VoidCallback onReintentar;
  final int diasSeleccionados;
  final ValueChanged<int> onDiasChanged;

  const EstadisticasScreen({
    super.key,
    required this.futuroSismos,
    required this.onReintentar,
    required this.diasSeleccionados,
    required this.onDiasChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Estadísticas'),
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
        contenido: (context, sismos) => _construirEstadisticas(
          context,
          sismos,
          diasSeleccionados,
        ),
      ),
    );
  }

  Widget _construirEstadisticas(
    BuildContext context,
    List<SismoConDistancia> sismos,
    int diasSeleccionados,
  ) {
    final conMagnitud =
        sismos.where((item) => item.sismo.magnitud != null).toList()
          ..sort(
            (a, b) => b.sismo.magnitud!.compareTo(a.sismo.magnitud!),
          );
    final promedio = conMagnitud.isEmpty
        ? null
        : conMagnitud
                .map((item) => item.sismo.magnitud!)
                .reduce((a, b) => a + b) /
            conMagnitud.length;
    final eventoMasFuerte = conMagnitud.isEmpty ? null : conMagnitud.first;
    final topCinco = conMagnitud.take(5).toList();
    final agrupacionSemanal = diasSeleccionados == 90;
    final diasPorGrupo = agrupacionSemanal ? 7 : 1;
    final cantidadGrupos =
        (diasSeleccionados + diasPorGrupo - 1) ~/ diasPorGrupo;
    final inicioPeriodo = DateTime.now().subtract(
      Duration(days: diasSeleccionados),
    );
    final etiquetas = List<String>.generate(cantidadGrupos, (indice) {
      final fechaGrupo = inicioPeriodo.add(
        Duration(days: indice * diasPorGrupo),
      );
      return '${fechaGrupo.day}/${fechaGrupo.month}';
    });
    final conteos = List<int>.filled(cantidadGrupos, 0);
    for (final item in sismos) {
      final diferencia = item.sismo.fecha.difference(inicioPeriodo);
      if (diferencia.isNegative) continue;
      final indice = diferencia.inDays ~/ diasPorGrupo;
      if (indice < conteos.length) {
        conteos[indice]++;
      }
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        Row(
          children: [
            Expanded(
              child: _IndicadorEstadistica(
                titulo: 'Magnitud promedio',
                valor: promedio?.toStringAsFixed(1) ?? 'N/D',
                icono: Icons.show_chart,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _IndicadorEstadistica(
                titulo: 'Eventos consultados',
                valor: sismos.length.toString(),
                icono: Icons.public,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        if (diasSeleccionados > 7)
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'La consulta está limitada a 200 eventos; si hubo más en el '
              'periodo, los resultados podrían ser parciales.',
            ),
          ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  agrupacionSemanal ? 'Sismos por semana' : 'Sismos por día',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 230,
                  child: _GraficoSismosPorPeriodo(
                    etiquetas: etiquetas,
                    conteos: conteos,
                    mostrarCada: diasSeleccionados == 30
                        ? 5
                        : (agrupacionSemanal ? 2 : 1),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: ListTile(
            leading: const CircleAvatar(child: Icon(Icons.trending_up)),
            title: const Text('Sismo más fuerte'),
            subtitle: Text(
              eventoMasFuerte == null
                  ? 'No hay magnitudes disponibles.'
                  : '${eventoMasFuerte.sismo.lugar}\n'
                      '${eventoMasFuerte.sismo.fecha.day.toString().padLeft(2, '0')}/'
                      '${eventoMasFuerte.sismo.fecha.month.toString().padLeft(2, '0')}/'
                      '${eventoMasFuerte.sismo.fecha.year}',
            ),
            trailing: eventoMasFuerte == null
                ? const Text('N/D')
                : Text(
                    eventoMasFuerte.sismo.magnitud!.toStringAsFixed(1),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
            isThreeLine: eventoMasFuerte != null,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Top 5 sismos más fuertes',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        if (topCinco.isEmpty)
          const Card(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Text('No hay sismos con magnitud disponible.'),
            ),
          )
        else
          ...topCinco.map(
            (item) => TarjetaSismo(
              sismoConDistancia: item,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => DetalleSismoScreen(
                    sismoConDistancia: item,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _IndicadorEstadistica extends StatelessWidget {
  final String titulo;
  final String valor;
  final IconData icono;

  const _IndicadorEstadistica({
    required this.titulo,
    required this.valor,
    required this.icono,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icono, color: Theme.of(context).colorScheme.primary),
            const SizedBox(height: 8),
            Text(titulo, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 4),
            Text(
              valor,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GraficoSismosPorPeriodo extends StatelessWidget {
  final List<String> etiquetas;
  final List<int> conteos;
  final int mostrarCada;

  const _GraficoSismosPorPeriodo({
    required this.etiquetas,
    required this.conteos,
    required this.mostrarCada,
  });

  @override
  Widget build(BuildContext context) {
    final maximo = conteos.fold<int>(
      0,
      (mayor, cantidad) => cantidad > mayor ? cantidad : mayor,
    );
    final color = Theme.of(context).colorScheme.primary;
    final textoColor = Theme.of(context).colorScheme.onSurface;

    return BarChart(
      BarChartData(
        maxY: (maximo + 1).toDouble(),
        barGroups: List<BarChartGroupData>.generate(
          conteos.length,
          (indice) => BarChartGroupData(
            x: indice,
            barRods: [
              BarChartRodData(
                toY: conteos[indice].toDouble(),
                color: color,
                width: conteos.length > 10 ? 6 : 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
        ),
        gridData: const FlGridData(show: true),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true, reservedSize: 30),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              interval: 1,
              reservedSize: 34,
              getTitlesWidget: (valor, meta) {
                final indice = valor.toInt();
                if (indice < 0 || indice >= etiquetas.length) {
                  return const SizedBox.shrink();
                }
                if (indice % mostrarCada != 0 &&
                    indice != etiquetas.length - 1) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    etiquetas[indice],
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: textoColor,
                        ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

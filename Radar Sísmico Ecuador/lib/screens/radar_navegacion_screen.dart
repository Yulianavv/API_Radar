import 'package:flutter/material.dart';

import '../logic/sismo_logic.dart';
import '../services/usgs_service.dart';
import 'estadisticas_screen.dart';
import 'lista_sismos_screen.dart';
import 'mapa_sismos_screen.dart';

/// Mantiene una consulta compartida entre las pestañas principales.
class RadarNavegacionScreen extends StatefulWidget {
  const RadarNavegacionScreen({super.key});

  @override
  State<RadarNavegacionScreen> createState() => _RadarNavegacionScreenState();
}

class _RadarNavegacionScreenState extends State<RadarNavegacionScreen> {
  final UsgsService _usgsService = UsgsService();
  final SismoLogic _sismoLogic = SismoLogic();
  int _indiceSeleccionado = 0;
  late Future<List<SismoConDistancia>> _futuroSismos;

  @override
  void initState() {
    super.initState();
    _futuroSismos = _cargarSismos();
  }

  Future<List<SismoConDistancia>> _cargarSismos() async {
    final sismos = await _usgsService.obtenerSismos();
    return _sismoLogic.ordenarPorCercania(sismos);
  }

  void _reintentar() {
    setState(() {
      _futuroSismos = _cargarSismos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _indiceSeleccionado,
        children: [
          ListaSismosScreen(
            futuroSismos: _futuroSismos,
            onReintentar: _reintentar,
          ),
          MapaSismosScreen(
            futuroSismos: _futuroSismos,
            onReintentar: _reintentar,
          ),
          EstadisticasScreen(
            futuroSismos: _futuroSismos,
            onReintentar: _reintentar,
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _indiceSeleccionado,
        onDestinationSelected: (indice) {
          setState(() {
            _indiceSeleccionado = indice;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.view_list_outlined),
            selectedIcon: Icon(Icons.view_list),
            label: 'Sismos',
          ),
          NavigationDestination(
            icon: Icon(Icons.map_outlined),
            selectedIcon: Icon(Icons.map),
            label: 'Mapa',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: 'Estadísticas',
          ),
        ],
      ),
    );
  }
}

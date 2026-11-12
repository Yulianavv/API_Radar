# Radar Sísmico Ecuador

Aplicación Flutter para consultar eventos sísmicos recientes del USGS en Ecuador.

## Funcionalidades

- Lista de sismos ordenada por distancia a Quito y filtro por magnitud.
- Detalle de cada evento con recomendación y enlace a la ficha del USGS.
- Mapa interactivo de OpenStreetMap con marcadores por nivel de alerta.
- Estadísticas de los últimos siete días y top 5 por magnitud.
- Navegación inferior entre lista, mapa y estadísticas.

## Ejecutar

Desde esta carpeta:

```powershell
flutter pub get
flutter run -d chrome
```

Para ejecutar en un emulador o dispositivo Android conectado:

```powershell
flutter devices
flutter run -d <id-del-dispositivo>
```

La aplicación necesita conexión a internet para consultar el USGS y cargar los
mapas de OpenStreetMap. En caso de error de consulta, usa **Reintentar**.

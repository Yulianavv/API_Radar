# Radar Sísmico Ecuador

Proyecto universitario desarrollado en Flutter para consultar y visualizar
eventos sísmicos reales publicados por el Servicio Geológico de Estados Unidos
(USGS).

La aplicación reúne en una sola interfaz una lista de sismos, un mapa, detalles
de cada evento y estadísticas para ayudar a comprender dónde ocurrieron, cuándo,
qué magnitud tuvieron y qué tan lejos están de Quito.

## Funcionalidades

- Consulta eventos de los últimos 7, 30 o 90 días.
- Filtra la lista por magnitud mínima y ordena los eventos por distancia desde
  Quito.
- Muestra el detalle del evento y permite abrir su ficha original del USGS.
- Ubica los epicentros en OpenStreetMap con marcadores de colores.
- Presenta magnitud promedio, eventos por día o semana, el sismo más fuerte y
  un Top 5.
- Incluye estados de carga, mensajes de error y opción para reintentar.

## Fuente de datos y alcance

Los eventos se consultan desde el catálogo público del USGS:

<https://earthquake.usgs.gov/fdsnws/event/1/query>

La búsqueda usa una magnitud mínima de 2.5, un radio aproximado de 600 km
alrededor del punto configurado para Ecuador y un máximo de 200 eventos por
consulta. Por el radio, pueden aparecer eventos de países vecinos; en periodos
largos, los resultados podrían ser parciales si se supera el límite.

Las distancias se calculan desde Quito (-0.1807, -78.4678); la aplicación no
obtiene automáticamente la ubicación del teléfono. Los colores y recomendaciones
son cálculos informativos propios del proyecto, no alertas oficiales ni
predicciones, y no reemplazan las instrucciones de las autoridades.

## Ejecutar en navegador

El proyecto Flutter está dentro de la carpeta `Radar Sísmico Ecuador`. Desde la
raíz del repositorio:

```powershell
cd "Radar Sísmico Ecuador"
flutter pub get
flutter run -d chrome
```

La consulta al USGS y el mapa requieren conexión a internet.

## Verificaciones

Desde la carpeta del proyecto Flutter:

```powershell
flutter test
dart analyze
```

## Organización

- `Radar Sísmico Ecuador/lib/models`, `services`, `utils`, `logic` y `errors`:
  modelo, consulta y procesamiento de los datos.
- `Radar Sísmico Ecuador/lib/screens` y `widgets`: pantallas y componentes de la
  interfaz.
- `Radar Sísmico Ecuador/test`: pruebas de lógica e interfaz.

La documentación de ejecución y estructura está en
[Radar Sísmico Ecuador/README.md](Radar%20S%C3%ADsmico%20Ecuador/README.md).

# Radar Sísmico Ecuador

Aplicación Flutter para consultar y visualizar eventos sísmicos reales publicados
por el catálogo del Servicio Geológico de Estados Unidos (USGS).

## Funcionalidades

- Lista de eventos ordenada por distancia de referencia desde Quito.
- Filtro local por magnitud mínima: 2.5, 3.0, 4.0 o 5.0.
- Consulta de los últimos 7, 30 o 90 días.
- Detalle de cada evento con sus datos disponibles, recomendación y enlace a la
  ficha original del USGS.
- Mapa de OpenStreetMap con marcadores coloreados según la categoría calculada
  por la aplicación.
- Estadísticas de magnitud promedio, número de eventos, evento más fuerte y
  Top 5. El gráfico agrupa por día para 7 y 30 días, y por semana para 90 días.
- Mensajes de carga y error, con opción para volver a intentar.
- Navegación inferior entre la lista, el mapa y las estadísticas.

## Fuente y alcance de los datos

La aplicación consulta el catálogo del USGS mediante su servicio FDSN:

<https://earthquake.usgs.gov/fdsnws/event/1/query>

La búsqueda usa GeoJSON, una magnitud mínima de 2.5, un radio aproximado de
600 km alrededor del punto configurado para Ecuador y un límite de 200 eventos.
Por el tamaño del radio, pueden aparecer eventos de países vecinos. Para
periodos de 30 o 90 días, la respuesta podría ser parcial si supera ese límite.

La lista calcula la distancia desde Quito (-0.1807, -78.4678); no obtiene
automáticamente la ubicación del dispositivo.

Los colores de alerta y las recomendaciones se calculan con reglas propias que
combinan magnitud y distancia. Son informativos, no son alertas oficiales, no
predicen sismos y no sustituyen las instrucciones de las autoridades.

## Organización del código

- `lib/models/`, `lib/services/`, `lib/utils/`, `lib/logic/` y `lib/errors/`:
  modelo, consulta al USGS, cálculo de distancias, alertas y manejo de errores.
- `lib/screens/`: lista, detalle, mapa, estadísticas y navegación.
- `lib/widgets/`: tarjetas, colores, selector de periodo y estados de carga/error.
- `test/`: pruebas de las reglas de alerta y de comportamientos de interfaz.

`HistorialService` ya permite guardar localmente identificadores de sismos vistos,
pero todavía no está conectado a las pantallas.

## Ejecutar en navegador

Desde esta carpeta:

```powershell
flutter pub get
flutter run -d chrome
```

La aplicación necesita internet para consultar los eventos y cargar los mapas.

## Ejecutar pruebas y análisis

```powershell
flutter test
dart analyze
```

## Android

El proyecto incluye la estructura de plataforma Android. Para intentarlo en un
emulador o dispositivo conectado:

```powershell
flutter devices
flutter run -d <id-del-dispositivo>
```

La compilación Android debe validarse en el entorno de destino; la generación
del APK no se ha verificado en todos los entornos Windows.

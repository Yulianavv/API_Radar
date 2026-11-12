/// Niveles de alerta sísmica ordenados de menor a mayor gravedad.
enum NivelAlerta {
  imperceptible,
  leve,
  moderada,
  alta,
}

/// Resultado de evaluación de riesgo sísmico para mostrar al usuario.
class Alerta {
  final NivelAlerta nivel;
  final String titulo;
  final String recomendacion;

  const Alerta({
    required this.nivel,
    required this.titulo,
    required this.recomendacion,
  });
}

// ============================================================================
// Umbrales configurables (fáciles de ajustar sin tocar la lógica)
// ============================================================================

/// Magnitud mínima para que un sismo pueda sentirse.
const double _magMinimaPerceptible = 3.0;

/// Límite superior del rango de magnitud leve (3.0 a < 4.5).
const double _magLeveMax = 4.5;

/// Magnitud a partir de la cual un sismo cercano (< 100 km) pasa a alerta alta.
const double _magAltaCercano = 5.0;

/// Magnitud fuerte que genera alerta alta en rango regional.
const double _magAlta = 6.0;

/// Distancia máxima (km) para considerar un sismo >= 5.0 como alerta alta.
const double _distAltaCercanoKm = 100.0;

/// Distancia máxima (km) considerada "cercana" para sismos leves y moderados.
const double _distCercanoKm = 150.0;

/// Distancia intermedia (km) hasta donde un sismo >= 6.0 sigue siendo alerta alta.
const double _distIntermedioKm = 300.0;

/// Distancia a partir de la cual el sismo se considera demasiado lejano.
const double _distMuyLejanoKm = 500.0;

/// Calcula el nivel de alerta combinando la [magnitud] del sismo y su [distanciaKm].
///
/// Un sismo fuerte pero lejano atenúa su nivel (pudiendo ser leve), mientras que
/// un sismo moderado pero muy cercano eleva su prioridad.
Alerta calcularAlerta(double magnitud, double distanciaKm) {
  // 1. Magnitud menor a 3 o distancia muy grande: no representa peligro percibido.
  if (magnitud < _magMinimaPerceptible || distanciaKm >= _distMuyLejanoKm) {
    return _construirAlerta(NivelAlerta.imperceptible);
  }

  // 2. Alerta alta: magnitud >= 6 (en rango regional) o >= 5 a menos de 100 km.
  if ((magnitud >= _magAlta && distanciaKm < _distIntermedioKm) ||
      (magnitud >= _magAltaCercano && distanciaKm < _distAltaCercanoKm)) {
    return _construirAlerta(NivelAlerta.alta);
  }

  // 3. Sismo grande (>= 6) pero lejano (entre 300 y 500 km): se atenúa a leve.
  if (magnitud >= _magAlta) {
    return _construirAlerta(NivelAlerta.leve);
  }

  // 4. Sismo moderado (4.5 a < 6.0): depende de qué tan cerca esté del usuario.
  if (magnitud >= _magLeveMax) {
    if (distanciaKm < _distCercanoKm) {
      return _construirAlerta(NivelAlerta.moderada);
    }
    if (distanciaKm < _distIntermedioKm) {
      return _construirAlerta(NivelAlerta.leve);
    }
    return _construirAlerta(NivelAlerta.imperceptible);
  }

  // 5. Sismo leve (3.0 a < 4.5): solo se siente si está cercano (< 150 km).
  if (distanciaKm < _distCercanoKm) {
    return _construirAlerta(NivelAlerta.leve);
  }

  return _construirAlerta(NivelAlerta.imperceptible);
}

/// Devuelve los textos de título y recomendación correspondientes a cada [NivelAlerta].
Alerta _construirAlerta(NivelAlerta nivel) {
  switch (nivel) {
    case NivelAlerta.imperceptible:
      return const Alerta(
        nivel: NivelAlerta.imperceptible,
        titulo: 'Sismo imperceptible',
        recomendacion:
            'No requiere acción. Continúa con tus actividades normales.',
      );
    case NivelAlerta.leve:
      return const Alerta(
        nivel: NivelAlerta.leve,
        titulo: 'Alerta leve',
        recomendacion:
            'Mantén la calma y revisa tu entorno por objetos que puedan caer.',
      );
    case NivelAlerta.moderada:
      return const Alerta(
        nivel: NivelAlerta.moderada,
        titulo: 'Alerta moderada',
        recomendacion:
            'Aléjate de ventanas, repisas y objetos pesados; ubica tu zona segura.',
      );
    case NivelAlerta.alta:
      return const Alerta(
        nivel: NivelAlerta.alta,
        titulo: 'Alerta alta',
        recomendacion:
            'Agáchate, cúbrete y sujétate. Evacúa hacia un espacio abierto al terminar.',
      );
  }
}


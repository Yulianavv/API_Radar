import 'package:flutter/material.dart';

import '../logic/alerta_sismo.dart';

/// Colores suaves para distinguir visualmente cada nivel de alerta.
Color colorDeAlerta(NivelAlerta nivel) {
  switch (nivel) {
    case NivelAlerta.imperceptible:
      return const Color(0xFFC8E6C9);
    case NivelAlerta.leve:
      return const Color(0xFFFFF3B0);
    case NivelAlerta.moderada:
      return const Color(0xFFFFCC80);
    case NivelAlerta.alta:
      return const Color(0xFFFFCDD2);
  }
}

import 'package:flutter/material.dart';

/// Permite elegir cuántos días de eventos solicitar al USGS.
class SelectorPeriodo extends StatelessWidget {
  static const List<int> opcionesDias = [7, 30, 90];

  final int dias;
  final ValueChanged<int> onChanged;

  const SelectorPeriodo({
    super.key,
    required this.dias,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
      tooltip: 'Cambiar periodo de consulta',
      initialValue: dias,
      onSelected: onChanged,
      itemBuilder: (context) => opcionesDias
          .map(
            (opcion) => PopupMenuItem<int>(
              value: opcion,
              child: Text('Últimos $opcion días'),
            ),
          )
          .toList(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        margin: const EdgeInsets.only(right: 12, top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primaryContainer,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month_outlined,
              size: 18,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            const SizedBox(width: 4),
            Text(
              '$dias días',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
          ],
        ),
      ),
    );
  }
}

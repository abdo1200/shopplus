import 'package:flutter/material.dart';
import 'package:shopplus/core/design_system/shopplus_theme.dart';

class MetricChip extends StatelessWidget {
  const MetricChip({super.key, required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final appColors = Theme.of(context).shopPlusColorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: appColors.brandOverlay,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Text(
          '$label: $value',
          style: TextStyle(color: appColors.onBrand),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class WalletRefreshOverlay extends StatelessWidget {
  const WalletRefreshOverlay({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Positioned.fill(
      child: Stack(
        alignment: Alignment.center,
        children: [
          ModalBarrier(
            color: colorScheme.scrim.withValues(alpha: 0.18),
            dismissible: false,
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 24,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: const Padding(
              padding: EdgeInsets.all(18),
              child: SizedBox.square(
                dimension: 34,
                child: CircularProgressIndicator(strokeWidth: 3),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

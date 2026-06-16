import 'package:flutter/material.dart';

class ShopPlusTextField extends StatelessWidget {
  const ShopPlusTextField({
    super.key,
    required this.label,
    required this.onChanged,
    this.controller,
    this.errorText,
    this.keyboardType,
    this.maxLength,
    this.maxLines = 1,
  });

  final String label;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final String? errorText;
  final TextInputType? keyboardType;
  final int? maxLength;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      onChanged: onChanged,
      keyboardType: keyboardType,
      maxLength: maxLength,
      maxLines: maxLines,
      decoration: InputDecoration(labelText: label, errorText: errorText),
    );
  }
}

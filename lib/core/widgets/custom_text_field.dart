import 'package:flutter/material.dart';

/// Styled text form field with consistent decoration.
class CustomTextField extends StatelessWidget {
  const CustomTextField({
    super.key,
    this.controller,
    required this.label,
    this.hint,
    this.validator,
    this.maxLines = 1,
    this.textInputAction,
    this.readOnly = false,
    this.onChanged,
    this.suffixIcon,
  });

  final TextEditingController? controller;
  final String label;
  final String? hint;
  final String? Function(String?)? validator;
  final int maxLines;
  final TextInputAction? textInputAction;
  final bool readOnly;
  final ValueChanged<String>? onChanged;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      readOnly: readOnly,
      maxLines: maxLines,
      textInputAction: textInputAction,
      validator: validator,
      onChanged: onChanged,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        alignLabelWithHint: maxLines > 1,
        suffixIcon: suffixIcon,
      ),
    );
  }
}

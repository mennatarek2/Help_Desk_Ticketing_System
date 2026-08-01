import 'package:flutter/material.dart';

/// Constrains form content width on large screens while staying full width on mobile.
class FormContentWrapper extends StatelessWidget {
  const FormContentWrapper({
    super.key,
    required this.child,
    this.maxWidth = 600,
  });

  final Widget child;
  final double maxWidth;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      widthFactor: 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: child,
      ),
    );
  }
}

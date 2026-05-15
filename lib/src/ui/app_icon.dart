import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AppIcon extends StatelessWidget {
  const AppIcon({super.key, required this.path, this.size = 28});

  final String? path;
  final double size;

  @override
  Widget build(BuildContext context) {
    final p = path;
    if (p == null) return _placeholder();
    final lower = p.toLowerCase();
    if (lower.endsWith('.svg')) {
      return SvgPicture.file(
        File(p),
        width: size,
        height: size,
        fit: BoxFit.contain,
        placeholderBuilder: (_) => _placeholder(),
      );
    }
    if (lower.endsWith('.png') || lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return Image.file(
        File(p),
        width: size,
        height: size,
        fit: BoxFit.contain,
        filterQuality: FilterQuality.medium,
        errorBuilder: (_, _, _) => _placeholder(),
      );
    }
    return _placeholder();
  }

  Widget _placeholder() => SizedBox(width: size, height: size);
}

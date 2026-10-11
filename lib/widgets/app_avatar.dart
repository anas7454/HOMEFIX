import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? avatarUrl;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final BoxBorder? border;

  const AppAvatar({
    Key? key,
    required this.avatarUrl,
    this.size = 70.0,
    this.backgroundColor,
    this.iconColor,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.grey.shade200,
        border: border,
      ),
      child: ClipOval(
        child: _buildImage(),
      ),
    );
  }

  Widget _buildImage() {
    final url = avatarUrl?.trim();
    if (url == null || url.isEmpty) {
      return _buildFallback();
    }

    try {
      if (url.startsWith('data:image')) {
        final base64Part = url.contains(',') ? url.split(',').last : url;
        final bytes = base64Decode(base64Part);
        return Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      }

      if (url.startsWith('http://') || url.startsWith('https://')) {
        return Image.network(
          url,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      }

      final file = File(url);
      if (file.existsSync()) {
        return Image.file(
          file,
          width: size,
          height: size,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildFallback(),
        );
      }
    } catch (_) {}

    return _buildFallback();
  }

  Widget _buildFallback() {
    return Center(
      child: Icon(
        Icons.person,
        size: size * 0.6,
        color: iconColor ?? Colors.deepOrange,
      ),
    );
  }
}

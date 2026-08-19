import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class AvatarFrame extends StatelessWidget {
  final String? fotoUrl;
  final String nombre;
  final String? marcoId;
  final double size;

  const AvatarFrame({
    super.key,
    this.fotoUrl,
    required this.nombre,
    this.marcoId,
    this.size = 48,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: _getBorder(),
      ),
      child: ClipOval(
        child: _buildAvatar(),
      ),
    );
  }

  Widget _buildAvatar() {
    if (fotoUrl != null && fotoUrl!.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: fotoUrl!,
        fit: BoxFit.cover,
        placeholder: (context, url) => _buildPlaceholder(),
        errorWidget: (context, url, error) => _buildInitials(),
      );
    } else {
      return _buildInitials();
    }
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[800],
      child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
    );
  }

  Widget _buildInitials() {
    final initial = nombre.isNotEmpty ? nombre[0].toUpperCase() : '?';
    return Container(
      color: Colors.grey[800],
      child: Center(
        child: Text(
          initial,
          style: TextStyle(
            color: Colors.white,
            fontSize: size * 0.4,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Border? _getBorder() {
    if (marcoId == 'none' || marcoId == null) return null;
    return Border.all(color: const Color(0xFF2DD4BF), width: 3);
  }
}

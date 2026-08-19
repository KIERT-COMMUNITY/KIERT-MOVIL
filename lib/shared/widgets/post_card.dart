import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiert_movil/core/models/post.dart';
import 'package:kiert_movil/shared/widgets/avatar_frame.dart';

class PostCard extends StatelessWidget {
  final Post post;
  final VoidCallback? onTap;

  const PostCard({super.key, required this.post, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (onTap != null) {
          onTap!();
        } else {
          context.go('/comunidad/${post.id}');
        }
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF131A22),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey[800]!),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                AvatarFrame(
                  fotoUrl: post.autor.fotoPerfilUrl,
                  nombre: post.autor.nombreUsuario,
                  marcoId: post.autor.marcoId,
                  size: 40,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        post.autor.nombreUsuario,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatearFecha(post.fechaCreacion),
                        style: TextStyle(color: Colors.grey[500], fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              post.titulo,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 8),
            Text(
              post.descripcion,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(Icons.comment_outlined, size: 16, color: Colors.grey[500]),
                const SizedBox(width: 4),
                Text(
                  '${post.totalComentarios}',
                  style: TextStyle(color: Colors.grey[500], fontSize: 13),
                ),
                if (post.adjuntos.isNotEmpty) ...[
                  const SizedBox(width: 16),
                  Icon(Icons.attach_file, size: 16, color: Colors.grey[500]),
                  const SizedBox(width: 4),
                  Text(
                    '${post.adjuntos.length}',
                    style: TextStyle(color: Colors.grey[500], fontSize: 13),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatearFecha(String fecha) {
    try {
      final date = DateTime.parse(fecha);
      final now = DateTime.now();
      final diff = now.difference(date);

      if (diff.inMinutes < 1) return 'Ahora mismo';
      if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
      if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
      if (diff.inDays < 7) return 'Hace ${diff.inDays} d';

      const meses = [
        'ene',
        'feb',
        'mar',
        'abr',
        'may',
        'jun',
        'jul',
        'ago',
        'sep',
        'oct',
        'nov',
        'dic'
      ];
      return '${date.day} ${meses[date.month - 1]} ${date.year}';
    } catch (e) {
      return fecha;
    }
  }
}

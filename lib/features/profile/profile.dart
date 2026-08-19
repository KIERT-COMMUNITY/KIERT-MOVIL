import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiert_movil/core/providers/auth_provider.dart';
import 'package:kiert_movil/core/providers/personalizacion_provider.dart';
import 'package:kiert_movil/core/providers/post_provider.dart';
import 'package:kiert_movil/shared/widgets/avatar_frame.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final personalizacion = ref.watch(personalizacionStateProvider);
    final postsState = ref.watch(postsProvider);
    final user = authState.user;

    if (user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.grey, size: 48),
              const SizedBox(height: 16),
              const Text('Debes iniciar sesión',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DD4BF),
                  foregroundColor: const Color(0xFF0D1117),
                ),
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      );
    }

    final totalPosts =
        postsState.posts.where((p) => p.autor.id == user.id).length;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text('Mi Perfil', style: TextStyle(color: Colors.white)),
        elevation: 0,
        actions: [
          TextButton(
            onPressed: () => context.go('/ajustes'),
            style: TextButton.styleFrom(
              foregroundColor: const Color(0xFF2DD4BF),
            ),
            child: const Text('Ajustes'),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Avatar
            AvatarFrame(
              fotoUrl: user.fotoPerfilUrl,
              nombre: user.nombreUsuario,
              marcoId: personalizacion.marcoId,
              size: 120,
            ),
            const SizedBox(height: 16),
            Text(
              '@${user.nombreUsuario}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              user.email,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 16),

            // Stats
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(color: Colors.grey[800]!),
                  bottom: BorderSide(color: Colors.grey[800]!),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStat('$totalPosts', 'Publicaciones'),
                  _buildStat('0', 'Comentarios'),
                  _buildStat('0', 'Conversaciones'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Botones de acción
            Row(
              children: [
                Expanded(
                  child: _buildActionButton(
                    Icons.chat_outlined,
                    'Mensajes',
                    () => context.go('/chat'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    Icons.history_outlined,
                    'Historial',
                    () => context.go('/mis-publicaciones'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    Icons.settings_outlined,
                    'Ajustes',
                    () => context.go('/ajustes'),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildActionButton(
                    Icons.logout_outlined,
                    'Cerrar sesión',
                    _logout,
                    danger: true,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: TextStyle(color: Colors.grey[500], fontSize: 12),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label, VoidCallback onTap,
      {bool danger = false}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: danger
              ? Colors.red.withOpacity(0.1)
              : Colors.grey[800]!.withOpacity(0.5),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          children: [
            Icon(icon, color: danger ? Colors.red : Colors.white, size: 20),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: danger ? Colors.red : Colors.white,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A22),
        title:
            const Text('Cerrar sesión', style: TextStyle(color: Colors.white)),
        content: const Text(
          '¿Seguro que quieres cerrar sesión?',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(authStateProvider.notifier).logout();
              context.go('/login');
            },
            child: const Text('Cerrar sesión',
                style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

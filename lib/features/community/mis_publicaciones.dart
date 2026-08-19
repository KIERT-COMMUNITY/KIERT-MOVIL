import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiert_movil/core/providers/auth_provider.dart';
import 'package:kiert_movil/core/providers/post_provider.dart';

class MisPublicacionesPage extends ConsumerStatefulWidget {
  const MisPublicacionesPage({super.key});

  @override
  ConsumerState<MisPublicacionesPage> createState() =>
      _MisPublicacionesPageState();
}

class _MisPublicacionesPageState extends ConsumerState<MisPublicacionesPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).loadUserPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);
    final authState = ref.watch(authStateProvider);

    if (authState.user == null) {
      return Center(
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
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text('Mis Publicaciones',
            style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/comunidad'),
        ),
      ),
      body: postsState.isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF2DD4BF)))
          : postsState.posts.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.article_outlined,
                          size: 48, color: Colors.grey[600]),
                      const SizedBox(height: 16),
                      const Text('No tienes publicaciones',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 8),
                      Text(
                        'Comienza a compartir tus casos con la comunidad.',
                        style: TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: () =>
                            context.go('/comunidad/nueva-publicacion'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2DD4BF),
                          foregroundColor: const Color(0xFF0D1117),
                        ),
                        child: const Text('Crear publicación'),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: postsState.posts.length,
                  itemBuilder: (context, index) {
                    final post = postsState.posts[index];
                    return Container(
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.only(bottom: 12),
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
                              Expanded(
                                child: Text(
                                  post.titulo,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.red),
                                onPressed: () => _confirmDelete(post.id),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            post.descripcion,
                            style: TextStyle(
                                color: Colors.grey[400], fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.comment_outlined,
                                  color: Colors.grey, size: 16),
                              const SizedBox(width: 4),
                              Text(
                                '${post.totalComentarios} comentarios',
                                style: TextStyle(
                                    color: Colors.grey[500], fontSize: 13),
                              ),
                              const Spacer(),
                              OutlinedButton(
                                onPressed: () =>
                                    context.go('/comunidad/${post.id}'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: const Color(0xFF2DD4BF),
                                  side: const BorderSide(
                                      color: Color(0xFF2DD4BF)),
                                ),
                                child: const Text('Ver'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
    );
  }

  void _confirmDelete(int postId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF131A22),
        title: const Text('Eliminar publicación',
            style: TextStyle(color: Colors.white)),
        content: const Text(
          '¿Seguro que quieres eliminar esta publicación?',
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
              ref.read(postsProvider.notifier).deletePost(postId);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}

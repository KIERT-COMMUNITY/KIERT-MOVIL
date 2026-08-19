import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:kiert_movil/core/providers/post_provider.dart';
import 'package:kiert_movil/core/providers/personalizacion_provider.dart';
import 'package:kiert_movil/shared/widgets/post_card.dart';
import 'package:kiert_movil/core/environment.dart';

class FeedPage extends ConsumerStatefulWidget {
  const FeedPage({super.key});

  @override
  ConsumerState<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends ConsumerState<FeedPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(postsProvider.notifier).loadPosts();
    });
  }

  @override
  Widget build(BuildContext context) {
    final postsState = ref.watch(postsProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: RefreshIndicator(
        onRefresh: () => ref.read(postsProvider.notifier).refreshPosts(),
        color: const Color(0xFF2DD4BF),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ===== LOGO =====
              _buildLogo(),
              const SizedBox(height: 16),

              // ===== HEADER =====
              _buildHeader(),
              const SizedBox(height: 16),

              // ===== POSTS =====
              if (postsState.error != null) _buildError(postsState.error!),
              if (postsState.isLoading && postsState.posts.isEmpty)
                _buildLoading(),
              if (!postsState.isLoading && postsState.posts.isEmpty)
                _buildEmpty(),
              if (postsState.posts.isNotEmpty)
                ...postsState.posts.map((post) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: PostCard(
                      post: post,
                      onTap: () => context.go('/comunidad/${post.id}'),
                    ),
                  );
                }),

              const SizedBox(height: 16),

              // ===== BANNER DESTACADO =====
              _buildDestacado(),
              const SizedBox(height: 12),

              // ===== CARRUSEL DE ANUNCIOS =====
              _buildCarrusel(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ===== LOGO =====
  Widget _buildLogo() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // ✅ IMAGEN DEL LOGO
          Image.asset(
            Environment.logoPath,
            height: 32,
            width: 32,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(
                Icons.shield_outlined,
                color: Color(0xFF2DD4BF),
                size: 32,
              );
            },
          ),
          const SizedBox(width: 8),
          const Text(
            '>_',
            style: TextStyle(
              color: Color(0xFF2DD4BF),
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'JetBrainsMono',
            ),
          ),
          const Text(
            'kiert',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 18,
              fontFamily: 'JetBrainsMono',
            ),
          ),
        ],
      ),
    );
  }

  // ===== HEADER =====
  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A22),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Comunidad',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'Casos, dudas e historias reales para ayudarse entre todos.',
                  style: TextStyle(color: Colors.grey[500], fontSize: 12),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: () =>
                    ref.read(postsProvider.notifier).refreshPosts(),
                icon: const Icon(Icons.refresh, color: Colors.grey),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/comunidad/nueva-publicacion'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DD4BF),
                  foregroundColor: const Color(0xFF0D1117),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Publicar'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== ERROR =====
  Widget _buildError(String error) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(error, style: const TextStyle(color: Colors.red)),
          ),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => ref.read(postsProvider.notifier).clearError(),
          ),
        ],
      ),
    );
  }

  // ===== LOADING =====
  Widget _buildLoading() {
    return const Center(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            CircularProgressIndicator(color: Color(0xFF2DD4BF)),
            SizedBox(height: 12),
            Text('Cargando publicaciones...',
                style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  // ===== EMPTY =====
  Widget _buildEmpty() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Column(
        children: [
          Icon(Icons.forum_outlined, size: 48, color: Colors.grey[600]),
          const SizedBox(height: 12),
          const Text(
            'No hay publicaciones aún',
            style: TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: () => context.go('/comunidad/nueva-publicacion'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2DD4BF),
              foregroundColor: const Color(0xFF0D1117),
            ),
            child: const Text('Crear primera publicación'),
          ),
        ],
      ),
    );
  }

  // ===== BANNER DESTACADO =====
  Widget _buildDestacado() {
    return Container(
      width: double.infinity,
      height: 140,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
        image: DecorationImage(
          image: AssetImage(Environment.bannerDestacadoPath),
          fit: BoxFit.cover,
          onError: (exception, stackTrace) {
            // Si falla la imagen, usar gradiente
          },
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: const Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Ofertas exclusivas',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(
                'Descuentos en ciberseguridad',
                style: TextStyle(color: Colors.white70),
              ),
              SizedBox(height: 4),
              Text(
                'Ver ofertas →',
                style: TextStyle(
                  color: Color(0xFF2DD4BF),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ===== CARRUSEL DE ANUNCIOS =====
  Widget _buildCarrusel() {
    final anuncios = Environment.anunciosPaths;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.only(bottom: 8),
          child: Text(
            'Anuncios destacados',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: anuncios.length,
            itemBuilder: (context, index) {
              return Container(
                width: 160,
                height: 80,
                margin: const EdgeInsets.only(right: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey[800]!),
                  image: DecorationImage(
                    image: AssetImage(anuncios[index]),
                    fit: BoxFit.cover,
                    onError: (exception, stackTrace) {
                      // Si falla la imagen, mostrar placeholder
                    },
                  ),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withOpacity(0.6),
                      ],
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        'Nuevo',
                        style: TextStyle(
                          color: Color(0xFF2DD4BF),
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          backgroundColor: Colors.black45,
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

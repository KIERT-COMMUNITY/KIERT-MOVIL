import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiert_movil/core/models/post.dart';
import 'package:kiert_movil/core/services/post_service.dart';

final postServiceProvider = Provider<PostService>((ref) => PostService());

final postsProvider = StateNotifierProvider<PostsNotifier, PostsState>((ref) {
  return PostsNotifier(ref);
});

class PostsState {
  final List<Post> posts;
  final bool isLoading;
  final String? error;

  PostsState({this.posts = const [], this.isLoading = false, this.error});

  PostsState copyWith({List<Post>? posts, bool? isLoading, String? error}) {
    return PostsState(
      posts: posts ?? this.posts,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class PostsNotifier extends StateNotifier<PostsState> {
  final Ref ref;

  PostsNotifier(this.ref) : super(PostsState());

  Future<void> loadPosts() async {
    state = state.copyWith(isLoading: true);
    try {
      final service = ref.read(postServiceProvider);
      final posts = await service.listar();
      state = state.copyWith(posts: posts, isLoading: false, error: null);
    } catch (e) {
      state = state.copyWith(
          isLoading: false, error: 'Error al cargar publicaciones');
    }
  }

  Future<void> refreshPosts() async {
    await loadPosts();
  }

  Future<void> loadUserPosts() async {
    // TODO: Implementar carga de posts del usuario
  }

  Future<void> deletePost(int postId) async {
    try {
      final service = ref.read(postServiceProvider);
      final success = await service.eliminar(postId);
      if (success) {
        state = state.copyWith(
          posts: state.posts.where((p) => p.id != postId).toList(),
        );
      }
    } catch (e) {
      state = state.copyWith(error: 'Error al eliminar la publicación');
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

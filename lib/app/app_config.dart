import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiert_movil/core/providers/auth_provider.dart';
import 'package:kiert_movil/layouts/auth_layout.dart';
import 'package:kiert_movil/layouts/main_layout.dart';
import 'package:kiert_movil/features/auth/login.dart';
import 'package:kiert_movil/features/auth/register.dart';
import 'package:kiert_movil/features/auth/forgot_password.dart';
import 'package:kiert_movil/features/auth/reset_password.dart';
import 'package:kiert_movil/features/community/feed.dart';
import 'package:kiert_movil/features/community/create_post.dart';
import 'package:kiert_movil/features/community/post_detail.dart';
import 'package:kiert_movil/features/community/mis_publicaciones.dart';
import 'package:kiert_movil/features/community/settings.dart';
import 'package:kiert_movil/features/profile/profile.dart';
import 'package:kiert_movil/features/perfil_autor/perfil_autor.dart';
import 'package:kiert_movil/features/chat/chat.dart';
import 'package:kiert_movil/core/environment.dart';

class AppConfig {
  static final router = GoRouter(
    initialLocation: '/comunidad',
    routes: [
      GoRoute(
          path: '/login',
          builder: (context, state) => const AuthLayout(child: LoginPage())),
      GoRoute(
          path: '/registro',
          builder: (context, state) => const AuthLayout(child: RegisterPage())),
      GoRoute(
          path: '/recuperar-contrasena',
          builder: (context, state) =>
              const AuthLayout(child: ForgotPasswordPage())),
      GoRoute(
        path: '/restablecer-contrasena',
        builder: (context, state) {
          final token = state.uri.queryParameters['token'];
          return AuthLayout(child: ResetPasswordPage(token: token));
        },
      ),
      GoRoute(
        path: '/comunidad',
        builder: (context, state) => const MainLayout(child: FeedPage()),
        routes: [
          GoRoute(
            path: 'nueva-publicacion',
            builder: (context, state) =>
                const MainLayout(child: CreatePostPage()),
          ),
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '0');
              return MainLayout(child: PostDetailPage(postId: id ?? 0));
            },
          ),
        ],
      ),
      GoRoute(
          path: '/mis-publicaciones',
          builder: (context, state) =>
              const MainLayout(child: MisPublicacionesPage())),
      GoRoute(
          path: '/perfil',
          builder: (context, state) => const MainLayout(child: ProfilePage())),
      GoRoute(
        path: '/usuario/:id',
        builder: (context, state) {
          final id = int.tryParse(state.pathParameters['id'] ?? '0');
          return MainLayout(child: PerfilAutorPage(usuarioId: id ?? 0));
        },
      ),
      GoRoute(
        path: '/chat',
        builder: (context, state) => const MainLayout(child: ChatPage()),
        routes: [
          GoRoute(
            path: ':usuarioId',
            builder: (context, state) {
              final id = int.tryParse(state.pathParameters['usuarioId'] ?? '0');
              return MainLayout(child: ChatPage(usuarioId: id));
            },
          ),
        ],
      ),
      GoRoute(
          path: '/ajustes',
          builder: (context, state) => const MainLayout(child: SettingsPage())),
    ],
    redirect: (context, state) {
      // TODO: Implementar autenticación
      return null;
    },
  );

  static final theme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: const Color(0xFF0D1117),
    cardColor: const Color(0xFF131A22),
    dividerColor: const Color(0xFF26313C),
    primaryColor: const Color(0xFF2DD4BF),
    colorScheme: const ColorScheme.dark(
      primary: Color(0xFF2DD4BF),
      secondary: Color(0xFF2DD4BF),
      surface: Color(0xFF131A22),
      background: Color(0xFF0D1117),
      error: Color(0xFFF85149),
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFFE6EDF3)),
      bodyMedium: TextStyle(color: Color(0xFFE6EDF3)),
      titleLarge: TextStyle(color: Color(0xFFE6EDF3)),
      titleMedium: TextStyle(color: Color(0xFFE6EDF3)),
      headlineMedium: TextStyle(color: Color(0xFFE6EDF3)),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF1B232C),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF26313C)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF26313C)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFF2DD4BF)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: Color(0xFFF85149)),
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF2DD4BF),
        foregroundColor: const Color(0xFF0D1117),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: const Color(0xFF2DD4BF)),
    ),
  );
}

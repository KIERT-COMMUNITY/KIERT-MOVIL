// lib/app/routes.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kiert_movil/core/guards/auth_guard.dart';

// Pantallas - RUTAS CORREGIDAS
import 'package:kiert_movil/features/auth/login.dart';
import 'package:kiert_movil/features/auth/register.dart';
import 'package:kiert_movil/features/auth/forgot_password.dart';
import 'package:kiert_movil/features/auth/reset_password.dart';
import 'package:kiert_movil/features/community/feed.dart';
import 'package:kiert_movil/features/community/post_detail.dart';
import 'package:kiert_movil/features/community/create_post.dart';
import 'package:kiert_movil/features/community/mis_publicaciones.dart';
import 'package:kiert_movil/features/profile/profile.dart';
import 'package:kiert_movil/features/perfil_autor/perfil_autor.dart';
import 'package:kiert_movil/features/chat/chat.dart';
import 'package:kiert_movil/features/community/settings.dart';

final router = GoRouter(
  initialLocation: '/comunidad',
  redirect: (context, state) {
    // Lógica de redirección
    return null;
  },
  routes: [
    // ============================================================
    // RUTAS DE AUTENTICACIÓN
    // ============================================================
    GoRoute(
      path: '/login',
      name: 'login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/registro',
      name: 'register',
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: '/recuperar-contrasena',
      name: 'forgot-password',
      builder: (context, state) => const ForgotPasswordPage(),
    ),
    GoRoute(
      path: '/restablecer-contrasena',
      name: 'reset-password',
      builder: (context, state) {
        final token = state.uri.queryParameters['token'];
        return ResetPasswordPage(token: token);
      },
    ),

    // ============================================================
    // RUTAS PRINCIPALES (CON AUTH)
    // ============================================================
    GoRoute(
      path: '/comunidad',
      name: 'feed',
      builder: (context, state) => const FeedPage(),
      routes: [
        GoRoute(
          path: 'nueva-publicacion',
          name: 'create-post',
          builder: (context, state) => const CreatePostPage(),
        ),
        GoRoute(
          path: ':id',
          name: 'post-detail',
          builder: (context, state) {
            final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
            return PostDetailPage(postId: id);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/mis-publicaciones',
      name: 'mis-publicaciones',
      builder: (context, state) => const MisPublicacionesPage(),
    ),
    GoRoute(
      path: '/perfil',
      name: 'profile',
      builder: (context, state) => const ProfilePage(),
    ),
    GoRoute(
      path: '/usuario/:id',
      name: 'perfil-autor',
      builder: (context, state) {
        final id = int.tryParse(state.pathParameters['id'] ?? '0') ?? 0;
        return PerfilAutorPage(usuarioId: id);
      },
    ),
    GoRoute(
      path: '/chat',
      name: 'chat',
      builder: (context, state) => const ChatPage(),
      routes: [
        GoRoute(
          path: ':usuarioId',
          name: 'chat-detail',
          builder: (context, state) {
            final usuarioId =
                int.tryParse(state.pathParameters['usuarioId'] ?? '0') ?? 0;
            return ChatPage(usuarioId: usuarioId);
          },
        ),
      ],
    ),
    GoRoute(
      path: '/ajustes',
      name: 'settings',
      builder: (context, state) => const SettingsPage(),
    ),

    // ============================================================
    // RUTA POR DEFECTO
    // ============================================================
    GoRoute(
      path: '/',
      redirect: (context, state) => '/comunidad',
    ),
    GoRoute(
      path: '/comunidad/:id',
      redirect: (context, state) {
        final id = state.pathParameters['id'];
        return '/comunidad/$id';
      },
    ),
  ],
);

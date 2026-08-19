import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/auth_provider.dart';

class AuthGuard {
  const AuthGuard();

  Future<bool> canActivate(
    BuildContext context,
    GoRouterState state,
    WidgetRef ref,
  ) async {
    final authState = ref.watch(authStateProvider);

    if (authState.user != null) {
      return true;
    }

    // Redirigir a login
    context.go('/login');
    return false;
  }
}

// Instancia única del guard
final authGuard = AuthGuard();

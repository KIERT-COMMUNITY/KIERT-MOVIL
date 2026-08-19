// lib/core/providers/auth_provider.dart
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiert_movil/core/models/user.dart';
import 'package:kiert_movil/core/services/auth_service.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref.read(authServiceProvider));
});

class AuthState {
  final User? user;
  final bool isLoading;
  final String? error;

  AuthState({this.user, this.isLoading = false, this.error});

  AuthState copyWith({User? user, bool? isLoading, String? error}) {
    return AuthState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final AuthService authService;

  AuthNotifier(this.authService) : super(AuthState()) {
    _loadUser();
  }

  Future<void> _loadUser() async {
    final user = await authService.getCurrentUser();
    state = state.copyWith(user: user);
  }

  // ✅ USUARIO DE PRUEBA - SIN BACKEND
  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, error: null);

    // 🔥 USUARIO DE PRUEBA FIJO
    // Email: test@kiert.com
    // Contraseña: Test1234
    if (email == 'test@kiert.com' && password == 'Test1234') {
      final user = User(
        id: 999,
        nombreUsuario: 'usuario_prueba',
        email: 'test@kiert.com',
        fotoPerfilUrl: null,
        bio: 'Usuario de prueba para Kiert',
        fotoPortadaUrl: null,
      );

      state = state.copyWith(user: user, isLoading: false);
      return true;
    }

    // 🔥 Si no es el usuario de prueba, intentar con el backend
    try {
      final result = await authService.login(email, password);
      if (result != null) {
        state = state.copyWith(user: result.usuario, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Credenciales incorrectas. Usa test@kiert.com / Test1234',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error de conexión. Usa test@kiert.com / Test1234',
      );
      return false;
    }
  }

  Future<bool> register({
    required String nombreUsuario,
    required String email,
    required String password,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    // ✅ REGISTRO DE PRUEBA - Sin backend
    if (email == 'test@kiert.com' || email.contains('test')) {
      final user = User(
        id: 999,
        nombreUsuario: nombreUsuario,
        email: email,
        fotoPerfilUrl: null,
        bio: 'Usuario de prueba',
        fotoPortadaUrl: null,
      );
      state = state.copyWith(user: user, isLoading: false);
      return true;
    }

    try {
      final result = await authService.register(
        nombreUsuario: nombreUsuario,
        email: email,
        password: password,
      );
      if (result != null) {
        state = state.copyWith(user: result.usuario, isLoading: false);
        return true;
      } else {
        state = state.copyWith(
          isLoading: false,
          error: 'Error al registrarse. Usa test@kiert.com / Test1234',
        );
        return false;
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: 'Error de conexión. Usa test@kiert.com / Test1234',
      );
      return false;
    }
  }

  Future<void> logout() async {
    await authService.logout();
    state = state.copyWith(user: null);
  }

  void updateUser(User user) {
    state = state.copyWith(user: user);
  }

  Future<void> solicitarRecuperacion(String email) async {
    await authService.solicitarRecuperacion(email);
  }

  Future<void> restablecerContrasena(String token, String password) async {
    await authService.restablecerContrasena(token, password);
  }
}

import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiert_movil/core/api/api_client.dart';
import 'package:kiert_movil/core/models/user.dart';

class AuthService {
  final ApiClient _api = ApiClient();
  String? _token;

  // ========== LOGIN ==========
  Future<AuthResponse?> login(String email, String password) async {
    try {
      print('📤 LOGIN Request: email=$email');
      final response = await _api.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );
      print('📥 LOGIN Response: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = response.data;
        final token = data['token'];
        final user = User.fromJson(data['usuario']);
        _token = token;
        await _saveToken(token);
        await _saveUser(user);
        await _api.setToken(token);
        return AuthResponse(token: token, usuario: user);
      }
      return null;
    } catch (e) {
      print('❌ LOGIN Error: $e');
      if (e is DioException) {
        print('📦 Response: ${e.response?.data}');
        print('📦 Status: ${e.response?.statusCode}');
      }
      return null;
    }
  }

  // ========== REGISTRO ==========
  Future<AuthResponse?> register({
    required String nombreUsuario,
    required String email,
    required String password,
  }) async {
    try {
      print('📤 REGISTER Request:');
      print('  nombreUsuario: $nombreUsuario');
      print('  email: $email');
      print('  password: $password');

      final data = {
        'nombreUsuario': nombreUsuario,
        'email': email,
        'password': password,
      };
      print('📤 JSON: $data');

      final response = await _api.post(
        '/auth/registro',
        data: data,
      );

      print('📥 REGISTER Response: ${response.statusCode}');
      print('📥 Data: ${response.data}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = response.data;
        final token = data['token'];
        final user = User.fromJson(data['usuario']);
        _token = token;
        await _saveToken(token);
        await _saveUser(user);
        await _api.setToken(token);
        return AuthResponse(token: token, usuario: user);
      }
      return null;
    } catch (e) {
      print('❌ REGISTER Error: $e');
      if (e is DioException) {
        print('📦 Response data: ${e.response?.data}');
        print('📦 Status code: ${e.response?.statusCode}');
        print('📦 Headers: ${e.response?.headers}');
      }
      return null;
    }
  }

  // ========== LOGOUT ==========
  Future<void> logout() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('usuario_actual');
    await _api.setToken('');
  }

  // ========== TOKEN ==========
  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  String? getTokenSync() {
    return _token;
  }

  // ========== USUARIO ACTUAL ==========
  Future<User?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('usuario_actual');
    if (userJson != null) {
      return User.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  // ========== OBTENER PERFIL ==========
  Future<User?> obtenerPerfil() async {
    try {
      final response = await _api.get('/perfil');
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _saveUser(user);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== ACTUALIZAR PERFIL ==========
  Future<User?> actualizarPerfil({
    String? nombreUsuario,
    String? email,
    String? bio,
  }) async {
    try {
      final Map<String, dynamic> data = {};
      if (nombreUsuario != null) data['nombreUsuario'] = nombreUsuario;
      if (email != null) data['email'] = email;
      if (bio != null) data['bio'] = bio;

      final response = await _api.patch('/perfil', data: data);
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _saveUser(user);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== SUBIR FOTO DE PERFIL ==========
  Future<User?> subirFotoMultipart(File archivo) async {
    try {
      final formData = FormData.fromMap({
        'archivo': await MultipartFile.fromFile(
          archivo.path,
          filename: archivo.path.split('/').last,
        ),
      });
      final response = await _api.postMultipart('/perfil/foto', formData);
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _saveUser(user);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== SUBIR FOTO DE PORTADA ==========
  Future<User?> subirFotoPortada(File archivo) async {
    try {
      final formData = FormData.fromMap({
        'archivo': await MultipartFile.fromFile(
          archivo.path,
          filename: archivo.path.split('/').last,
        ),
      });
      final response =
          await _api.postMultipart('/perfil/foto-portada', formData);
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        await _saveUser(user);
        return user;
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== RECUPERACIÓN DE CONTRASEÑA ==========
  Future<void> solicitarRecuperacion(String email) async {
    try {
      await _api.post('/auth/recuperar', data: {'email': email});
    } catch (e) {
      throw Exception('Error al solicitar recuperación de contraseña');
    }
  }

  Future<void> restablecerContrasena(String token, String password) async {
    try {
      await _api.post('/auth/restablecer', data: {
        'token': token,
        'password': password,
      });
    } catch (e) {
      throw Exception('Error al restablecer la contraseña');
    }
  }

  // ========== MÉTODOS PRIVADOS ==========
  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> _saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('usuario_actual', jsonEncode(user.toJson()));
  }
}

// ========== AUTH RESPONSE ==========
class AuthResponse {
  final String token;
  final User usuario;

  AuthResponse({required this.token, required this.usuario});
}

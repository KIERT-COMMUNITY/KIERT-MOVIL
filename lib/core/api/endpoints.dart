// lib/core/api/endpoints.dart
class Endpoints {
  static const String baseUrl = 'http://192.168.1.x:8080/api';

  // Auth
  static const String login = '/auth/login';
  static const String register = '/auth/registro';
  static const String perfil = '/perfil';

  // Posts
  static const String publicaciones = '/publicaciones';

  // Comentarios
  static const String comentarios = '/comentarios';

  // Chat
  static const String chat = '/chat';

  // Personalización
  static const String personalizacion = '/personalizacion';

  // Usuarios
  static const String usuarios = '/usuarios';
}

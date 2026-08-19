import 'package:dio/dio.dart';
import 'package:kiert_movil/core/api/api_client.dart';
import 'package:kiert_movil/core/models/chat.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final chatServiceProvider = Provider<ChatService>((ref) => ChatService());

class ChatService {
  final ApiClient _api = ApiClient();

  // ========== CONVERSACIONES ==========
  Future<List<Conversacion>> listarConversaciones() async {
    try {
      final response = await _api.get('/chat/conversaciones');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Conversacion.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  // ========== MENSAJES ==========
  Future<List<Mensaje>> listarMensajes(int usuarioId) async {
    try {
      final response = await _api.get('/chat/$usuarioId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Mensaje.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Mensaje?> enviarMensaje(int usuarioId, String contenido) async {
    try {
      final response = await _api.post(
        '/chat/$usuarioId',
        data: {'contenido': contenido},
      );
      if (response.statusCode == 200) {
        return Mensaje.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Mensaje?> enviarMensajeConArchivos(
      int usuarioId, FormData formData) async {
    try {
      final response = await _api.postMultipart(
        '/chat/$usuarioId/archivos',
        formData,
      );
      if (response.statusCode == 200) {
        return Mensaje.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== SOLICITUDES ==========
  Future<List<SolicitudContacto>> listarSolicitudes() async {
    try {
      final response = await _api.get('/chat/solicitudes');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => SolicitudContacto.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<SolicitudContacto?> enviarSolicitud(int usuarioId) async {
    try {
      final response = await _api.post(
        '/chat/solicitudes',
        data: {'usuarioId': usuarioId},
      );
      if (response.statusCode == 200) {
        return SolicitudContacto.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> aceptarSolicitud(int solicitudId) async {
    try {
      final response = await _api.put('/chat/solicitudes/$solicitudId/aceptar');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<bool> rechazarSolicitud(int solicitudId) async {
    try {
      final response =
          await _api.put('/chat/solicitudes/$solicitudId/rechazar');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  // ========== CONTACTOS ==========
  Future<bool> sonContactos(int usuarioId) async {
    try {
      final response = await _api.get('/chat/contactos/$usuarioId');
      return response.statusCode == 200 && response.data == true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> eliminarContacto(int usuarioId) async {
    try {
      final response = await _api.delete('/chat/contactos/$usuarioId');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<List<UsuarioDisponible>> listarUsuariosDisponibles() async {
    try {
      final response = await _api.get('/chat/usuarios/disponibles');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => UsuarioDisponible.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

// ===== MODELO DE USUARIO DISPONIBLE =====
class UsuarioDisponible {
  final int id;
  final String nombreUsuario;
  final String? fotoPerfilUrl;

  UsuarioDisponible({
    required this.id,
    required this.nombreUsuario,
    this.fotoPerfilUrl,
  });

  factory UsuarioDisponible.fromJson(Map<String, dynamic> json) {
    return UsuarioDisponible(
      id: json['id'],
      nombreUsuario: json['nombreUsuario'],
      fotoPerfilUrl: json['fotoPerfilUrl'],
    );
  }
}

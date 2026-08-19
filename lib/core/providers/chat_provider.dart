import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiert_movil/core/models/chat.dart';
import 'package:kiert_movil/core/services/chat_service.dart';

final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  return ChatNotifier(ref);
});

class ChatState {
  final List<Conversacion> conversaciones;
  final List<Mensaje> mensajes;
  final List<SolicitudContacto> solicitudes;
  final bool isLoading;
  final String? error;

  ChatState({
    this.conversaciones = const [],
    this.mensajes = const [],
    this.solicitudes = const [],
    this.isLoading = false,
    this.error,
  });

  ChatState copyWith({
    List<Conversacion>? conversaciones,
    List<Mensaje>? mensajes,
    List<SolicitudContacto>? solicitudes,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      conversaciones: conversaciones ?? this.conversaciones,
      mensajes: mensajes ?? this.mensajes,
      solicitudes: solicitudes ?? this.solicitudes,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  int get solicitudesPendientes {
    return solicitudes.where((s) => s.estado == 'PENDIENTE').length;
  }
}

class ChatNotifier extends StateNotifier<ChatState> {
  final Ref ref;

  ChatNotifier(this.ref) : super(ChatState()) {
    cargarConversaciones();
    cargarSolicitudes();
  }

  Future<void> cargarConversaciones() async {
    state = state.copyWith(isLoading: true);
    final service = ref.read(chatServiceProvider);
    final data = await service.listarConversaciones();
    state = state.copyWith(conversaciones: data, isLoading: false);
  }

  Future<void> cargarMensajes(int usuarioId) async {
    state = state.copyWith(isLoading: true);
    final service = ref.read(chatServiceProvider);
    final data = await service.listarMensajes(usuarioId);
    state = state.copyWith(mensajes: data, isLoading: false);
  }

  Future<void> cargarSolicitudes() async {
    final service = ref.read(chatServiceProvider);
    final data = await service.listarSolicitudes();
    state = state.copyWith(solicitudes: data);
  }

  Future<bool> enviarMensaje({
    required int usuarioId,
    required String contenido,
  }) async {
    final service = ref.read(chatServiceProvider);
    final mensaje = await service.enviarMensaje(usuarioId, contenido);
    if (mensaje != null) {
      state = state.copyWith(
        mensajes: [...state.mensajes, mensaje],
      );
      return true;
    }
    return false;
  }

  Future<bool> enviarSolicitud(int usuarioId) async {
    final service = ref.read(chatServiceProvider);
    final solicitud = await service.enviarSolicitud(usuarioId);
    if (solicitud != null) {
      await cargarSolicitudes();
      return true;
    }
    return false;
  }

  Future<bool> aceptarSolicitud(int solicitudId) async {
    final service = ref.read(chatServiceProvider);
    final success = await service.aceptarSolicitud(solicitudId);
    if (success) {
      await cargarSolicitudes();
      await cargarConversaciones();
    }
    return success;
  }

  Future<bool> rechazarSolicitud(int solicitudId) async {
    final service = ref.read(chatServiceProvider);
    final success = await service.rechazarSolicitud(solicitudId);
    if (success) {
      await cargarSolicitudes();
    }
    return success;
  }

  String getNombreUsuario(int usuarioId) {
    final conv = state.conversaciones.firstWhere(
      (c) => c.usuarioId == usuarioId,
      orElse: () => Conversacion(
        usuarioId: usuarioId,
        nombreUsuario: 'Usuario',
        noLeidos: 0,
      ),
    );
    return conv.nombreUsuario;
  }

  Future<bool> sonContactos(int usuarioId) async {
    final service = ref.read(chatServiceProvider);
    return await service.sonContactos(usuarioId);
  }

  Future<bool> tieneSolicitudPendiente(int usuarioId) async {
    return state.solicitudes
        .any((s) => s.usuarioId == usuarioId && s.estado == 'PENDIENTE');
  }
}

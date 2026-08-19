class Conversacion {
  final int usuarioId;
  final String nombreUsuario;
  final String? fotoPerfilUrl;
  final String? ultimoMensaje;
  final String? ultimaConexion;
  final int noLeidos;

  Conversacion({
    required this.usuarioId,
    required this.nombreUsuario,
    this.fotoPerfilUrl,
    this.ultimoMensaje,
    this.ultimaConexion,
    this.noLeidos = 0,
  });

  factory Conversacion.fromJson(Map<String, dynamic> json) {
    return Conversacion(
      usuarioId: json['usuarioId'],
      nombreUsuario: json['nombreUsuario'],
      fotoPerfilUrl: json['fotoPerfilUrl'],
      ultimoMensaje: json['ultimoMensaje'],
      ultimaConexion: json['ultimaConexion'],
      noLeidos: json['noLeidos'] ?? 0,
    );
  }
}

class MensajeArchivo {
  final int? id;
  final String nombre;
  final String url;
  final String tipo;
  final int? pesoKb;
  final bool? esSensible;

  MensajeArchivo({
    this.id,
    required this.nombre,
    required this.url,
    required this.tipo,
    this.pesoKb,
    this.esSensible,
  });

  factory MensajeArchivo.fromJson(Map<String, dynamic> json) {
    return MensajeArchivo(
      id: json['id'],
      nombre: json['nombre'],
      url: json['url'],
      tipo: json['tipo'],
      pesoKb: json['pesoKb'],
      esSensible: json['esSensible'],
    );
  }
}

class Mensaje {
  final int id;
  final int emisorId;
  final String contenido;
  final String fechaEnvio;
  final bool propio;
  final List<MensajeArchivo>? archivos;
  final String? tipoMensaje;

  Mensaje({
    required this.id,
    required this.emisorId,
    required this.contenido,
    required this.fechaEnvio,
    required this.propio,
    this.archivos,
    this.tipoMensaje,
  });

  factory Mensaje.fromJson(Map<String, dynamic> json) {
    return Mensaje(
      id: json['id'],
      emisorId: json['emisorId'],
      contenido: json['contenido'],
      fechaEnvio: json['fechaEnvio'],
      propio: json['propio'] ?? false,
      archivos: (json['archivos'] as List?)
          ?.map((e) => MensajeArchivo.fromJson(e))
          .toList(),
      tipoMensaje: json['tipoMensaje'],
    );
  }
}

class SolicitudContacto {
  final int id;
  final int usuarioId;
  final String nombreUsuario;
  final String? fotoPerfilUrl;
  final String estado; // PENDIENTE, ACEPTADA, RECHAZADA
  final String fechaSolicitud;

  SolicitudContacto({
    required this.id,
    required this.usuarioId,
    required this.nombreUsuario,
    this.fotoPerfilUrl,
    required this.estado,
    required this.fechaSolicitud,
  });

  factory SolicitudContacto.fromJson(Map<String, dynamic> json) {
    return SolicitudContacto(
      id: json['id'],
      usuarioId: json['usuarioId'],
      nombreUsuario: json['nombreUsuario'],
      fotoPerfilUrl: json['fotoPerfilUrl'],
      estado: json['estado'],
      fechaSolicitud: json['fechaSolicitud'],
    );
  }
}

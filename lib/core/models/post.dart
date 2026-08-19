class Post {
  final int id;
  final String titulo;
  final String categoria;
  final String descripcion;
  final String? link;
  final Autor autor;
  final List<Adjunto> adjuntos;
  final String fechaCreacion;
  final int totalComentarios;
  final int? likes;
  final int? comentarios;

  Post({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.descripcion,
    this.link,
    required this.autor,
    this.adjuntos = const [],
    required this.fechaCreacion,
    this.totalComentarios = 0,
    this.likes,
    this.comentarios,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'],
      titulo: json['titulo'],
      categoria: json['categoria'],
      descripcion: json['descripcion'],
      link: json['link'],
      autor: Autor.fromJson(json['autor']),
      adjuntos: (json['adjuntos'] as List?)
              ?.map((e) => Adjunto.fromJson(e))
              .toList() ??
          [],
      fechaCreacion: json['fechaCreacion'],
      totalComentarios: json['totalComentarios'] ?? 0,
      likes: json['likes'],
      comentarios: json['comentarios'],
    );
  }
}

class Autor {
  final int id;
  final String nombreUsuario;
  final String? email;
  final String? marcoId;
  final String? fotoPerfilUrl;

  Autor({
    required this.id,
    required this.nombreUsuario,
    this.email,
    this.marcoId,
    this.fotoPerfilUrl,
  });

  factory Autor.fromJson(Map<String, dynamic> json) {
    return Autor(
      id: json['id'],
      nombreUsuario: json['nombreUsuario'],
      email: json['email'],
      marcoId: json['marcoId'],
      fotoPerfilUrl: json['fotoPerfilUrl'],
    );
  }
}

class Adjunto {
  final int id;
  final String tipo;
  final String nombre;
  final String url;
  final int? pesoKb;
  final int? duracionSegundos;

  Adjunto({
    required this.id,
    required this.tipo,
    required this.nombre,
    required this.url,
    this.pesoKb,
    this.duracionSegundos,
  });

  factory Adjunto.fromJson(Map<String, dynamic> json) {
    return Adjunto(
      id: json['id'],
      tipo: json['tipo'],
      nombre: json['nombre'],
      url: json['url'],
      pesoKb: json['pesoKb'],
      duracionSegundos: json['duracionSegundos'],
    );
  }
}

// ===== COMENTARIOS =====
class Comentario {
  final int id;
  final Autor autor;
  final String contenido;
  final String fechaCreacion;
  final Reacciones? reacciones;
  final List<Respuesta>? respuestas;
  final int? totalRespuestas;

  Comentario({
    required this.id,
    required this.autor,
    required this.contenido,
    required this.fechaCreacion,
    this.reacciones,
    this.respuestas,
    this.totalRespuestas,
  });

  factory Comentario.fromJson(Map<String, dynamic> json) {
    return Comentario(
      id: json['id'],
      autor: Autor.fromJson(json['autor']),
      contenido: json['contenido'],
      fechaCreacion: json['fechaCreacion'],
      reacciones: json['reacciones'] != null
          ? Reacciones.fromJson(json['reacciones'])
          : null,
      respuestas: (json['respuestas'] as List?)
          ?.map((e) => Respuesta.fromJson(e))
          .toList(),
      totalRespuestas: json['totalRespuestas'],
    );
  }

  Comentario copyWith({
    int? id,
    Autor? autor,
    String? contenido,
    String? fechaCreacion,
    Reacciones? reacciones,
    List<Respuesta>? respuestas,
    int? totalRespuestas,
  }) {
    return Comentario(
      id: id ?? this.id,
      autor: autor ?? this.autor,
      contenido: contenido ?? this.contenido,
      fechaCreacion: fechaCreacion ?? this.fechaCreacion,
      reacciones: reacciones ?? this.reacciones,
      respuestas: respuestas ?? this.respuestas,
      totalRespuestas: totalRespuestas ?? this.totalRespuestas,
    );
  }
}

// ===== RESPUESTAS =====
class Respuesta {
  final int id;
  final Autor autor;
  final String contenido;
  final String fechaCreacion;
  final Reacciones? reacciones;
  final bool? eliminado;

  Respuesta({
    required this.id,
    required this.autor,
    required this.contenido,
    required this.fechaCreacion,
    this.reacciones,
    this.eliminado,
  });

  factory Respuesta.fromJson(Map<String, dynamic> json) {
    return Respuesta(
      id: json['id'],
      autor: Autor.fromJson(json['autor']),
      contenido: json['contenido'],
      fechaCreacion: json['fechaCreacion'],
      reacciones: json['reacciones'] != null
          ? Reacciones.fromJson(json['reacciones'])
          : null,
      eliminado: json['eliminado'],
    );
  }
}

// ===== REACCIONES =====
class Reacciones {
  final int likes;
  final int loves;
  final int? hahas;
  final int? wows;
  final int? sads;
  final int? angrys;

  Reacciones({
    this.likes = 0,
    this.loves = 0,
    this.hahas,
    this.wows,
    this.sads,
    this.angrys,
  });

  factory Reacciones.fromJson(Map<String, dynamic> json) {
    return Reacciones(
      likes: json['likes'] ?? 0,
      loves: json['loves'] ?? 0,
      hahas: json['hahas'],
      wows: json['wows'],
      sads: json['sads'],
      angrys: json['angrys'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'likes': likes,
      'loves': loves,
      'hahas': hahas,
      'wows': wows,
      'sads': sads,
      'angrys': angrys,
    };
  }
}

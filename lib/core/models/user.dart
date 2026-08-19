// lib/core/models/user.dart - Asegurar que tenga copyWith
class User {
  final int id;
  final String nombreUsuario;
  final String email;
  final String? fotoPerfilUrl;
  final String? bio;
  final String? fotoPortadaUrl;

  User({
    required this.id,
    required this.nombreUsuario,
    required this.email,
    this.fotoPerfilUrl,
    this.bio,
    this.fotoPortadaUrl,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nombreUsuario: json['nombreUsuario'],
      email: json['email'],
      fotoPerfilUrl: json['fotoPerfilUrl'],
      bio: json['bio'],
      fotoPortadaUrl: json['fotoPortadaUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nombreUsuario': nombreUsuario,
      'email': email,
      'fotoPerfilUrl': fotoPerfilUrl,
      'bio': bio,
      'fotoPortadaUrl': fotoPortadaUrl,
    };
  }

  User copyWith({
    int? id,
    String? nombreUsuario,
    String? email,
    String? fotoPerfilUrl,
    String? bio,
    String? fotoPortadaUrl,
  }) {
    return User(
      id: id ?? this.id,
      nombreUsuario: nombreUsuario ?? this.nombreUsuario,
      email: email ?? this.email,
      fotoPerfilUrl: fotoPerfilUrl ?? this.fotoPerfilUrl,
      bio: bio ?? this.bio,
      fotoPortadaUrl: fotoPortadaUrl ?? this.fotoPortadaUrl,
    );
  }
}

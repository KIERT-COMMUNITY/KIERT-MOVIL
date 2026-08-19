class Personalizacion {
  final int id;
  final int usuarioId;
  final String temaId;
  final String marcoId;
  final String fondoId;
  final String fotoPerfilUrl;
  final String fotoPortadaUrl;

  Personalizacion({
    required this.id,
    required this.usuarioId,
    required this.temaId,
    required this.marcoId,
    required this.fondoId,
    required this.fotoPerfilUrl,
    required this.fotoPortadaUrl,
  });

  factory Personalizacion.fromJson(Map<String, dynamic> json) {
    return Personalizacion(
      id: json['id'],
      usuarioId: json['usuarioId'],
      temaId: json['temaId'] ?? 'default',
      marcoId: json['marcoId'] ?? 'none',
      fondoId: json['fondoId'] ?? 'default',
      fotoPerfilUrl: json['fotoPerfilUrl'] ?? '',
      fotoPortadaUrl: json['fotoPortadaUrl'] ?? '',
    );
  }
}

class Marco {
  final String id;
  final String nombre;
  final String urlImagen;
  final String tipo;
  final int precio;
  final bool gratis;

  Marco({
    required this.id,
    required this.nombre,
    required this.urlImagen,
    required this.tipo,
    required this.precio,
    required this.gratis,
  });

  factory Marco.fromJson(Map<String, dynamic> json) {
    return Marco(
      id: json['id'],
      nombre: json['nombre'],
      urlImagen: json['urlImagen'],
      tipo: json['tipo'],
      precio: json['precio'] ?? 0,
      gratis: json['gratis'] ?? true,
    );
  }
}

class Fondo {
  final String id;
  final String nombre;
  final String urlImagen;
  final String tipo;
  final String gradiente;
  final int precio;
  final bool gratis;

  Fondo({
    required this.id,
    required this.nombre,
    required this.urlImagen,
    required this.tipo,
    required this.gradiente,
    required this.precio,
    required this.gratis,
  });

  factory Fondo.fromJson(Map<String, dynamic> json) {
    return Fondo(
      id: json['id'],
      nombre: json['nombre'],
      urlImagen: json['urlImagen'],
      tipo: json['tipo'],
      gradiente: json['gradiente'] ?? '',
      precio: json['precio'] ?? 0,
      gratis: json['gratis'] ?? true,
    );
  }
}

class MarcoItem {
  final String id;
  final String name;
  final String borderColor;
  final String borderStyle;
  final String shadow;
  final String clipPath;
  final String gradient;
  final bool isFree;
  final String description;

  MarcoItem({
    required this.id,
    required this.name,
    required this.borderColor,
    required this.borderStyle,
    required this.shadow,
    required this.clipPath,
    required this.gradient,
    required this.isFree,
    required this.description,
  });
}

class ColorTheme {
  final String id;
  final String name;
  final List<String> colors;
  final String gradient;
  final bool isFree;

  ColorTheme({
    required this.id,
    required this.name,
    required this.colors,
    required this.gradient,
    required this.isFree,
  });
}

class FondoItem {
  final String id;
  final String name;
  final String gradient;
  final bool isFree;
  final String description;

  FondoItem({
    required this.id,
    required this.name,
    required this.gradient,
    required this.isFree,
    required this.description,
  });
}

class PersonalizacionData {
  static List<ColorTheme> get colorThemes => [
        ColorTheme(
            id: 'default',
            name: 'Default',
            colors: ['#2dd4bf', '#0d1117'],
            gradient: 'linear-gradient(135deg, #2dd4bf, #0d1117)',
            isFree: true),
        ColorTheme(
            id: 'dark',
            name: 'Dark',
            colors: ['#a29bfe', '#1a1a2e'],
            gradient: 'linear-gradient(135deg, #a29bfe, #1a1a2e)',
            isFree: true),
        ColorTheme(
            id: 'light',
            name: 'Light',
            colors: ['#2dd4bf', '#ffffff'],
            gradient: 'linear-gradient(135deg, #2dd4bf, #ffffff)',
            isFree: true),
        ColorTheme(
            id: 'sunset',
            name: 'Sunset',
            colors: ['#ff6b6b', '#feca57', '#fd79a8'],
            gradient: 'linear-gradient(135deg, #ff6b6b, #feca57, #fd79a8)',
            isFree: true),
        ColorTheme(
            id: 'ocean',
            name: 'Ocean',
            colors: ['#00b894', '#00cec9', '#0984e3'],
            gradient: 'linear-gradient(135deg, #00b894, #00cec9, #0984e3)',
            isFree: true),
        ColorTheme(
            id: 'galaxy',
            name: 'Galaxy',
            colors: ['#2d3436', '#6c5ce7', '#fd79a8'],
            gradient: 'linear-gradient(135deg, #2d3436, #6c5ce7, #fd79a8)',
            isFree: true),
      ];

  static List<MarcoItem> get marcosData => [
        MarcoItem(
            id: 'none',
            name: 'Sin marco',
            borderColor: 'transparent',
            borderStyle: 'none',
            shadow: 'none',
            clipPath: 'none',
            gradient: 'none',
            isFree: true,
            description: 'Sin marco'),
        MarcoItem(
            id: 'classic',
            name: 'Classic',
            borderColor: '#2dd4bf',
            borderStyle: '4px solid #2dd4bf',
            shadow: 'none',
            clipPath: 'none',
            gradient: 'none',
            isFree: true,
            description: 'Borde elegante'),
        MarcoItem(
            id: 'gold',
            name: 'Gold',
            borderColor: '#f9ca24',
            borderStyle: '4px solid #f9ca24',
            shadow: '0 0 25px rgba(249,202,36,0.5)',
            clipPath: 'none',
            gradient: 'none',
            isFree: true,
            description: 'Brillo dorado'),
        MarcoItem(
            id: 'rainbow',
            name: 'Rainbow',
            borderColor: 'transparent',
            borderStyle: '4px solid transparent',
            shadow: '0 0 30px rgba(255,107,107,0.4)',
            clipPath: 'none',
            gradient:
                'linear-gradient(135deg, #ff6b6b, #feca57, #55efc4, #0984e3, #6c5ce7)',
            isFree: true,
            description: 'Colores arcoíris'),
      ];

  static List<FondoItem> get fondosData => [
        FondoItem(
            id: 'default',
            name: 'Default',
            gradient: 'linear-gradient(135deg, #0d1117, #161b22)',
            isFree: true,
            description: 'Estilo clásico'),
        FondoItem(
            id: 'ocean',
            name: 'Ocean',
            gradient: 'linear-gradient(135deg, #00b894, #00cec9, #0984e3)',
            isFree: true,
            description: 'Profundidad marina'),
        FondoItem(
            id: 'sunset',
            name: 'Sunset',
            gradient: 'linear-gradient(135deg, #ff6b6b, #feca57, #fd79a8)',
            isFree: true,
            description: 'Cálidos tonos'),
      ];
}

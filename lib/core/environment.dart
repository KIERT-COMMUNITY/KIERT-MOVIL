class Environment {
  static const bool production = false;
  static const String apiUrl = 'http://localhost:8080/api';
  static const String supabaseUrl = 'LINK SUPABASE.ICO';
  static const String supabaseBucket = 'kiert-files';
  static const String cloudinaryCloudName = 'zopnporu';
  static const String cloudinaryUploadPreset = 'kiert-preset';

  // ===== RUTAS DE IMÁGENES =====
  static const String logoPath = 'assets/images/logokiert.png';
  static const String bannerDestacadoPath = 'assets/images/banner/banner.jpg';

  static const List<String> anunciosPaths = [
    'assets/images/anuncio-banner/dianbanner1.jpg',
    'assets/images/anuncio-banner/yrelisbanner2.jpg',
    'assets/images/anuncio-banner/herlizbanner3.jpg',
    'assets/images/anuncio-banner/karnilbanner4.jpg',
    'assets/images/anuncio-banner/cykabanner5.jpg',
  ];
}

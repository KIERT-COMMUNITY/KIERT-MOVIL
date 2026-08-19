import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kiert_movil/core/providers/auth_provider.dart';
import 'package:kiert_movil/core/providers/personalizacion_provider.dart';
import 'package:kiert_movil/core/services/user_service.dart';
import 'package:kiert_movil/core/services/personalizacion_service.dart';
import 'package:kiert_movil/core/models/user.dart';

class PerfilAutorPage extends ConsumerStatefulWidget {
  final int usuarioId;

  const PerfilAutorPage({super.key, required this.usuarioId});

  @override
  ConsumerState<PerfilAutorPage> createState() => _PerfilAutorPageState();
}

class _PerfilAutorPageState extends ConsumerState<PerfilAutorPage> {
  User? _autor;
  bool _cargando = true;
  String? _errorMsg;

  String _autorMarcoId = 'none';
  String _autorFondoId = 'default';
  String _autorFotoPerfil = '';

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() async {
    setState(() => _cargando = true);

    final authState = ref.read(authStateProvider);

    if (authState.user?.id == widget.usuarioId) {
      if (mounted) context.go('/perfil');
      return;
    }

    try {
      final userService = ref.read(userServiceProvider);
      final user = await userService.obtenerUsuarioPorId(widget.usuarioId);

      if (user != null) {
        setState(() => _autor = user);
        _autorFotoPerfil = user.fotoPerfilUrl ?? '';
      } else {
        setState(() => _errorMsg = 'Usuario no encontrado');
      }

      final personalizacionService = ref.read(personalizacionServiceProvider);
      final personalizacion = await personalizacionService
          .obtenerPersonalizacionPorUsuario(widget.usuarioId);

      if (personalizacion != null) {
        setState(() {
          _autorMarcoId = personalizacion.marcoId;
          _autorFondoId = personalizacion.fondoId;
          if (personalizacion.fotoPerfilUrl.isNotEmpty) {
            _autorFotoPerfil = personalizacion.fotoPerfilUrl;
          }
        });
      }

      setState(() => _cargando = false);
    } catch (e) {
      setState(() {
        _errorMsg = 'Error al cargar el perfil';
        _cargando = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_cargando) {
      return const Scaffold(
        backgroundColor: Color(0xFF0D1117),
        body:
            Center(child: CircularProgressIndicator(color: Color(0xFF2DD4BF))),
      );
    }

    if (_errorMsg != null || _autor == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, size: 48, color: Colors.grey[600]),
              const SizedBox(height: 16),
              Text(_errorMsg ?? 'Usuario no encontrado',
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/comunidad'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DD4BF),
                  foregroundColor: const Color(0xFF0D1117),
                ),
                child: const Text('Volver'),
              ),
            ],
          ),
        ),
      );
    }

    final user = _autor!;

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: Text(
          '@${user.nombreUsuario}',
          style: const TextStyle(color: Colors.white),
        ),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/comunidad'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: _parseGradient(_autorFondoId),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[800]!),
          ),
          child: Column(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: _parseMarcoBorder(_autorMarcoId),
                  boxShadow: _parseMarcoShadow(_autorMarcoId),
                  gradient: _parseMarcoGradient(_autorMarcoId),
                ),
                child: Padding(
                  padding: _autorMarcoId == 'none'
                      ? EdgeInsets.zero
                      : const EdgeInsets.all(4),
                  child: ClipOval(
                    child: _autorFotoPerfil.isNotEmpty
                        ? CachedNetworkImage(
                            imageUrl: _autorFotoPerfil,
                            fit: BoxFit.cover,
                            placeholder: (context, url) => Container(
                              color: Colors.grey[800],
                              child: Center(
                                child: Text(
                                  user.nombreUsuario[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            errorWidget: (context, url, error) => Container(
                              color: Colors.grey[800],
                              child: Center(
                                child: Text(
                                  user.nombreUsuario[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 32,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          )
                        : Container(
                            color: Colors.grey[800],
                            child: Center(
                              child: Text(
                                user.nombreUsuario[0].toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                '@${user.nombreUsuario}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (user.bio != null && user.bio!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    user.bio!,
                    style: TextStyle(color: Colors.grey[400], fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                ),
              const SizedBox(height: 16),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey[800]!.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildInfoRow('Usuario', user.nombreUsuario),
                    _buildInfoRow('Email', user.email),
                    _buildInfoRow('Marco', _autorMarcoId),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            '$label:',
            style: TextStyle(color: Colors.grey[500], fontSize: 13),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(color: Colors.white, fontSize: 13),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Gradient _parseGradient(String fondoId) {
    final gradients = {
      'default': const LinearGradient(
        colors: [Color(0xFF0D1117), Color(0xFF161B22)],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      ),
      'dark': const LinearGradient(
        colors: [Color(0xFF1A1A2E), Color(0xFF0D1117)],
      ),
      'ocean': const LinearGradient(
        colors: [Color(0xFF00B894), Color(0xFF00CEC9), Color(0xFF0984E3)],
      ),
      'sunset': const LinearGradient(
        colors: [Color(0xFFFF6B6B), Color(0xFFFECA57), Color(0xFFFD79A8)],
      ),
    };
    return gradients[fondoId] ?? gradients['default']!;
  }

  Border _parseMarcoBorder(String marcoId) {
    if (marcoId == 'none') return Border.all(color: Colors.transparent);
    const borderColors = {
      'classic': Color(0xFF2DD4BF),
      'gold': Color(0xFFF9CA24),
      'silver': Color(0xFFB2BEC3),
      'neon': Color(0xFFFD79A8),
      'cyber': Color(0xFF00D4FF),
      'elite': Color(0xFF6C5CE7),
    };
    final color = borderColors[marcoId] ?? Colors.teal;
    final width = marcoId == 'double' ? 6.0 : 4.0;
    return Border.all(color: color, width: width);
  }

  List<BoxShadow>? _parseMarcoShadow(String marcoId) {
    if (marcoId == 'none') return null;
    final shadowColors = {
      'gold': const Color(0xFFF9CA24).withOpacity(0.5),
      'silver': const Color(0xFFB2BEC3).withOpacity(0.4),
      'neon': const Color(0xFFFD79A8).withOpacity(0.6),
      'cyber': const Color(0xFF00D4FF).withOpacity(0.6),
      'elite': const Color(0xFF6C5CE7).withOpacity(0.6),
    };
    final color = shadowColors[marcoId];
    if (color == null) return null;
    return [BoxShadow(color: color, blurRadius: 25, spreadRadius: 2)];
  }

  Gradient? _parseMarcoGradient(String marcoId) {
    final gradients = {
      'rainbow': const LinearGradient(
        colors: [
          Color(0xFFFF6B6B),
          Color(0xFFFECA57),
          Color(0xFF55EFC4),
          Color(0xFF0984E3),
          Color(0xFF6C5CE7)
        ],
      ),
      'pastel': const LinearGradient(
        colors: [
          Color(0xFFFD79A8),
          Color(0xFFFDCB6E),
          Color(0xFFA29BFE),
          Color(0xFF55EFC4)
        ],
      ),
      'ocean': const LinearGradient(
        colors: [Color(0xFF00B894), Color(0xFF00CEC9), Color(0xFF0984E3)],
      ),
      'galaxy': const LinearGradient(
        colors: [Color(0xFF2D3436), Color(0xFF6C5CE7), Color(0xFFFD79A8)],
      ),
    };
    return gradients[marcoId];
  }
}

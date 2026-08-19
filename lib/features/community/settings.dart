import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kiert_movil/core/models/personalizacion.dart';
import 'package:kiert_movil/core/providers/auth_provider.dart';
import 'package:kiert_movil/core/providers/personalizacion_provider.dart';
import 'package:kiert_movil/core/services/personalizacion_service.dart';

class SettingsPage extends ConsumerStatefulWidget {
  const SettingsPage({super.key});

  @override
  ConsumerState<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  String _selectedTheme = 'default';
  String _selectedFrame = 'none';
  String _selectedFondo = 'default';
  bool _isLoading = false;
  String? _errorMsg;
  String? _exitoMsg;

  @override
  void initState() {
    super.initState();
    _cargarDatos();
  }

  void _cargarDatos() {
    final authState = ref.read(authStateProvider);
    final personalizacion = ref.read(personalizacionStateProvider);

    if (personalizacion.personalizacion != null) {
      _selectedTheme = personalizacion.personalizacion!.temaId;
      _selectedFrame = personalizacion.personalizacion!.marcoId;
      _selectedFondo = personalizacion.personalizacion!.fondoId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    if (authState.user == null) {
      return Scaffold(
        backgroundColor: const Color(0xFF0D1117),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, color: Colors.grey, size: 48),
              const SizedBox(height: 16),
              const Text('Debes iniciar sesión',
                  style: TextStyle(color: Colors.grey)),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/login'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2DD4BF),
                  foregroundColor: const Color(0xFF0D1117),
                ),
                child: const Text('Iniciar sesión'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0D1117),
        title: const Text('Ajustes', style: TextStyle(color: Colors.white)),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go('/perfil'),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            if (_errorMsg != null) _buildError(),
            if (_exitoMsg != null) _buildSuccess(),
            _buildTemasSection(),
            const SizedBox(height: 16),
            _buildMarcosSection(),
            const SizedBox(height: 16),
            _buildFondosSection(),
            const SizedBox(height: 16),
            _buildApplyButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildError() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red),
      ),
      child: Row(
        children: [
          Expanded(
              child:
                  Text(_errorMsg!, style: const TextStyle(color: Colors.red))),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.red),
            onPressed: () => setState(() => _errorMsg = null),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccess() {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.green.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green),
      ),
      child: Row(
        children: [
          Expanded(
              child: Text(_exitoMsg!,
                  style: const TextStyle(color: Colors.green))),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.green),
            onPressed: () => setState(() => _exitoMsg = null),
          ),
        ],
      ),
    );
  }

  Widget _buildTemasSection() {
    final themes = PersonalizacionData.colorThemes;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A22).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Temas de color',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Se aplica al fondo de toda la página',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: themes.map((theme) {
              final isSelected = _selectedTheme == theme.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedTheme = theme.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2DD4BF).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2DD4BF)
                          : Colors.grey[800]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: _parseGradient(theme.gradient),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        theme.name,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF2DD4BF)
                              : Colors.grey[400],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMarcosSection() {
    final marcos = PersonalizacionData.marcosData;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A22).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Marcos de perfil',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Se aplica a tu foto de perfil',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: marcos.map((marco) {
              final isSelected = _selectedFrame == marco.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedFrame = marco.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2DD4BF).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2DD4BF)
                          : Colors.grey[800]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: _parseMarcoBorder(marco),
                          boxShadow: _parseMarcoShadow(marco),
                          gradient: _parseMarcoGradient(marco),
                        ),
                        child: const Center(
                          child:
                              Icon(Icons.person, color: Colors.white, size: 24),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        marco.name,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF2DD4BF)
                              : Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildFondosSection() {
    final fondos = PersonalizacionData.fondosData;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A22).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Fondos de perfil',
            style: TextStyle(
                color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Text(
            'Se aplica al fondo de tu perfil',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: fondos.map((fondo) {
              final isSelected = _selectedFondo == fondo.id;
              return GestureDetector(
                onTap: () => setState(() => _selectedFondo = fondo.id),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: isSelected
                        ? const Color(0xFF2DD4BF).withOpacity(0.1)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: isSelected
                          ? const Color(0xFF2DD4BF)
                          : Colors.grey[800]!,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        width: 60,
                        height: 40,
                        decoration: BoxDecoration(
                          gradient: _parseGradient(fondo.gradient),
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        fondo.name,
                        style: TextStyle(
                          color: isSelected
                              ? const Color(0xFF2DD4BF)
                              : Colors.grey[400],
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildApplyButton() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF131A22).withOpacity(0.6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[800]!),
      ),
      child: Column(
        children: [
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _isLoading ? null : _aplicarPersonalizacion,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2DD4BF),
                foregroundColor: const Color(0xFF0D1117),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Color(0xFF0D1117),
                      ),
                    )
                  : const Text(
                      'Aplicar personalización',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Los cambios se aplicarán en toda la plataforma',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _aplicarPersonalizacion() async {
    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    final success = await ref
        .read(personalizacionStateProvider.notifier)
        .guardarPersonalizacion(
          temaId: _selectedTheme,
          marcoId: _selectedFrame,
          fondoId: _selectedFondo,
        );

    setState(() {
      _isLoading = false;
      if (success) {
        _exitoMsg = '✨ Personalización aplicada correctamente';
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _exitoMsg = null);
        });
      } else {
        _errorMsg = 'Error al aplicar la personalización';
        Future.delayed(const Duration(seconds: 3), () {
          if (mounted) setState(() => _errorMsg = null);
        });
      }
    });
  }

  Gradient _parseGradient(String gradientStr) {
    return const LinearGradient(
      colors: [Color(0xFF2DD4BF), Color(0xFF0D1117)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }

  Border _parseMarcoBorder(MarcoItem marco) {
    if (marco.id == 'none') return Border.all(color: Colors.transparent);
    return Border.all(color: Colors.grey[700]!, width: 2);
  }

  List<BoxShadow>? _parseMarcoShadow(MarcoItem marco) {
    if (marco.shadow == 'none') return null;
    return [
      BoxShadow(
        blurRadius: 8,
        spreadRadius: 2,
        color: Colors.white.withOpacity(0.1),
      ),
    ];
  }

  Gradient? _parseMarcoGradient(MarcoItem marco) {
    if (marco.gradient == 'none') return null;
    return const LinearGradient(
      colors: [Color(0xFFFF6B6B), Color(0xFFFECA57), Color(0xFF55EFC4)],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );
  }
}

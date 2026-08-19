// lib/features/community/create_post.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:kiert_movil/core/providers/auth_provider.dart';
import 'package:kiert_movil/core/providers/post_provider.dart';

class CreatePostPage extends ConsumerStatefulWidget {
  const CreatePostPage({super.key});

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  final _formKey = GlobalKey<FormState>();
  final _tituloController = TextEditingController();
  final _descripcionController = TextEditingController();
  final _linkController = TextEditingController();
  String _categoriaSeleccionada = 'caso-hacking';
  List<File> _archivos = [];
  bool _isLoading = false;
  String? _errorMsg;

  final List<Map<String, String>> _categorias = [
    {'valor': 'caso-hacking', 'etiqueta': 'Caso de Hacking'},
    {'valor': 'ayuda', 'etiqueta': 'Pedir Ayuda'},
    {'valor': 'historia', 'etiqueta': 'Historia'},
    {'valor': 'otro', 'etiqueta': 'Otro'},
  ];

  @override
  void dispose() {
    _tituloController.dispose();
    _descripcionController.dispose();
    _linkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);

    if (authState.user == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, color: Colors.grey, size: 48),
            const SizedBox(height: 16),
            Text(
              'Debes iniciar sesión para publicar',
              style: TextStyle(color: Colors.grey[400]),
            ),
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
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFF0D1117),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              'Nueva Publicación',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Text(
              'Comparte tu caso, pide ayuda o cuenta tu historia',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Form(
              key: _formKey,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF131A22).withOpacity(0.6),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey[800]!),
                ),
                child: Column(
                  children: [
                    // Categoría
                    DropdownButtonFormField<String>(
                      value: _categoriaSeleccionada,
                      dropdownColor: const Color(0xFF1B232C),
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Categoría',
                        labelStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[800]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF2DD4BF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      items: _categorias.map((cat) {
                        return DropdownMenuItem<String>(
                          value: cat['valor'],
                          child: Text(cat['etiqueta']!),
                        );
                      }).toList(),
                      onChanged: (value) {
                        if (value != null) {
                          setState(() => _categoriaSeleccionada = value);
                        }
                      },
                    ),
                    const SizedBox(height: 16),

                    // Título
                    TextFormField(
                      controller: _tituloController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Título',
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText: 'Resume tu caso en una frase',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[800]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF2DD4BF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'El título es requerido';
                        }
                        if (value.length < 6) {
                          return 'Mínimo 6 caracteres';
                        }
                        if (value.length > 120) {
                          return 'Máximo 120 caracteres';
                        }
                        return null;
                      },
                      maxLength: 120,
                    ),
                    const SizedBox(height: 16),

                    // Descripción
                    TextFormField(
                      controller: _descripcionController,
                      style: const TextStyle(color: Colors.white),
                      maxLines: 6,
                      decoration: InputDecoration(
                        labelText: 'Descripción',
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText:
                            'Explica qué pasó, qué necesitas o qué aprendiste...',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[800]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF2DD4BF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        errorBorder: OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'La descripción es requerida';
                        }
                        if (value.length < 20) {
                          return 'Mínimo 20 caracteres';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),

                    // Link
                    TextFormField(
                      controller: _linkController,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        labelText: 'Enlace externo (opcional)',
                        labelStyle: const TextStyle(color: Colors.grey),
                        hintText: 'https://ejemplo.com/articulo',
                        hintStyle: TextStyle(color: Colors.grey[600]),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey[800]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide:
                              const BorderSide(color: Color(0xFF2DD4BF)),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Archivos
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Adjuntar archivos (opcional)',
                          style: TextStyle(color: Colors.grey[400]),
                        ),
                        Text(
                          'Imágenes: 15MB | GIFs: 15MB | Videos: 50MB',
                          style:
                              TextStyle(color: Colors.grey[600], fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        ElevatedButton.icon(
                          onPressed: _seleccionarArchivos,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.grey[800],
                            foregroundColor: Colors.white,
                          ),
                          icon: const Icon(Icons.attach_file),
                          label: const Text('Seleccionar archivos'),
                        ),
                        if (_archivos.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          ..._archivos.map((archivo) {
                            final sizeMB = archivo.lengthSync() / 1024 / 1024;
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              margin: const EdgeInsets.only(bottom: 4),
                              decoration: BoxDecoration(
                                color: Colors.grey[800]!.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      archivo.path.split('/').last,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 13,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  Text(
                                    '(${sizeMB.toStringAsFixed(2)} MB)',
                                    style: TextStyle(
                                      color: Colors.grey[500],
                                      fontSize: 12,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    icon: const Icon(
                                      Icons.close,
                                      color: Colors.red,
                                      size: 16,
                                    ),
                                    onPressed: () {
                                      setState(() => _archivos.remove(archivo));
                                    },
                                  ),
                                ],
                              ),
                            );
                          }),
                        ],
                      ],
                    ),
                    const SizedBox(height: 24),

                    if (_errorMsg != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Text(
                          _errorMsg!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: _isLoading
                                ? null
                                : () => context.go('/comunidad'),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.grey,
                              side: BorderSide(color: Colors.grey[700]!),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                            ),
                            child: const Text('Cancelar'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _publicar,
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
                                    'Publicar',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _seleccionarArchivos() async {
    final picker = ImagePicker();
    final files = await picker.pickMultiImage();
    if (files.isNotEmpty) {
      setState(() {
        _archivos.addAll(files.map((f) => File(f.path)));
      });
    }
  }

  Future<void> _publicar() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMsg = null;
    });

    try {
      final postService = ref.read(postServiceProvider);
      final nuevoPost = await postService.crearPost(
        titulo: _tituloController.text,
        categoria: _categoriaSeleccionada,
        descripcion: _descripcionController.text,
        link: _linkController.text.isNotEmpty ? _linkController.text : null,
        archivos: _archivos.isNotEmpty ? _archivos : null,
      );

      if (mounted) {
        if (nuevoPost != null) {
          context.go('/comunidad/${nuevoPost.id}');
        } else {
          context.go('/comunidad');
        }
      }
    } catch (e) {
      setState(() {
        _errorMsg = 'No se pudo publicar. Intenta nuevamente.';
        _isLoading = false;
      });
    }
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kiert_movil/core/api/api_client.dart';
import 'package:kiert_movil/core/models/post.dart';

class PostService {
  final ApiClient _api = ApiClient();

  Future<List<Post>> listar() async {
    try {
      final response = await _api.get('/publicaciones');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Post.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Post?> obtenerPorId(int id) async {
    try {
      final response = await _api.get('/publicaciones/$id');
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Post?> crearPost({
    required String titulo,
    required String categoria,
    required String descripcion,
    String? link,
    List<File>? archivos,
  }) async {
    try {
      final formData = FormData();
      formData.fields.addAll([
        MapEntry('titulo', titulo),
        MapEntry('categoria', categoria),
        MapEntry('descripcion', descripcion),
        if (link != null) MapEntry('link', link),
      ]);

      if (archivos != null) {
        for (var archivo in archivos) {
          formData.files.add(
            MapEntry(
              'archivos',
              await MultipartFile.fromFile(
                archivo.path,
                filename: archivo.path.split('/').last,
              ),
            ),
          );
        }
      }

      final response = await _api.postMultipart('/publicaciones', formData);
      if (response.statusCode == 200) {
        return Post.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> eliminar(int id) async {
    try {
      final response = await _api.delete('/publicaciones/$id');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

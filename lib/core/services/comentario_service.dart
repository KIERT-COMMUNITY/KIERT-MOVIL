import 'package:kiert_movil/core/api/api_client.dart';
import 'package:kiert_movil/core/models/post.dart';

class ComentarioService {
  final ApiClient _api = ApiClient();

  // ========== COMENTARIOS ==========
  Future<List<Comentario>> listarPorPost(int postId) async {
    try {
      final response = await _api.get('/comentarios/post/$postId');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Comentario.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Comentario?> crear(int postId, String contenido) async {
    try {
      final response = await _api.post(
        '/comentarios/post/$postId',
        data: {'contenido': contenido},
      );
      if (response.statusCode == 200) {
        return Comentario.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> eliminar(int comentarioId) async {
    try {
      final response = await _api.delete('/comentarios/$comentarioId');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Comentario?> editar(int comentarioId, String contenido) async {
    try {
      final response = await _api.put(
        '/comentarios/$comentarioId',
        data: {'contenido': contenido},
      );
      if (response.statusCode == 200) {
        return Comentario.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== RESPUESTAS ==========
  Future<List<Respuesta>> listarRespuestas(int comentarioId) async {
    try {
      final response = await _api.get('/comentarios/$comentarioId/respuestas');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Respuesta.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<Respuesta?> crearRespuesta(int comentarioId, String contenido) async {
    try {
      final response = await _api.post(
        '/comentarios/$comentarioId/respuestas',
        data: {'contenido': contenido},
      );
      if (response.statusCode == 200) {
        return Respuesta.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<bool> eliminarRespuesta(int respuestaId) async {
    try {
      final response =
          await _api.delete('/comentarios/respuestas/$respuestaId');
      return response.statusCode == 200;
    } catch (e) {
      return false;
    }
  }

  Future<Respuesta?> editarRespuesta(int respuestaId, String contenido) async {
    try {
      final response = await _api.put(
        '/comentarios/respuestas/$respuestaId',
        data: {'contenido': contenido},
      );
      if (response.statusCode == 200) {
        return Respuesta.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== REACCIONES ==========
  Future<Reacciones?> reaccionarComentario(
      int comentarioId, String tipo) async {
    try {
      final response = await _api.post(
        '/comentarios/$comentarioId/reaccionar',
        data: {'tipo': tipo},
      );
      if (response.statusCode == 200) {
        return Reacciones.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Reacciones?> reaccionarRespuesta(int respuestaId, String tipo) async {
    try {
      final response = await _api.post(
        '/comentarios/respuestas/$respuestaId/reaccionar',
        data: {'tipo': tipo},
      );
      if (response.statusCode == 200) {
        return Reacciones.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  // ========== CONTADOR ==========
  Future<int> contarPorPost(int postId) async {
    try {
      final response = await _api.get('/comentarios/post/$postId/count');
      if (response.statusCode == 200) {
        return response.data as int;
      }
      return 0;
    } catch (e) {
      return 0;
    }
  }
}

import 'dart:io';
import 'package:dio/dio.dart';
import 'package:kiert_movil/core/api/api_client.dart';
import 'package:kiert_movil/core/models/personalizacion.dart';

class PersonalizacionService {
  final ApiClient _api = ApiClient();

  Future<Personalizacion?> obtenerPersonalizacion() async {
    try {
      final response = await _api.get('/personalizacion');
      if (response.statusCode == 200) {
        return Personalizacion.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Personalizacion?> obtenerPersonalizacionPorUsuario(
      int usuarioId) async {
    try {
      final response = await _api.get('/personalizacion/usuario/$usuarioId');
      if (response.statusCode == 200) {
        return Personalizacion.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<Personalizacion?> guardarPersonalizacion({
    required String temaId,
    required String marcoId,
    required String fondoId,
  }) async {
    try {
      final response = await _api.put(
        '/personalizacion',
        data: {
          'temaId': temaId,
          'marcoId': marcoId,
          'fondoId': fondoId,
        },
      );
      if (response.statusCode == 200) {
        return Personalizacion.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<List<Marco>> obtenerMarcos() async {
    try {
      final response = await _api.get('/personalizacion/marcos');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Marco.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }

  Future<List<Fondo>> obtenerFondos() async {
    try {
      final response = await _api.get('/personalizacion/fondos');
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        return data.map((e) => Fondo.fromJson(e)).toList();
      }
      return [];
    } catch (e) {
      return [];
    }
  }
}

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:kiert_movil/core/environment.dart';

class ApiClient {
  static final ApiClient _instance = ApiClient._internal();
  factory ApiClient() => _instance;
  ApiClient._internal();

  late Dio dio;
  String? _token;

  void init() {
    dio = Dio(BaseOptions(
      baseUrl: Environment.apiUrl,
      connectTimeout: const Duration(seconds: 30),
      receiveTimeout: const Duration(seconds: 30),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
    ));

    // ✅ INTERCEPTOR PARA LOGS
    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) async {
        print('🌐 REQUEST: ${options.method} ${options.path}');
        print('📦 DATA: ${options.data}');
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        print('✅ RESPONSE: ${response.statusCode}');
        print('📦 DATA: ${response.data}');
        return handler.next(response);
      },
      onError: (DioException e, handler) async {
        print('❌ ERROR: ${e.message}');
        print('📦 RESPONSE: ${e.response?.data}');
        print('📦 STATUS: ${e.response?.statusCode}');

        if (e.response?.statusCode == 401) {
          _token = null;
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('auth_token');
          await prefs.remove('usuario_actual');
        }
        return handler.next(e);
      },
    ));
  }

  Future<void> setToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  String? getTokenSync() {
    return _token;
  }

  Future<String?> getToken() async {
    if (_token != null) return _token;
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<Response> get(String path, {Map<String, dynamic>? queryParams}) async {
    return await dio.get(path, queryParameters: queryParams);
  }

  Future<Response> post(String path, {dynamic data}) async {
    return await dio.post(path, data: data);
  }

  Future<Response> put(String path, {dynamic data}) async {
    return await dio.put(path, data: data);
  }

  Future<Response> patch(String path, {dynamic data}) async {
    return await dio.patch(path, data: data);
  }

  Future<Response> delete(String path) async {
    return await dio.delete(path);
  }

  Future<Response> postMultipart(String path, FormData formData) async {
    return await dio.post(path, data: formData);
  }
}

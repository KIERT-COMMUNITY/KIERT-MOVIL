import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiert_movil/core/api/api_client.dart';
import 'package:kiert_movil/core/models/user.dart';

final userServiceProvider = Provider<UserService>((ref) => UserService());

class UserService {
  final ApiClient _api = ApiClient();

  Future<User?> obtenerUsuarioPorId(int id) async {
    try {
      final response = await _api.get('/usuarios/$id');
      if (response.statusCode == 200) {
        return User.fromJson(response.data);
      }
      return null;
    } catch (e) {
      return null;
    }
  }
}

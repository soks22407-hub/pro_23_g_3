import '../constant/api_constant.dart';
import '../core/util/api_client.dart';
import '../model/login_model.dart';
import '../service/storage_service.dart';

class LoginRepository {
  LoginRepository(this._api, this._storage);

  final ApiClient _api;
  final StorageService _storage;

  Future<bool> login(LoginModel loginModel) async {
    try {
      final json = await _api.post(
        ApiConstant.login,
        body: loginModel.toJson(),
      );

      final Map<String, dynamic> data = json['data'] as Map<String, dynamic>;

      final String token = data['token'] as String;
      final String type = data['type'] as String;

      await _storage.saveString('token', token);
      await _storage.saveString('tokenType', type);

      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> register({
    required String username,
    String? nickName,
    required String password,
  }) async {
    final json = await _api.post(
      ApiConstant.register,
      body: {
        'username': username,
        if (nickName != null) 'nickName': nickName,
        'password': password,
      },
    );

    final Map<String, dynamic> data = json['data'] as Map<String, dynamic>;
    final String token = data['token'] as String;
    final String type = data['type'] as String;

    await _storage.saveString('token', token);
    await _storage.saveString('tokenType', type);

    return true;
  }

}
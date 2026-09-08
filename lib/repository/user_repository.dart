import '../constant/api_constant.dart';
import '../core/util/api_client.dart';
import '../model/api_response_model.dart';
import '../model/user_model.dart';

class UserRepository {
  UserRepository(this._api);

  final ApiClient _api;

  Future<UserModel> getProfile() async {
    final json = await _api.get(ApiConstant.currentUser);
    return UserModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<UserModel> updateProfile({required int id, required String username, String? nickName}) async {
    final json = await _api.put(
      ApiConstant.userById(id),
      body: {
        'username': username,
        if (nickName != null) 'nickName': nickName},
    );
    return UserModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<ApiResponseModel<List<UserModel>>> getPage({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String direction = 'desc',
    String? username,
    String? nickName,
    bool? enabled,
  }) async {
    final json = await _api.get(
      ApiConstant.users,
      query: {
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'direction': direction,
        if (username != null && username.trim().isNotEmpty) 'username': username.trim(),
        if (nickName != null && nickName.trim().isNotEmpty) 'nickName': nickName.trim(),
        if (enabled != null) 'enabled': enabled,
      },
    );

    return ApiResponseModel<List<UserModel>>.fromJson(
      json,
          (d) => (d as List)
          .map((e) => UserModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<void> setEnabled({required int id, required bool enabled}) {
    return _api.patch(ApiConstant.userEnabled(id), query: {'enabled': enabled});
  }

  Future<UserModel> uploadProfileImage({
    required int id,
    required String filePath,
  }) async {
    final json = await _api.upload(ApiConstant.userImage(id), filePath: filePath);
    return UserModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<UserModel?> createUser({
    required String username,
    String? nickName,
    required String password,
  }) async {
    final json = await _api.post(
      ApiConstant.users,
      body: {
        'username': username,
        if (nickName != null) 'nickName': nickName,
        'password': password,
      },
    );

    if (json['data'] == null) return null;
    return UserModel.fromJson(json['data'] as Map<String, dynamic>);
  }


  Future<void> deleteUser(int id) {
    return _api.delete(ApiConstant.userById(id));
  }
}
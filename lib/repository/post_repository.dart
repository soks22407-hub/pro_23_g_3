import '../constant/api_constant.dart';

import '../core/util/api_client.dart';
import '../model/api_response_model.dart';
import '../model/post_daa_model.dart';

class PostRepository {
  PostRepository(this._api);

  final ApiClient _api;

  Future<ApiResponseModel<List<PostDataModel>>> getPage({
    int page = 0,
    int size = 10,
    String sortBy = 'createdAt',
    String direction = 'desc',
    String? title,
    int? authorId,
    String? authorUsername,
    bool? published,
  }) async {
    final json = await _api.get(
      ApiConstant.posts,
      query: {
        'page': page,
        'size': size,
        'sortBy': sortBy,
        'direction': direction,
        if (title != null && title.trim().isNotEmpty) 'title': title.trim(),
        if (authorId != null) 'authorId': authorId,
        if (authorUsername != null && authorUsername.trim().isNotEmpty)
          'authorUsername': authorUsername.trim(),
        if (published != null) 'published': published,
      },
    );

    return ApiResponseModel<List<PostDataModel>>.fromJson(
      json,
          (d) => (d as List)
          .map((e) => PostDataModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<PostDataModel?> createPost({
    required String title,
    required String content,
    required bool published,
  }) async {
    final json = await _api.post(
      ApiConstant.posts,
      body: {
        'title': title.trim(),
        'content': content.trim(),
        'published': published,
      },
    );

    if (json['data'] == null) return null;
    return PostDataModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<PostDataModel> updatePost({
    required int id,
    required String title,
    required String content,
    required bool published,
  }) async {
    final json = await _api.put(
      ApiConstant.postById(id),
      body: {'title': title, 'content': content, 'published': published},
    );

    return PostDataModel.fromJson(json['data'] as Map<String, dynamic>);
  }

  Future<void> deletePost(int id) {
    return _api.delete(ApiConstant.postById(id));
  }

  Future<PostDataModel> uploadPostImage({
    required int id,
    required String filePath,
  }) async {
    final json = await _api.upload(ApiConstant.postImage(id), filePath: filePath);
    return PostDataModel.fromJson(json['data'] as Map<String, dynamic>);
  }
}
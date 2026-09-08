import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:pro_23_g_3/model/post_daa_model.dart';
import 'package:pro_23_g_3/repository/post_repository.dart';

import '../core/util/api_client.dart';
import '../core/util/api_exception.dart';
import '../model/api_response_model.dart';
import 'base_list_controller.dart';

class PostController extends BaseListController<PostDataModel> {
  PostController(this._postRepo);

  final PostRepository _postRepo;

  RxList<PostDataModel> get posts => items;

  final searchTerm = ''.obs;
  final TextEditingController searchController = TextEditingController();
  final RxString searchText = ''.obs;

  final isCreating = false.obs;
  final isUpdating = false.obs;
  final isDeleting = false.obs;

  @override
  Object? idOf(PostDataModel item) => item.id;

  @override
  Future<ApiResponseModel<List<PostDataModel>>> fetchPage(int pageIndex) {
    return _postRepo.getPage(
      page: pageIndex,
      size: BaseListController.pageSize,
      title: searchTerm.value,
    );
  }

  @override
  void onInit() {
    super.onInit();
    searchController.addListener(() {
      searchText.value = searchController.text;
    });
    loadFirstPage();
  }

  Future<PostDataModel?> _withOptionalImage(
      PostDataModel? post,
      File? image,
      ) async {
    if (post == null || image == null) return post;
    return _postRepo.uploadPostImage(id: post.id!, filePath: image.path);
  }

  Future<void> createPost({
    required String title,
    required String content,
    required bool published,
    File? image,
  }) async {
    isCreating.value = true;

    try {
      var created = await _postRepo.createPost(
        title: title,
        content: content,
        published: published,
      );

      created = await _withOptionalImage(created, image);

      if (created != null) {
        items.insert(0, created);
        items.refresh();
        Get.back();
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isCreating.value = false;
    }
  }

  Future<void> togglePublish(PostDataModel post) async {
    try {
      final updated = await _postRepo.updatePost(
        id: post.id!,
        title: post.title ?? '',
        content: post.content ?? '',
        published: !(post.published ?? false),
      );
      replaceInList(updated);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    }
  }

  Future<void> updatePost({
    required PostDataModel post,
    required String title,
    required String content,
    required bool published,
    File? newImage,
  }) async {
    isUpdating.value = true;

    try {
      var updated = await _postRepo.updatePost(
        id: post.id!,
        title: title,
        content: content,
        published: published,
      );

      updated = await _withOptionalImage(updated, newImage) ?? updated;

      replaceInList(updated);
      Get.back();
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deletePost(PostDataModel post) async {
    isDeleting.value = true;

    try {
      await _postRepo.deletePost(post.id!);
      removeById(post.id!);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isDeleting.value = false;
    }
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
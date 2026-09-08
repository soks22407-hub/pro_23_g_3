import 'dart:io';

import 'package:get/get.dart';

import '../core/util/api_client.dart';
import '../core/util/api_exception.dart';
import '../model/api_response_model.dart';
import '../model/user_model.dart';
import '../repository/user_repository.dart';
import 'base_list_controller.dart';

class UserController extends BaseListController<UserModel> {
  UserController(this._userRepo);

  final UserRepository _userRepo;

  final isCreating = false.obs;
  final searchTerm = ''.obs;
  final isDeleting = false.obs;

  RxList<UserModel> get users => items;

  @override
  Object? idOf(UserModel item) => item.id;

  @override
  Future<ApiResponseModel<List<UserModel>>> fetchPage(int pageIndex) {
    return _userRepo.getPage(
      page: pageIndex,
      size: BaseListController.pageSize,
      username: searchTerm.value,
    );
  }

  @override
  void onInit() {
    super.onInit();
    loadFirstPage();
  }

  Future<void> toggleEnabled(UserModel user) async {
    try {
      await _userRepo.setEnabled(id: user.id!, enabled: !(user.enabled ?? true));
      // Server doesn't return the updated user here, so patch it locally.
      final index = items.indexWhere((u) => u.id == user.id);
      if (index != -1) {
        items[index].enabled = !(user.enabled ?? true);
        items.refresh();
      }
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    }
  }

  Future<void> createUser({
    required String username,
    required String nickName,
    required String password,
    File? image,
  }) async {
    isCreating.value = true;

    try {
      var created = await _userRepo.createUser(
        username: username,
        nickName: nickName.isEmpty ? null : nickName,
        password: password,
      );

      if (created != null && image != null) {
        created = await _userRepo.uploadProfileImage(id: created.id!, filePath: image.path);
      }

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

  final isUpdating = false.obs;

  Future<void> updateUser({
    required UserModel user,
    required String username,
    required String nickName,
    File? newImage,
  }) async {
    isUpdating.value = true;

    try {
      var updated = await _userRepo.updateProfile(
        id: user.id!,
        username: username,
        nickName: nickName.isEmpty ? null : nickName,
      );

      if (newImage != null) {
        updated = await _userRepo.uploadProfileImage(id: user.id!, filePath: newImage.path);
      }

      replaceInList(updated);
      Get.back();
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isUpdating.value = false;
    }
  }

  Future<void> deleteUser(UserModel user) async {
    isDeleting.value = true;
    try {
      await _userRepo.deleteUser(user.id!);
      removeById(user.id!);
    } on ApiException catch (e) {
      Get.snackbar('Error', e.message);
    } finally {
      isDeleting.value = false;
    }
  }
}
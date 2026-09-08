import 'package:get/get.dart';

import '../core/util/api_exception.dart';
import '../model/api_response_model.dart';

abstract class BaseListController<T> extends GetxController {
  final items = <T>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final errorMessage = ''.obs;

  int page = 0;
  int totalPages = 1;
  int total = 0;
  static const int pageSize = 10;

  bool get hasMore => page + 1 < totalPages;

  /// Subclasses implement how to actually fetch a page from their repo.
  /// Throws [ApiException] on failure — caught centrally in [_loadPage].
  Future<ApiResponseModel<List<T>>> fetchPage(int pageIndex);

  /// Optional: unique id getter, used by replaceInList/removeById.
  Object? idOf(T item) => null;

  Future<void> loadFirstPage() async {
    if (isLoading.value) return;
    page = 0;
    await _loadPage(pageIndex: 0, isFirstPage: true, loadingFlag: isLoading);
  }

  Future<void> loadNextPage() async {
    if (isLoadingMore.value || !hasMore) return;
    await _loadPage(pageIndex: page + 1, isFirstPage: false, loadingFlag: isLoadingMore);
  }

  Future<void> _loadPage({
    required int pageIndex,
    required bool isFirstPage,
    required RxBool loadingFlag,
  }) async {
    loadingFlag.value = true;
    if (isFirstPage) errorMessage.value = '';

    try {
      final result = await fetchPage(pageIndex);

      final List<T> newItems = result.data ?? [];
      isFirstPage ? items.assignAll(newItems) : items.addAll(newItems);

      _applyMeta(result.pagination);
    } on ApiException catch (e) {
      errorMessage.value = e.message;
      if (isFirstPage) items.clear();
    } finally {
      loadingFlag.value = false;
    }
  }

  void _applyMeta(Pagination? pagination) {
    if (pagination == null) {
      total = items.length;
      totalPages = 1;
      return;
    }
    page = pagination.page ?? 0;
    totalPages = pagination.totalPages ?? 1;
    total = pagination.total ?? 0;
  }

  void replaceInList(T updated) {
    final id = idOf(updated);
    if (id == null) return;
    final index = items.indexWhere((e) => idOf(e) == id);
    if (index != -1) {
      items[index] = updated;
      items.refresh();
    }
  }

  void removeById(Object id) {
    items.removeWhere((e) => idOf(e) == id);
    items.refresh();
  }
}
import 'package:get/get.dart';
import 'package:pro_23_g_3/model/post_daa_model.dart';
import 'package:pro_23_g_3/model/slider_model.dart';
import 'package:pro_23_g_3/repository/post_repository.dart';

class HomeController extends GetxController {
  HomeController(this._postRepo);

  final PostRepository _postRepo;

  final banners = <SliderModel>[].obs;
  final latestPosts = <PostDataModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHome();
  }

  Future<void> loadHome() async {
    isLoading.value = true;
    try {
      banners.assignAll(_fetchBanners());
      latestPosts.assignAll(await _fetchLatestPosts());
    } catch (e, stack) {
      print('LOAD HOME ERROR: $e');
      print(stack);
    } finally {
      isLoading.value = false;
    }
  }

  List<SliderModel> _fetchBanners() {
    return <SliderModel>[
      SliderModel(
        title: 'Welcome to GetX Basic',
        subtitle: 'Learn Flutter with GetX',
        imageUrl: 'https://picsum.photos/800/400?random=1',
      ),
      SliderModel(
        title: 'Flutter Development',
        subtitle: 'Build modern mobile applications',
        imageUrl: 'https://picsum.photos/800/400?random=2',
      ),
      SliderModel(
        title: 'GetX State Management',
        subtitle: 'Simple and powerful state management',
        imageUrl: 'https://picsum.photos/800/400?random=3',
      ),
    ];
  }

  Future<List<PostDataModel>> _fetchLatestPosts() async {
    final result = await _postRepo.getPage(
      page: 0,
      size: 5,
      sortBy: 'createdAt',
      direction: 'desc',
    );
    return result.data ?? [];
  }
}
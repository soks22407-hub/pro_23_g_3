import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../core/value/app_color.dart';
import '../../model/post_daa_model.dart';
import '../../model/slider_model.dart';
import '../../repository/post_repository.dart';
import '../widget/app_drawer.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final PostRepository _postRepo = Get.find<PostRepository>();

  final RxInt currentIndex = 0.obs;
  final RxList<PostDataModel> latestPosts = <PostDataModel>[].obs;
  final RxBool loadingPosts = true.obs;

  final List<SliderModel> banners = <SliderModel>[
    SliderModel(
      title: 'Latest posts',
      subtitle: 'Second banner',
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

  @override
  void initState() {
    super.initState();
    _loadLatestPosts();
  }

  Future<void> _loadLatestPosts() async {
    loadingPosts.value = true;
    try {
      final result = await _postRepo.getPage(
        page: 0,
        size: 5,
        sortBy: 'createdAt',
        direction: 'desc',
      );
      latestPosts.assignAll(result.data ?? []);
    } catch (e, stack) {
      debugPrint('LOAD POSTS ERROR: $e');
    } finally {
      loadingPosts.value = false;
    }
  }

  // Helper method to format time ago
  String _getTimeAgo(String? dateString) {
    if (dateString == null || dateString.isEmpty) return '';
    try {
      final DateTime date = DateTime.parse(dateString).toLocal();
      final Duration diff = DateTime.now().difference(date);

      if (diff.inDays >= 365) return '${diff.inDays ~/ 365} ${'years_ago'.tr}';
      if (diff.inDays >= 30) return '${diff.inDays ~/ 30} ${'months_ago'.tr}';
      if (diff.inDays > 0) return '${diff.inDays} ${'days_ago'.tr}';
      if (diff.inHours > 0) return '${diff.inHours} ${'hours_ago'.tr}';
      if (diff.inMinutes > 0) return '${diff.inMinutes} ${'minutes_ago'.tr}';
      return 'just_now'.tr;
    } catch (e) {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AppDrawer(),
      appBar: AppBar(
        title: Text(
          'home'.tr,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _loadLatestPosts,
          child: ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: <Widget>[
              // =========================
              // Carousel
              // =========================
              CarouselSlider(
                items: banners.map((SliderModel banner) {
                  return Container(
                    width: double.infinity,
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: AppColor.primaryLight,
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        Image.network(
                          banner.fullImageUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) {
                            return const Icon(
                              Icons.image_not_supported_outlined,
                              size: 40,
                            );
                          },
                        ),
                        const DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.center,
                              end: Alignment.bottomCenter,
                              colors: <Color>[
                                Colors.transparent,
                                Colors.black54
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          left: 16,
                          right: 16,
                          bottom: 16,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                banner.title,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              if (banner.subtitle != null &&
                                  banner.subtitle!.isNotEmpty)
                                Text(
                                  banner.subtitle!,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                options: CarouselOptions(
                  height: 190,
                  viewportFraction: 0.88,
                  autoPlay: true,
                  autoPlayInterval: const Duration(seconds: 4),
                  enlargeCenterPage: true,
                  onPageChanged: (index, reason) {
                    currentIndex.value = index;
                  },
                ),
              ),

              const SizedBox(height: 10),

              Obx(
                    () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(banners.length, (index) {
                    return AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      width: currentIndex.value == index ? 20 : 8,
                      height: 8,
                      margin: const EdgeInsets.symmetric(horizontal: 3),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: currentIndex.value == index
                            ? AppColor.primary
                            : Colors.grey.shade300,
                      ),
                    );
                  }),
                ),
              ),

              const SizedBox(height: 24),

              // =========================
              // Latest Posts Title
              // =========================
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  'latest_posts'.tr,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 12),

              // =========================
              // Post List
              // =========================
              Obx(() {
                if (loadingPosts.value) {
                  return const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }

                if (latestPosts.isEmpty) {
                  return Padding(
                    padding: const EdgeInsets.all(24),
                    child: Center(child: Text('no_posts_yet'.tr)),
                  );
                }

                return Column(
                  children: latestPosts.map((PostDataModel post) {
                    final String? url = post.imageUrl;
                    final String authorName = post.author?.nickName ??
                        post.author?.username ??
                        'Unknown';
                    final String timeAgo = _getTimeAgo(post.createdAt);

                    return Container(
                      margin: const EdgeInsets.fromLTRB(16, 0, 15, 7),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                      ),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 60,
                              height: 60,
                              child: (url != null && url.isNotEmpty)
                                  ? Image.network(
                                url,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) {
                                  return const ColoredBox(
                                    color: AppColor.primaryLight,
                                    child: Icon(
                                      Icons.article_outlined,
                                      color: AppColor.primary,
                                    ),
                                  );
                                },
                              )
                                  : const ColoredBox(
                                color: AppColor.primaryLight,
                                child: Icon(
                                  Icons.article_outlined,
                                  color: AppColor.primary,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  post.title ?? '',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '$authorName${timeAgo.isNotEmpty ? ' · $timeAgo' : ''}',
                                  style: const TextStyle(
                                    fontSize: 13,
                                    color: Colors.grey,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
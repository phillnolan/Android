import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:th4/core/api_state.dart';
import 'package:th4/providers/product_provider.dart';
import 'package:th4/providers/cart_provider.dart';
import 'package:th4/core/routes.dart';
import 'package:th4/widgets/common/product_card.dart';
import 'package:th4/widgets/home/banner_slider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final ScrollController _scrollController = ScrollController();
  late AnimationController _fadeController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeController.forward();
    _scrollController.addListener(_onScroll);
    Future.microtask(
      () {
        if (!mounted) return;
        context.read<ProductProvider>().fetchProducts();
      },
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.9) {
      context.read<ProductProvider>().fetchMoreProducts();
    }
  }

  Future<void> _onRefresh() async {
    await context.read<ProductProvider>().fetchProducts(isRefresh: true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // 1. SliverAppBar with Cart Badge
            SliverAppBar(
              pinned: true,
              expandedHeight: 120.0,
              flexibleSpace: FlexibleSpaceBar(
                title: const Text('TH4 - Nhóm 64',
                    style: TextStyle(color: Colors.white)),
                background: Container(color: Colors.blue),
              ),
              actions: [
                Consumer<CartProvider>(
                  builder: (context, cart, child) {
                    return Stack(
                      alignment: Alignment.center,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.shopping_cart,
                              color: Colors.white),
                          onPressed: () => Navigator.pushNamed(context, AppRoutes.cart),
                        ),
                        if (cart.itemCount > 0)
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Colors.red,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              constraints: const BoxConstraints(
                                  minWidth: 16, minHeight: 16),
                              child: Text(
                                '${cart.itemCount}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 10),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),

            // 2. Sticky Search Bar
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                minHeight: 60.0,
                maxHeight: 60.0,
                child: Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: TextField(
                    onChanged: (value) => context.read<ProductProvider>().searchProducts(value),
                    decoration: InputDecoration(
                      hintText: 'Tìm kiếm sản phẩm...',
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.grey[200],
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
              ),
            ),

            // 3. Banner Slider & Category
            SliverToBoxAdapter(
              child: Column(
                children: [
                  const BannerSlider(),
                  _buildCategorySection(context),
                  const Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    child: Row(
                      children: [
                        Text('Gợi ý cho bạn',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // 4. Product Grid with API State & Infinite Scroll
            Consumer<ProductProvider>(
              builder: (context, provider, child) {
                final state = provider.productsState;

                if (state is ApiLoading) {
                  return SliverPadding(
                    padding: const EdgeInsets.all(10),
                    sliver: SliverGrid(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        childAspectRatio: 0.7,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                      ),
                      delegate: SliverChildBuilderDelegate(
                        (context, index) => _buildShimmerCard(),
                        childCount: 6,
                      ),
                    ),
                  );
                }

                if (state is ApiSuccess) {
                  final products = provider.filteredProducts;

                  if (products.isEmpty) {
                    return const SliverFillRemaining(
                      hasScrollBody: false,
                      child: Center(
                        child: Text('Không tìm thấy sản phẩm nào 🔍'),
                      ),
                    );
                  }

                  return SliverFadeTransition(
                    opacity: _fadeController,
                    sliver: SliverPadding(
                      padding: const EdgeInsets.all(10),
                      sliver: SliverMainAxisGroup(
                        slivers: [
                          SliverGrid(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                return ProductCard(
                                  product: products[index],
                                  onTap: () {
                                    Navigator.pushNamed(
                                      context,
                                      AppRoutes.detail,
                                      arguments: products[index],
                                    );
                                  },
                                );
                              },
                              childCount: products.length,
                            ),
                          ),
                          if (provider.isLoadingMore && provider.hasMore)
                            SliverPadding(
                              padding: const EdgeInsets.symmetric(vertical: 20),
                              sliver: SliverGrid(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  childAspectRatio: 0.7,
                                  mainAxisSpacing: 10,
                                  crossAxisSpacing: 10,
                                ),
                                delegate: SliverChildBuilderDelegate(
                                  (context, index) => _buildShimmerCard(),
                                  childCount: 2,
                                ),
                              ),
                            ),
                          if (!provider.hasMore && products.isNotEmpty)
                            const SliverToBoxAdapter(
                              child: Padding(
                                padding: EdgeInsets.symmetric(vertical: 32.0),
                                child: Center(
                                  child: Text(
                                    'Bạn đã xem hết sản phẩm rồi ✨',
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is ApiError) {
                  return SliverToBoxAdapter(
                    child: Center(child: Text((state as ApiError).message)),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'name': 'Nam', 'id': "men's clothing", 'icon': Icons.checkroom},
      {'name': 'Nữ', 'id': "women's clothing", 'icon': Icons.woman},
      {'name': 'Trang sức', 'id': 'jewelery', 'icon': Icons.diamond},
      {'name': 'Điện tử', 'id': 'electronics', 'icon': Icons.devices},
      {'name': 'Tất cả', 'id': '', 'icon': Icons.grid_view},
    ];

    return Container(
      height: 100,
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: categories.length,
        separatorBuilder: (context, index) => const SizedBox(width: 20),
        itemBuilder: (context, index) {
          return Consumer<ProductProvider>(
            builder: (context, provider, child) {
              // ignore: unused_local_variable
              final isSelected = provider.selectedCategory == categories[index]['id'];
              return GestureDetector(
                onTap: () {
                  provider.filterByCategory(categories[index]['id']);
                  _fadeController.forward(from: 0);
                },
                child: Column(
                  children: [
                    CircleAvatar(
                      backgroundColor: isSelected 
                          ? Colors.blue 
                          : Colors.blue.withValues(alpha: 0.1),
                      child: Icon(
                        categories[index]['icon'], 
                        color: isSelected ? Colors.white : Colors.blue
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      categories[index]['name'],
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? Colors.blue : Colors.black,
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _buildShimmerCard() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}

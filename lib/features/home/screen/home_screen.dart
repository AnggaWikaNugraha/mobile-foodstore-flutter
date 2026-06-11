import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shimmer/shimmer.dart';
import '../../../core/theme/app_colors.dart';
import '../model/tag.dart';
import '../provider/home_provider.dart';
import '../../../features/cart/provider/cart_provider.dart';
import '../../../shared/widgets/product_card.dart';

const _banners = [
  {
    'title': 'Diskon Hingga\n30% Hari Ini!',
    'label': '🔥 Promo Spesial',
    'btn': 'Pesan Sekarang →',
    'colors': [Color(0xFFD4643A), Color(0xFFB5451B)],
  },
  {
    'title': 'Gratis Ongkir\nMin. Rp 50.000',
    'label': '🚚 Promo Pengiriman',
    'btn': 'Belanja Sekarang →',
    'colors': [Color(0xFF2980B9), Color(0xFF1A5276)],
  },
  {
    'title': 'Produk Segar\nLangsung Petani',
    'label': '🌿 Pilihan Terbaik',
    'btn': 'Lihat Produk →',
    'colors': [Color(0xFF27AE60), Color(0xFF1E8449)],
  },
];

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _searchController = TextEditingController();
  int _currentBanner = 0;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final home = ref.watch(homeProvider);
    final cart = ref.watch(cartProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          // ── Header ──
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.surface,
            titleSpacing: 16,
            title: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: AppColors.primaryLight,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.storefront,
                      color: AppColors.primary, size: 18),
                ),
                const SizedBox(width: 8),
                const Text(
                  'FoodStore',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary),
                ),
              ],
            ),
            actions: [
              // Cart badge
              Stack(
                children: [
                  IconButton(
                    icon: const Icon(Icons.shopping_cart_outlined,
                        color: AppColors.textPrimary),
                    onPressed: () {},
                  ),
                  if (cart.totalCount > 0)
                    Positioned(
                      right: 6,
                      top: 6,
                      child: Container(
                        padding: const EdgeInsets.all(3),
                        decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle),
                        child: Text('${cart.totalCount}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                                fontWeight: FontWeight.bold)),
                      ),
                    ),
                ],
              ),
              // Masuk button
              OutlinedButton(
                onPressed: () {},
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: const BorderSide(color: AppColors.primary),
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 32),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Masuk',
                    style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(width: 8),
              // Daftar button
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  minimumSize: const Size(0, 32),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Daftar',
                    style: TextStyle(fontSize: 13)),
              ),
              const SizedBox(width: 12),
            ],
          ),

          // ── Search bar ──
          SliverToBoxAdapter(
            child: Container(
              color: AppColors.surface,
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
              child: TextField(
                controller: _searchController,
                onChanged: (v) =>
                    ref.read(homeProvider.notifier).onSearchChanged(v),
                style: const TextStyle(fontSize: 14),
                decoration: InputDecoration(
                  hintText: 'Cari produk...',
                  hintStyle: const TextStyle(
                      color: AppColors.textHint, fontSize: 14),
                  prefixIcon: const Icon(Icons.search,
                      color: AppColors.textHint, size: 20),
                  filled: true,
                  fillColor: AppColors.background,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: const EdgeInsets.symmetric(vertical: 0),
                  isDense: true,
                ),
              ),
            ),
          ),

          // ── Banner ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Column(
                children: [
                  CarouselSlider(
                    options: CarouselOptions(
                      height: 148,
                      autoPlay: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      enlargeCenterPage: true,
                      viewportFraction: 0.88,
                      onPageChanged: (i, _) =>
                          setState(() => _currentBanner = i),
                    ),
                    items: _banners.map((b) {
                      final colors = b['colors'] as List<Color>;
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: colors),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color:
                                    Colors.white.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Text(b['label'] as String,
                                  style: const TextStyle(
                                      color: Colors.white, fontSize: 11)),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              b['title'] as String,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  height: 1.3),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                b['btn'] as String,
                                style: TextStyle(
                                    color: colors.last,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 10),
                  // Dot indicator
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      _banners.length,
                      (i) => AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 3),
                        width: _currentBanner == i ? 18 : 7,
                        height: 7,
                        decoration: BoxDecoration(
                          color: _currentBanner == i
                              ? AppColors.primary
                              : AppColors.divider,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // ── Kategori ──
          if (!home.isLoadingFilters && home.categories.isNotEmpty)
            SliverToBoxAdapter(
              child: Container(
                color: AppColors.surface,
                padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Kategori',
                        style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary)),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          // Tile "Semua"
                          _CategoryTile(
                            label: 'Semua',
                            icon: Icons.apps_rounded,
                            selected: home.selectedCategoryId == null,
                            onTap: () => ref
                                .read(homeProvider.notifier)
                                .selectCategory(null),
                          ),
                          ...home.categories.map((cat) => _CategoryTile(
                                label: cat.name,
                                icon: _categoryIcon(cat.name),
                                selected:
                                    home.selectedCategoryId == cat.id,
                                onTap: () => ref
                                    .read(homeProvider.notifier)
                                    .selectCategory(cat.id),
                              )),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 8)),

          // ── Tag chips ──
          if (!home.isLoadingFilters && home.tags.isNotEmpty)
            SliverToBoxAdapter(
              child: SizedBox(
                height: 40,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: home.tags
                      .map((tag) => _TagChip(
                            tag: tag,
                            selected:
                                home.selectedTagIds.contains(tag.id),
                            onTap: () => ref
                                .read(homeProvider.notifier)
                                .toggleTag(tag.id),
                          ))
                      .toList(),
                ),
              ),
            ),

          const SliverToBoxAdapter(child: SizedBox(height: 12)),

          // ── Grid produk ──
          if (home.isLoadingProducts)
            _skeletonGrid()
          else if (home.products.isEmpty)
            const SliverToBoxAdapter(
              child: Center(
                child: Padding(
                  padding: EdgeInsets.all(40),
                  child: Text('Produk tidak ditemukan',
                      style: TextStyle(color: AppColors.textSecondary)),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              sliver: SliverGrid(
                delegate: SliverChildBuilderDelegate(
                  (_, i) => ProductCard(product: home.products[i]),
                  childCount: home.products.length,
                ),
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.62,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
            ),

          // ── Pagination ──
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: _Pagination(
                current: home.currentPage,
                total: home.totalPages,
                hasNext: home.hasNext,
                hasPrev: home.hasPrev,
                onNext: () =>
                    ref.read(homeProvider.notifier).nextPage(),
                onPrev: () =>
                    ref.read(homeProvider.notifier).prevPage(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _skeletonGrid() {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (_, _) => const _ProductSkeleton(),
          childCount: 6,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.62,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
      ),
    );
  }

  IconData _categoryIcon(String name) {
    final n = name.toLowerCase();
    if (n.contains('minum') || n.contains('drink')) return Icons.local_drink_outlined;
    if (n.contains('snack') || n.contains('camilan')) return Icons.cookie_outlined;
    if (n.contains('nasi') || n.contains('utama') || n.contains('main')) return Icons.rice_bowl_outlined;
    if (n.contains('dessert') || n.contains('manis')) return Icons.icecream_outlined;
    return Icons.restaurant_outlined;
  }
}

// ── Category tile ──
class _CategoryTile extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _CategoryTile({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 14),
        child: Column(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.primaryLight,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(
                icon,
                color: selected ? Colors.white : AppColors.primary,
                size: 24,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: selected
                      ? FontWeight.bold
                      : FontWeight.normal,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textSecondary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Tag chip ──
class _TagChip extends StatelessWidget {
  final Tag tag;
  final bool selected;
  final VoidCallback onTap;

  const _TagChip(
      {required this.tag, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.primaryLight : AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color:
                selected ? AppColors.primary : AppColors.divider,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.primary
                    : AppColors.divider,
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: Text(
                tag.name[0].toUpperCase(),
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.bold,
                    color:
                        selected ? Colors.white : AppColors.textSecondary),
              ),
            ),
            const SizedBox(width: 6),
            Text(
              tag.name,
              style: TextStyle(
                  fontSize: 12,
                  color: selected
                      ? AppColors.primary
                      : AppColors.textPrimary),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Pagination bar ──
class _Pagination extends StatelessWidget {
  final int current;
  final int total;
  final bool hasNext;
  final bool hasPrev;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const _Pagination({
    required this.current,
    required this.total,
    required this.hasNext,
    required this.hasPrev,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _PageBtn(
            label: 'First',
            onTap: hasPrev ? onPrev : null),
        const SizedBox(width: 4),
        _PageBtn(
            icon: Icons.chevron_left,
            onTap: hasPrev ? onPrev : null),
        const SizedBox(width: 8),
        Container(
          width: 32,
          height: 32,
          decoration: const BoxDecoration(
              color: AppColors.primary, shape: BoxShape.circle),
          alignment: Alignment.center,
          child: Text('${current + 1}',
              style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13)),
        ),
        const SizedBox(width: 8),
        _PageBtn(
            icon: Icons.chevron_right,
            onTap: hasNext ? onNext : null),
        const SizedBox(width: 4),
        _PageBtn(
            label: 'Last',
            onTap: hasNext ? onNext : null),
      ],
    );
  }
}

class _PageBtn extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  const _PageBtn({this.label, this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final active = onTap != null;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: label != null
            ? const EdgeInsets.symmetric(horizontal: 10, vertical: 6)
            : const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.divider),
        ),
        child: icon != null
            ? Icon(icon,
                size: 16,
                color:
                    active ? AppColors.textPrimary : AppColors.textHint)
            : Text(label!,
                style: TextStyle(
                    fontSize: 12,
                    color: active
                        ? AppColors.textPrimary
                        : AppColors.textHint)),
      ),
    );
  }
}

// ── Skeleton loading ──
class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: Card(
        elevation: 0,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: const BorderSide(color: AppColors.divider, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Container(color: Colors.white),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 11, color: Colors.white,
                        width: double.infinity),
                    const SizedBox(height: 4),
                    Container(height: 11, color: Colors.white, width: 70),
                    const SizedBox(height: 6),
                    Container(height: 14, color: Colors.white, width: 80),
                    const Spacer(),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                          width: 30, height: 30,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(9),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

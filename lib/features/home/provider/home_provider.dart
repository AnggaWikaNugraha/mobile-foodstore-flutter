import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../model/category.dart';
import '../model/product.dart';
import '../model/tag.dart';
import '../data/home_repository.dart';

const _limit = 5;

class HomeState {
  final List<Product> products;
  final List<Category> categories;
  final List<Tag> tags;
  final bool isLoadingProducts;
  final bool isLoadingFilters;
  final String searchQuery;
  final String? selectedCategoryId;
  final List<String> selectedTagIds;
  final int currentPage;
  final int totalCount;

  const HomeState({
    this.products = const [],
    this.categories = const [],
    this.tags = const [],
    this.isLoadingProducts = false,
    this.isLoadingFilters = false,
    this.searchQuery = '',
    this.selectedCategoryId,
    this.selectedTagIds = const [],
    this.currentPage = 0,
    this.totalCount = 0,
  });

  int get totalPages => totalCount == 0 ? 1 : (totalCount / _limit).ceil();
  bool get hasNext => currentPage < totalPages - 1;
  bool get hasPrev => currentPage > 0;

  @override
  String toString() => 'HomeState('
      'products: ${products.length}, '
      'totalCount: $totalCount, '
      'page: $currentPage/$totalPages, '
      'search: "$searchQuery", '
      'categoryId: $selectedCategoryId, '
      'tagIds: $selectedTagIds, '
      'loadingProducts: $isLoadingProducts, '
      'loadingFilters: $isLoadingFilters'
      ')';

  HomeState copyWith({
    List<Product>? products,
    List<Category>? categories,
    List<Tag>? tags,
    bool? isLoadingProducts,
    bool? isLoadingFilters,
    String? searchQuery,
    String? selectedCategoryId,
    bool clearCategory = false,
    List<String>? selectedTagIds,
    int? currentPage,
    int? totalCount,
  }) {
    return HomeState(
      products: products ?? this.products,
      categories: categories ?? this.categories,
      tags: tags ?? this.tags,
      isLoadingProducts: isLoadingProducts ?? this.isLoadingProducts,
      isLoadingFilters: isLoadingFilters ?? this.isLoadingFilters,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategoryId:
          clearCategory ? null : (selectedCategoryId ?? this.selectedCategoryId),
      selectedTagIds: selectedTagIds ?? this.selectedTagIds,
      currentPage: currentPage ?? this.currentPage,
      totalCount: totalCount ?? this.totalCount,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repo;
  HomeNotifier(this._repo) : super(const HomeState()) {
    _init();
  }
  Timer? _debounce;

  Future<void> _init() async {
    state = state.copyWith(isLoadingProducts: true, isLoadingFilters: true);
    await Future.wait([_fetchProducts(), _fetchFilters()]);
  }

  Future<void> _fetchFilters() async {
    final results = await Future.wait([_repo.getCategories(), _repo.getTags()]);
    state = state.copyWith(
      categories: results[0] as List<Category>,
      tags: results[1] as List<Tag>,
      isLoadingFilters: false,
    );
  }

  Future<void> _fetchProducts() async {
    state = state.copyWith(isLoadingProducts: true);
    try {
      final (products, count) = await _repo.getProducts(
        q: state.searchQuery,
        categoryId: state.selectedCategoryId,
        tagIds: state.selectedTagIds,
        skip: state.currentPage * _limit,
      );
      state = state.copyWith(
        products: products,
        totalCount: count,
        isLoadingProducts: false,
      );
    } catch (_) {
      state = state.copyWith(isLoadingProducts: false);
    }
  }

  void onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      state = state.copyWith(searchQuery: query, currentPage: 0);
      _fetchProducts();
    });
  }

  void selectCategory(String? categoryId) {
    if (categoryId == state.selectedCategoryId) {
      state = state.copyWith(clearCategory: true, currentPage: 0);
    } else {
      state = state.copyWith(selectedCategoryId: categoryId, currentPage: 0);
    }
    _fetchProducts();
  }

  void toggleTag(String tagId) {
    final current = List<String>.from(state.selectedTagIds);
    current.contains(tagId) ? current.remove(tagId) : current.add(tagId);
    state = state.copyWith(selectedTagIds: current, currentPage: 0);
    _fetchProducts();
  }

  void nextPage() {
    if (!state.hasNext) return;
    state = state.copyWith(currentPage: state.currentPage + 1);
    _fetchProducts();
  }

  void prevPage() {
    if (!state.hasPrev) return;
    state = state.copyWith(currentPage: state.currentPage - 1);
    _fetchProducts();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((_) => HomeRepository());

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  return HomeNotifier(ref.read(homeRepositoryProvider));
});

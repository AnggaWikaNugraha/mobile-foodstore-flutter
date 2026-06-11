import 'package:flutter_riverpod/flutter_riverpod.dart';

// Satu item di cart
class CartItem {
  final String productId;
  final int qty;

  const CartItem({required this.productId, required this.qty});

  CartItem copyWith({int? qty}) => CartItem(
        productId: productId,
        qty: qty ?? this.qty,
      );

  @override
  String toString() => 'CartItem(productId: $productId, qty: $qty)';
}

class CartState {
  final List<CartItem> items;

  const CartState({this.items = const []});

  // Total semua qty (untuk badge)
  int get totalCount => items.fold(0, (sum, item) => sum + item.qty);

  int getQty(String productId) {
    final item = items.where((e) => e.productId == productId).firstOrNull;
    return item?.qty ?? 0;
  }

  @override
  String toString() => 'CartState(totalCount: $totalCount, items: $items)';
}

class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(const CartState());

  void addItem(String productId) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((e) => e.productId == productId);

    if (index == -1) {
      // belum ada di cart → tambah baru
      items.add(CartItem(productId: productId, qty: 1));
    } else {
      // sudah ada → naikkan qty
      items[index] = items[index].copyWith(qty: items[index].qty + 1);
    }

    state = CartState(items: items);
  }

  void removeItem(String productId) {
    final items = List<CartItem>.from(state.items);
    final index = items.indexWhere((e) => e.productId == productId);

    if (index == -1) return;

    if (items[index].qty <= 1) {
      // qty jadi 0 → hapus dari list
      items.removeAt(index);
    } else {
      // kurangi qty
      items[index] = items[index].copyWith(qty: items[index].qty - 1);
    }

    state = CartState(items: items);
  }
}

final cartProvider = StateNotifierProvider<CartNotifier, CartState>(
  (_) => CartNotifier(),
);

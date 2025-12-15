// ignore: file_names
import 'package:flutter/material.dart';

class CartItem {
  final dynamic product;
  final int quantity;

  CartItem({required this.product, required this.quantity});
}

class ShoppingCart extends ChangeNotifier {
  final List<CartItem> _items = [];

  List<CartItem> get items => _items;

  int get itemCount => _items.length;

  double get totalPrice {
    double total = 0;
    for (var item in _items) {
      total += item.product.price * item.quantity;
    }
    return total;
  }

  void addItem(dynamic product, int quantity) {
    final existingIndex = _items.indexWhere((item) => item.product == product);

    if (existingIndex >= 0) {
      _items[existingIndex] = CartItem(
        product: product,
        quantity: _items[existingIndex].quantity + quantity,
      );
    } else {
      _items.add(CartItem(product: product, quantity: quantity));
    }
    notifyListeners();
  }

  void removeItem(dynamic productOrCartItem) {
    if (productOrCartItem is CartItem) {
      _items.remove(productOrCartItem);
    } else {
      _items.removeWhere((item) => item.product == productOrCartItem);
    }
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}

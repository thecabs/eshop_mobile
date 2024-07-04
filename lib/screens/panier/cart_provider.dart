import 'package:eshop/models/produit.dart';
import 'package:flutter/material.dart';

class CartProvider extends ChangeNotifier {
  List<Product> _cartItems = [];

  List<Product> get cartItems => _cartItems;

  double get totalPrice {
    return _cartItems.fold(
      0,
      (sum, product) => sum + product.prixAsDouble * product.quantity,
    );
  }

  void addToCart(Product product) {
    final existingProductIndex = _cartItems.indexWhere((item) =>
        item.codePro == product.codePro &&
        item.taille == product.taille &&
        item.couleur == product.couleur);
    if (existingProductIndex >= 0) {
      _cartItems[existingProductIndex] = _cartItems[existingProductIndex]
          .copyWith(
              quantity:
                  _cartItems[existingProductIndex].quantity + product.quantity);
    } else {
      _cartItems.add(product);
    }
    notifyListeners();
  }

  void removeFromCart(Product product) {
    _cartItems.removeWhere((item) =>
        item.codePro == product.codePro &&
        item.taille == product.taille &&
        item.couleur == product.couleur);
    notifyListeners();
  }

  void incrementQuantity(Product product) {
    _updateProductQuantity(product, 1);
  }

  void decrementQuantity(Product product) {
    _updateProductQuantity(product, -1);
  }

  void clearCart() {
    _cartItems.clear();
    notifyListeners();
  }

  void _updateProductQuantity(Product product, int change) {
    final index = _cartItems.indexWhere((item) =>
        item.codePro == product.codePro &&
        item.taille == product.taille &&
        item.couleur == product.couleur);
    if (index >= 0) {
      final newQuantity = _cartItems[index].quantity + change;
      if (newQuantity > 0) {
        _cartItems[index] = _cartItems[index].copyWith(quantity: newQuantity);
      } else {
        _cartItems.removeAt(index);
      }
      notifyListeners();
    }
  }
}

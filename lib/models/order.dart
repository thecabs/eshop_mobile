import 'package:eshop/models/Produit.dart';

class Order {
  final String customerName;
  final String phoneNumber;
  final String deliveryAddress;
  final String comment;
  final List<Product> products;
  final double totalPrice;

  Order({
    required this.customerName,
    required this.phoneNumber,
    required this.deliveryAddress,
    required this.comment,
    required this.products,
    required this.totalPrice,
  });
}

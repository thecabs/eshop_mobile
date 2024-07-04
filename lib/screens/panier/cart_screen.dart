import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/models/produit.dart';
import 'package:eshop/screens/panier/cart_provider.dart';
import 'package:eshop/screens/panier/checkout.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CartScreeno extends StatefulWidget {
  static String routeName = "/carto";

  const CartScreeno({super.key});

  @override
  State<CartScreeno> createState() => _CartScreenoState();
}

class _CartScreenoState extends State<CartScreeno> {
  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            const Text(
              "Votre Panier",
              style: TextStyle(color: Colors.black),
            ),
            Text(
              "${cartProvider.cartItems.length} Produit(s)",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: cartProvider.cartItems.isEmpty
            ? Center(child: Text('Votre panier est vide'))
            : ListView.builder(
                itemCount: cartProvider.cartItems.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Dismissible(
                    key: Key(cartProvider.cartItems[index].codePro.toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      setState(() {
                        cartProvider
                            .removeFromCart(cartProvider.cartItems[index]);
                      });
                    },
                    background: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFE6E6),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          const Spacer(),
                          Icon(Icons.delete, color: Colors.red),
                        ],
                      ),
                    ),
                    child: CartItemTile(
                      product: cartProvider.cartItems[index],
                      cartProvider: cartProvider,
                    ),
                  ),
                ),
              ),
      ),
      bottomNavigationBar: CheckoutCard(cartProvider: cartProvider),
    );
  }
}

class CartItemTile extends StatelessWidget {
  final Product product;
  final CartProvider cartProvider;

  const CartItemTile({
    Key? key,
    required this.product,
    required this.cartProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Container(
        padding: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3), // changes position of shadow
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: product.photos != null && product.photos!.isNotEmpty
                  ? CachedNetworkImage(
                      imageUrl: product.photos![0],
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) =>
                          Icon(Icons.image_not_supported),
                    )
                  : Icon(Icons.image_not_supported),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.nomPro,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Text(
                    '${product.prixAsDouble} FCFA',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Quantité: ${product.quantity}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Taille: ${product.taille ?? "Non spécifiée"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Couleur: ${product.couleur ?? "Non spécifiée"}',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[700],
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                IconButton(
                  icon: Icon(Icons.remove),
                  onPressed: () {
                    cartProvider.decrementQuantity(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Quantité diminuée")),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.add),
                  onPressed: () {
                    cartProvider.incrementQuantity(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Quantité augmentée")),
                    );
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    cartProvider.removeFromCart(product);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text("Produit supprimé")),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class CheckoutCard extends StatelessWidget {
  final CartProvider cartProvider;

  const CheckoutCard({
    Key? key,
    required this.cartProvider,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 16,
        horizontal: 20,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
        boxShadow: [
          BoxShadow(
            offset: const Offset(0, -15),
            blurRadius: 20,
            color: const Color(0xFFDADADA).withOpacity(0.15),
          )
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row(
            //   children: [
            //     Container(
            //       padding: const EdgeInsets.all(10),
            //       height: 40,
            //       width: 40,
            //       decoration: BoxDecoration(
            //         color: const Color(0xFFF5F6F9),
            //         borderRadius: BorderRadius.circular(10),
            //       ),
            //       child: Icon(Icons.receipt),
            //     ),
            //     const Spacer(),
            //     const Text("Add voucher code"),
            //     const SizedBox(width: 8),
            //     const Icon(
            //       Icons.arrow_forward_ios,
            //       size: 12,
            //     )
            //   ],
            // ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Text.rich(
                    TextSpan(
                      text: "Total:\n",
                      children: [
                        TextSpan(
                          text: "${cartProvider.totalPrice} FCFA",
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  width: 200, // Largeur fixe du bouton
                  height: 60, // Hauteur fixe du bouton
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutScreen(
                            products: cartProvider.cartItems,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check),
                        SizedBox(width: 8),
                        Text('Commander', style: TextStyle(fontSize: 18)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

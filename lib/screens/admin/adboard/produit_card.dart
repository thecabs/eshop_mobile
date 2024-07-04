import 'package:cached_network_image/cached_network_image.dart';
import 'package:eshop/constants.dart';
import 'package:eshop/models/produitad.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eshop/services/admin/fetchproduitsadmin.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    this.width = 140,
    this.aspectRatio = 1.02,
    required this.product,
    required this.onPress,
  }) : super(key: key);

  final double width, aspectRatio;
  final Product product;
  final VoidCallback onPress;

  String formatProductCode(String code) {
    List<String> parts = [];
    for (int i = 0; i < code.length; i += 3) {
      parts.add(code.substring(i, i + 3 > code.length ? code.length : i + 3));
    }
    return parts.join('-');
  }

  String formatDate(String dateTime) {
    final DateTime parsedDate = DateTime.parse(dateTime);
    return DateFormat('yyyy-MM-dd HH:mm:ss').format(parsedDate);
  }

  int calculateTotal(int sold, int withdrawn) {
    return sold + withdrawn;
  }

  Future<void> _showProductDetails(BuildContext context) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );

    try {
      final productDetails = await fetchProductDetails(product.codePro);

      Navigator.of(context).pop(); // Close loading dialog

      final int totalSold = (productDetails['qte_vendue'] ?? [])
          .fold(0, (sum, item) => sum + item['quantity']);
      final int totalWithdrawn = (productDetails['qte_retiree'] ?? [])
          .fold(0, (sum, item) => sum + item['quantity']);
      final int total = calculateTotal(totalSold, totalWithdrawn);
      final int totalAdded = (productDetails['qte_ajoutee'] ?? [])
          .fold(0, (sum, item) => sum + item['quantity']);

      // Fetch category name
      final String categoryName = await fetchCategoryName(product.categorie_id);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(product.nomPro, textAlign: TextAlign.center),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CachedNetworkImage(
                    imageUrl: product.photos!.isNotEmpty
                        ? product.photos!.first
                        : 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                    fit: BoxFit.fill,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Center(
                      child: CircularProgressIndicator(
                        value: downloadProgress.progress,
                      ),
                    ),
                    errorWidget: (context, url, error) => Image.asset(
                      'assets/images/empty.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'CodePro: ${formatProductCode(product.codePro.toString())}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Nom: ${product.nomPro}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Date de: ${formatDate(product.createdAt.toString())}',
                    textAlign: TextAlign.center,
                  ),
                  Text(
                    'Quantité disponible: ${product.qte}',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.red),
                  ),
                  Text(
                    'Catégorie: $categoryName', // Use the fetched category name
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      children: [
                        Text(
                          'Total Quantité vendue: $totalSold',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.green),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (productDetails['qte_vendue'] ?? [])
                              .map<Widget>((item) => Text(
                                    '- Quantité vendue: ${item['quantity']} \n Date: ${formatDate(item['date'])}',
                                    textAlign: TextAlign.center,
                                  ))
                              .toList(),
                        ),
                        Text(
                          'Total Quantité retirée: $totalWithdrawn',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.orange),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: (productDetails['qte_retiree'] ?? [])
                              .map<Widget>((item) => Text(
                                    ' - Quantité retirée: ${item['quantity']} \n   Date: ${formatDate(item['date'])}',
                                    textAlign: TextAlign.center,
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Total Quantité (vendue + retirée): $total',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    'Total Quantité Ajoutée: $totalAdded',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.blue),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: (productDetails['qte_ajoutee'] ?? [])
                        .map<Widget>((item) => Text(
                              '- Quantité ajoutée: ${item['quantity']} \n  Date: ${formatDate(item['date'])}',
                              textAlign: TextAlign.center,
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      Navigator.of(context).pop();

      String errorMessage = _handleError(e);
      print('Error: $e');

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Erreur', textAlign: TextAlign.center),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Fermer'),
              ),
            ],
          );
        },
      );
    }
  }

  String _handleError(dynamic e) {
    if (e is NetworkException) {
      return 'Erreur réseau. Veuillez vérifier votre connexion Internet.';
    } else if (e is ServerException) {
      return 'Erreur du serveur. Veuillez réessayer plus tard.';
    } else if (e is NotFoundException) {
      return 'Produit non trouvé. Veuillez vérifier le code du produit.';
    } else {
      return 'Échec du chargement des détails du produit après plusieurs tentatives. Veuillez réessayer plus tard.';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: GestureDetector(
        onTap: () => _showProductDetails(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: aspectRatio,
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: kSecondaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: CachedNetworkImage(
                  imageUrl: product.photos!.isNotEmpty
                      ? product.photos!.first
                      : 'https://i.pravatar.cc/150?u=a042581f4e29026704d',
                  fit: BoxFit.fill,
                  progressIndicatorBuilder: (context, url, downloadProgress) =>
                      Center(
                    child: CircularProgressIndicator(
                      value: downloadProgress.progress,
                    ),
                  ),
                  errorWidget: (context, url, error) => Image.asset(
                    'assets/images/empty.png',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text(
                'CodePro: ${formatProductCode(product.codePro.toString())}',
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 1,
              ),
            ),
            Center(
              child: Text(
                product.nomPro,
                style: Theme.of(context).textTheme.bodyMedium,
                maxLines: 2,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "${product.prix} FCFA",
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kPrimaryColor,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shimmer/shimmer.dart';

class OrderHistoryScreen extends StatefulWidget {
  const OrderHistoryScreen({Key? key}) : super(key: key);

  static String routeName = "/order_history";

  @override
  _OrderHistoryScreenState createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  List<Map<String, dynamic>> orderHistory = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrderHistory();
  }

  Future<void> _loadOrderHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? orderHistoryString = prefs.getString('orderHistory');
    if (orderHistoryString != null) {
      setState(() {
        orderHistory =
            List<Map<String, dynamic>>.from(json.decode(orderHistoryString));
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _refreshOrderHistory() async {
    setState(() {
      isLoading = true;
    });
    await _loadOrderHistory();
  }

  void _showOrderDetails(Map<String, dynamic> order) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Détails de la commande',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text('Nom du client: ${order['nomClient']}'),
                    Text('Mobile: ${order['mobile']}'),
                    if (order['addresse'] != null)
                      Text('Adresse: ${order['addresse']}'),
                    if (order['commentaire'] != null)
                      Text('Commentaire: ${order['commentaire']}'),
                    SizedBox(height: 10.0),
                    Text(
                      'Produits:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    ...order['productList'].map<Widget>((product) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Code Produit: ${product['codePro']}'),
                          Text('Quantité: ${product['qte']}'),
                          Text('Taille: ${product['taille']}'),
                          Text('Couleur: ${product['couleur']}'),
                          SizedBox(height: 10.0),
                        ],
                      );
                    }).toList(),
                    Text(
                      'Total: ${order['montant']} FCFA',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20.0),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        child: Text('Fermer'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Historique des commandes',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshOrderHistory,
        child: isLoading
            ? _buildShimmerEffect()
            : orderHistory.isEmpty
                ? Center(child: Text('Aucune commande passée'))
                : ListView.builder(
                    itemCount: orderHistory.length,
                    itemBuilder: (context, index) {
                      final order = orderHistory[index];
                      return Card(
                        margin: EdgeInsets.all(10.0),
                        elevation: 5.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: ListTile(
                          leading: SvgPicture.asset(
                            'assets/icons/Bill Icon.svg',
                            width: 40.0,
                            height: 40.0,
                          ),
                          title: Text(
                            'Nom du client: ${order['nomClient']}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.blue.shade900,
                            ),
                          ),
                          subtitle: Text(
                            'Total: ${order['montant']} FCFA',
                            style: TextStyle(
                              color: Colors.blue.shade700,
                            ),
                          ),
                          trailing: Icon(
                            Icons.arrow_forward_ios,
                            color: Colors.blue.shade700,
                          ),
                          onTap: () => _showOrderDetails(order),
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return ListView.builder(
      itemCount: 5, // Nombre d'éléments shimmer à afficher
      itemBuilder: (context, index) {
        return Card(
          margin: EdgeInsets.all(10.0),
          elevation: 5.0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: ListTile(
            leading: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: 40.0,
                height: 40.0,
                color: Colors.white,
              ),
            ),
            title: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 10.0,
                color: Colors.white,
              ),
            ),
            subtitle: Shimmer.fromColors(
              baseColor: Colors.grey.shade300,
              highlightColor: Colors.grey.shade100,
              child: Container(
                width: double.infinity,
                height: 10.0,
                color: Colors.white,
              ),
            ),
          ),
        );
      },
    );
  }
}

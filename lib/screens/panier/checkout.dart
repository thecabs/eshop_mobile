import 'dart:math';

import 'package:eshop/helper/keyboard.dart';
import 'package:eshop/models/produit.dart';
import 'package:eshop/screens/components/custom_surfix_icon.dart';
import 'package:eshop/screens/init_screen.dart';
import 'package:eshop/screens/panier/cart_provider.dart';
import 'package:eshop/screens/panier/components/client_carte_added.dart';
import 'package:eshop/services/user/fetchville.dart';
import 'package:eshop/services/user/order_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckoutScreen extends StatefulWidget {
  static const String routeName = '/checkouto';
  final List<Product> products;

  CheckoutScreen({Key? key, required this.products}) : super(key: key);

  @override
  _CheckoutScreenState createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  bool loading = false;
  String? nomClient;
  String? mobile;
  String? addresse;
  String? commentaire;
  Ville? selectedVille;
  List<Ville> villes = [];
  bool isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchVilles().then((villes) {
      setState(() {
        this.villes = villes;
        isLoading = false;
      });
    }).catchError((error) {
      setState(() {
        errorMessage = 'Failed to load villes';
        isLoading = false;
      });
    });
  }

  void _submitOrder(BuildContext context) async {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      setState(() {
        loading = true;
      });

      try {
        final success = await submitOrder(
          products: widget.products,
          nomClient: nomClient!,
          mobile: mobile!,
          addresse: addresse,
          commentaire: commentaire,
          villeId: selectedVille!.id,
          context: context,
        );

        if (success) {
          setState(() {
            loading = false;
            // Clear the form fields
            nomClient = null;
            mobile = null;
            addresse = null;
            commentaire = null;
            selectedVille = null;
          });

          Provider.of<CartProvider>(context, listen: false).clearCart();

          // Navigate to ProductPage
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Commande Passée avec succès')),
          );
          Navigator.pushReplacementNamed(context, InitScreen.routeName);
        } else {
          setState(() {
            loading = false;
          });

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Erreur lors de la passation de la commande')),
          );
        }
      } catch (error) {
        setState(() {
          loading = false;
        });

        print(error);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la passation de la commande')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Passer une commande'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: isLoading
            ? Center(child: CircularProgressIndicator())
            : errorMessage.isNotEmpty
                ? Center(child: Text(errorMessage))
                : SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Produits à commander:',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(height: 8),
                          Container(
                            height: 200,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: widget.products.length,
                              itemBuilder: (context, index) {
                                final product = widget.products[index];
                                return Card(
                                  child: Container(
                                    width: 150,
                                    padding: EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        product.photos != null &&
                                                product.photos!.isNotEmpty
                                            ? Image.network(
                                                product.photos![0],
                                                height: 80,
                                                width: 80,
                                                fit: BoxFit.cover,
                                              )
                                            : Text('Pas d\'image'),
                                        SizedBox(height: 8),
                                        Text(
                                          product.nomPro,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Prix: ${product.prixAsDouble} FCFA',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Quantité: ${product.quantity}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Taille: ${product.taille ?? "Non spécifiée"}',
                                          textAlign: TextAlign.center,
                                        ),
                                        Text(
                                          'Couleur: ${product.couleur ?? "Non spécifiée"}',
                                          textAlign: TextAlign.center,
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                          SizedBox(height: 16),
                          Text(
                            'Prix total: ${widget.products.fold(0, (sum, item) => sum + (item.prixAsDouble.toInt() * item.quantity))} FCFA',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.name,
                            decoration: const InputDecoration(
                              labelText: "Nom du Client",
                              hintText: "Entrez votre nom",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: CustomSurffixIcon(
                                  svgIcon: "assets/icons/User.svg"),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer le nom du client';
                              }
                              return null;
                            },
                            onSaved: (value) => nomClient = value,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: const InputDecoration(
                              labelText: "Mobile",
                              hintText: "Entrez votre Mobile",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: CustomSurffixIcon(
                                  svgIcon: "assets/icons/Phone.svg"),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Veuillez entrer le numéro de mobile';
                              }
                              return null;
                            },
                            onSaved: (value) => mobile = value,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.streetAddress,
                            decoration: const InputDecoration(
                              labelText: "Adresse",
                              hintText: "Entrez votre Adresse",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: CustomSurffixIcon(
                                  svgIcon: "assets/icons/Location point.svg"),
                            ),
                            onSaved: (value) => addresse = value,
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: const InputDecoration(
                              labelText: "Commentaire",
                              hintText: " ",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              suffixIcon: CustomSurffixIcon(
                                  svgIcon: "assets/icons/Chat bubble Icon.svg"),
                            ),
                            onSaved: (value) => commentaire = value,
                          ),
                          SizedBox(height: 15),
                          DropdownButtonFormField<Ville>(
                            decoration: InputDecoration(labelText: 'Ville'),
                            items: villes.map((ville) {
                              return DropdownMenuItem<Ville>(
                                value: ville,
                                child: Text(ville.libelle),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedVille = value;
                              });
                            },
                            value: selectedVille,
                            validator: (value) {
                              if (value == null) {
                                return 'Veuillez sélectionner une ville';
                              }
                              return null;
                            },
                            onSaved: (value) => selectedVille = value,
                          ),
                          SizedBox(height: 16),
                          loading
                              ? const Center(
                                  child: CircularProgressIndicator(),
                                )
                              : ElevatedButton(
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      // if all are valid then go to success screen
                                      KeyboardUtil.hideKeyboard(context);

                                      _submitOrder(context);
                                    }
                                  },
                                  child: const Text("Valider la Commande"),
                                ),
                        ],
                      ),
                    ),
                  ),
      ),
    );
  }
}

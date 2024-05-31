import 'package:eshop/helper/keyboard.dart';
import 'package:eshop/models/Produit.dart';
import 'package:eshop/screens/components/custom_surfix_icon.dart';
import 'package:eshop/services/fetchville.dart';
import 'package:eshop/services/order_service.dart';
import 'package:flutter/material.dart';

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
  double? avance;
  double remise = 0;
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

  void _submitOrder(BuildContext context) {
    if (_formKey.currentState?.validate() ?? false) {
      _formKey.currentState?.save();
      // Assuming submitOrder is a function that handles order submission
      submitOrder(
        products: widget.products,
        nomClient: nomClient!,
        mobile: mobile!,
        addresse: addresse,
        commentaire: commentaire,
        avance: avance,
        remise: remise,
        villeId: selectedVille!.id,
        context: context,
      );
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
                            height: 200, // Fixe la hauteur du ListView
                            child: ListView.builder(
                              itemCount: widget.products.length,
                              itemBuilder: (context, index) {
                                final product = widget.products[index];
                                return ListTile(
                                  title: Text(product.nomPro),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                          'Prix: ${product.prixAsDouble} FCFA'),
                                      Text('Quantité: ${product.quantity}'),
                                      Text(
                                          'Taille: ${product.taille ?? "Non spécifiée"}'),
                                      Text(
                                          'Couleur: ${product.couleur ?? "Non spécifiée"}'),
                                    ],
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
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Avance'),
                            keyboardType: TextInputType.number,
                            onSaved: (value) =>
                                avance = double.tryParse(value ?? '0'),
                          ),
                          SizedBox(height: 15),
                          TextFormField(
                            decoration: InputDecoration(labelText: 'Remise'),
                            keyboardType: TextInputType.number,
                            initialValue: remise.toString(),
                            validator: (value) {
                              if (value == null ||
                                  double.tryParse(value) == null) {
                                return 'Veuillez entrer une remise valide';
                              }
                              return null;
                            },
                            onSaved: (value) => remise = double.parse(value!),
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

                                      setState(() {
                                        loading = true;
                                        _submitOrder(context);
                                      });
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

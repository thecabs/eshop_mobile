import 'package:eshop/screens/products/components/produit_card.dart';
import 'package:eshop/services/user/fetchproduits.dart';
import 'package:flutter/material.dart';
import 'package:eshop/models/produit.dart';
import 'package:eshop/screens/details/details_screen.dart';
import 'package:shimmer/shimmer.dart';

class ProductsByCategoryPage extends StatefulWidget {
  final int categoryId;
  final String categoryName;

  ProductsByCategoryPage({
    required this.categoryId,
    required this.categoryName,
  });

  @override
  _ProductsByCategoryPageState createState() => _ProductsByCategoryPageState();
}

class _ProductsByCategoryPageState extends State<ProductsByCategoryPage> {
  late Future<List<Product>> _futureProducts;
  int _currentPage = 1;
  int _totalPages = 1;
  TextEditingController _searchController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 1500000;
  late RangeValues _selectedPriceRange;
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedPriceRange = RangeValues(_minPrice, _maxPrice);
    _minPriceController.text = _minPrice.toString();
    _maxPriceController.text = _maxPrice.toString();
    _fetchProducts();
  }

  void _fetchProducts() {
    setState(() {
      _futureProducts = fetchProductscat(
        categoryId: widget.categoryId,
        page: _currentPage,
        search: _searchController.text,
        prix1: _selectedPriceRange.start,
        prix2: _selectedPriceRange.end,
      ).then((products) {
        _totalPages = (products.length / 10).ceil();
        return products;
      });
    });
  }

  Future<void> _refreshProducts() async {
    _currentPage = _currentPage;
    _fetchProducts();
  }

  void _showPriceFilterDialog() {
    showDialog(
      context: context,
      builder: (context) {
        double tempMinPrice = _selectedPriceRange.start;
        double tempMaxPrice = _selectedPriceRange.end;
        TextEditingController tempMinPriceController =
            TextEditingController(text: tempMinPrice.toString());
        TextEditingController tempMaxPriceController =
            TextEditingController(text: tempMaxPrice.toString());

        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text('Filtrer par prix'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: tempMinPriceController,
                    decoration: InputDecoration(labelText: 'Prix minimum'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final double? minPrice = double.tryParse(value);
                      if (minPrice != null && minPrice <= tempMaxPrice) {
                        setState(() {
                          tempMinPrice = minPrice;
                        });
                      }
                    },
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: tempMaxPriceController,
                    decoration: InputDecoration(labelText: 'Prix maximum'),
                    keyboardType: TextInputType.number,
                    onChanged: (value) {
                      final double? maxPrice = double.tryParse(value);
                      if (maxPrice != null && maxPrice >= tempMinPrice) {
                        setState(() {
                          tempMaxPrice = maxPrice;
                        });
                      }
                    },
                  ),
                  RangeSlider(
                    values: RangeValues(tempMinPrice, tempMaxPrice),
                    min: _minPrice,
                    max: _maxPrice,
                    divisions: 100,
                    labels: RangeLabels(
                      tempMinPrice.round().toString(),
                      tempMaxPrice.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        tempMinPrice = values.start;
                        tempMinPriceController.text = values.start.toString();
                        tempMaxPrice = values.end;
                        tempMaxPriceController.text = values.end.toString();
                      });
                    },
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Min: ${tempMinPrice.round()}'),
                      Text('Max: ${tempMaxPrice.round()}'),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Annuler'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _selectedPriceRange =
                          RangeValues(tempMinPrice, tempMaxPrice);
                      _minPriceController.text = tempMinPrice.toString();
                      _maxPriceController.text = tempMaxPrice.toString();
                    });
                    _fetchProducts();
                    Navigator.of(context).pop();
                  },
                  child: Text('Appliquer'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _loadNextPage() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
      });
      _fetchProducts();
    }
  }

  void _loadPreviousPage() {
    if (_currentPage > 1) {
      setState(() {
        _currentPage--;
      });
      _fetchProducts();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produits - ${widget.categoryName}',
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.grey.withOpacity(0.1),
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: BorderSide.none,
                      ),
                      hintText: "Rechercher un produit",
                      prefixIcon: const Icon(Icons.search),
                    ),
                    onChanged: (_) => _fetchProducts(),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.filter_list),
                  onPressed: _showPriceFilterDialog,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child: FutureBuilder<List<Product>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerEffect(); // Affiche l'effet de shimmer pendant le chargement
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Erreur: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(child: Text('Aucun produit trouvé'));
                  } else {
                    final products = snapshot.data!;
                    return Column(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: GridView.builder(
                              itemCount: products.length,
                              gridDelegate:
                                  const SliverGridDelegateWithMaxCrossAxisExtent(
                                maxCrossAxisExtent: 200,
                                childAspectRatio: 0.7,
                                mainAxisSpacing: 20,
                                crossAxisSpacing: 16,
                              ),
                              itemBuilder: (context, index) {
                                final product = products[index];
                                return ProductCard(
                                  product: product,
                                  onPress: () => Navigator.pushNamed(
                                    context,
                                    '/details',
                                    arguments: ProductDetailsArguments(
                                        product: product),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back_ios),
                              onPressed: _loadPreviousPage,
                            ),
                            Text('Page $_currentPage / $_totalPages'),
                            IconButton(
                              icon: Icon(Icons.arrow_forward_ios),
                              onPressed: _loadNextPage,
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildShimmerEffect() {
    return Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200,
          childAspectRatio: 0.7,
          mainAxisSpacing: 20,
          crossAxisSpacing: 16,
        ),
        itemBuilder: (context, index) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    color: Colors.grey[300],
                  ),
                ),
                SizedBox(height: 8),
                Container(
                  height: 10,
                  width: double.infinity,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 100,
                  color: Colors.grey[300],
                ),
                SizedBox(height: 4),
                Container(
                  height: 10,
                  width: 150,
                  color: Colors.grey[300],
                ),
              ],
            ),
          );
        },
        itemCount: 6, // Nombre de cartes de shimmer à afficher
      ),
    );
  }
}

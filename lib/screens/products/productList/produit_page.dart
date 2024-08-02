import 'dart:async';
import 'package:eshop/screens/components/produit_card.dart';
import 'package:eshop/screens/details/details_screen.dart';
import 'package:eshop/services/user/fetchproduits.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ProductsPage extends StatefulWidget {
  final String? searchQuery;
  final double? minPrice;
  final double? maxPrice;

  ProductsPage({this.searchQuery, this.minPrice, this.maxPrice});

  @override
  _ProductsPageState createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {
  final ScrollController _scrollController = ScrollController();
  List<dynamic> _products = [];
  bool _isLoadingMore = false;
  bool _isInitialLoading = true;
  bool _hasError = false;
  String _errorMessage = '';
  int _currentPage = 1;
  int _totalPages = 1;
  TextEditingController _searchController = TextEditingController();
  double _minPrice = 0;
  double _maxPrice = 150000;
  late RangeValues _selectedPriceRange;
  TextEditingController _minPriceController = TextEditingController();
  TextEditingController _maxPriceController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _selectedPriceRange = RangeValues(_minPrice, _maxPrice);
    _minPriceController.text =
        widget.minPrice?.toString() ?? _minPrice.toString();
    _maxPriceController.text =
        widget.maxPrice?.toString() ?? _maxPrice.toString();
    _searchController.text = widget.searchQuery ?? '';
    _fetchProducts();

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
              _scrollController.position.maxScrollExtent &&
          !_isLoadingMore) {
        _loadMoreProducts();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _fetchProducts() {
    setState(() {
      _isLoadingMore = true;
      _isInitialLoading = _currentPage == 1;
      _hasError = false;
    });

    fetchProducts(
      page: _currentPage,
      search: _searchController.text,
      prix1: double.tryParse(_minPriceController.text),
      prix2: double.tryParse(_maxPriceController.text),
    ).then((response) {
      setState(() {
        _isLoadingMore = false;
        _isInitialLoading = false;
        _totalPages = response['last_page'];
        if (_currentPage == 1) {
          _products = response['items'];
        } else {
          _products.addAll(response['items']);
        }
      });
    }).catchError((error) {
      setState(() {
        _isLoadingMore = false;
        _isInitialLoading = false;
        _hasError = true;
        _errorMessage = 'Failed to load products. Please try again.';
      });
    });
  }

  void _loadMoreProducts() {
    if (_currentPage < _totalPages) {
      setState(() {
        _currentPage++;
        _fetchProducts();
      });
    }
  }

  Future<void> _refreshProducts() async {
    _currentPage = 1;
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
                  SizedBox(
                    height: 20,
                  ),
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

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      setState(() {
        _currentPage = 1;
      });
      _fetchProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Produits',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [],
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
                    onChanged: _onSearchChanged,
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
              child: _isInitialLoading
                  ? _buildShimmerEffect()
                  : _hasError
                      ? Center(
                          child: Text(
                            _errorMessage,
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                        )
                      : Scrollbar(
                          controller: _scrollController,
                          thumbVisibility: true,
                          child: GridView.builder(
                            controller: _scrollController,
                            itemCount:
                                _products.length + (_isLoadingMore ? 1 : 0),
                            gridDelegate:
                                const SliverGridDelegateWithMaxCrossAxisExtent(
                              maxCrossAxisExtent: 200,
                              childAspectRatio: 0.7,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 16,
                            ),
                            itemBuilder: (context, index) {
                              if (index == _products.length) {
                                return ProductCardShimmer(
                                  width: 140,
                                  aspectRatio: 1.02,
                                );
                              }
                              final product = _products[index];
                              return ProductCard(
                                product: product,
                                onPress: () => Navigator.pushNamed(
                                  context,
                                  '/details',
                                  arguments:
                                      ProductDetailsArguments(product: product),
                                ),
                              );
                            },
                          ),
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
        itemCount: 6,
        itemBuilder: (context, index) {
          return ProductCardShimmer(
            width: 140,
            aspectRatio: 1.02,
          );
        },
      ),
    );
  }
}

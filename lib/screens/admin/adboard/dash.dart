import 'package:flutter/material.dart';
//import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:eshop/services/admin/fetchproduitsadmin.dart';
import 'package:eshop/screens/admin/adboard/produit_card.dart';
import 'package:eshop/screens/details/details_screen.dart';
import 'package:shimmer/shimmer.dart';

class Dashboard extends StatefulWidget {
  final String? searchQuery;

  Dashboard({this.searchQuery});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late Future<Map<String, dynamic>> _futureProducts;
  int _currentPage = 1;
  int _totalPages = 1;
  int _totalProducts = 0;
  TextEditingController _searchController = TextEditingController();
  RangeValues _priceRange = RangeValues(0, 100000);
  DateTimeRange? _dateRange;
  String _userName = '';

  @override
  void initState() {
    super.initState();
    _searchController.text = widget.searchQuery ?? '';
    _fetchUserName();
    _fetchProducts();
  }

  Future<void> _fetchUserName() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? userName = pref.getString('nomGest');
    setState(() {
      _userName = userName ?? 'Utilisateur';
    });
  }

  void _fetchProducts() {
    setState(() {
      _futureProducts = fetchProducts(
        page: _currentPage,
        search: _searchController.text,
        minPrice: _priceRange.start,
        maxPrice: _priceRange.end,
        codePro: _searchController.text,
        dateStart: _dateRange?.start,
        dateEnd: _dateRange?.end,
      );
    });
  }

  Future<void> _refreshProducts() async {
    _fetchProducts();
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

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      initialDateRange: _dateRange,
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _dateRange) {
      setState(() {
        _dateRange = picked;
      });
      _fetchProducts();
    }
  }

  Future<void> _showPriceRangeDialog(BuildContext context) async {
    RangeValues tempRange = _priceRange;
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text('Filtrer par prix'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RangeSlider(
                    values: tempRange,
                    min: 0,
                    max: 100000,
                    divisions: 100,
                    labels: RangeLabels(
                      tempRange.start.round().toString(),
                      tempRange.end.round().toString(),
                    ),
                    onChanged: (RangeValues values) {
                      setState(() {
                        tempRange = values;
                      });
                    },
                  ),
                  Text(
                      'Prix: ${tempRange.start.round()} - ${tempRange.end.round()}'),
                ],
              ),
              actions: <Widget>[
                TextButton(
                  child: const Text('Annuler'),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
                TextButton(
                  child: const Text('Appliquer'),
                  onPressed: () {
                    setState(() {
                      _priceRange = tempRange;
                    });
                    _fetchProducts();
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextFormField(
              controller: _searchController,
              decoration: InputDecoration(
                filled: true,
                fillColor: Colors.grey.withOpacity(0.1),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDateRange(context),
          ),
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () => _showPriceRangeDialog(context),
          ),
        ],
      ),
    );
  }

  Widget _buildProductList(Map<String, dynamic> data) {
    final products = data['items'];
    _totalPages = data['last_page'];
    _totalProducts = data['total'];

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  spreadRadius: 5,
                  blurRadius: 7,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'Total des produits: $_totalProducts',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: GridView.builder(
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
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
                    arguments: ProductDetailsArguments(product: product),
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
              icon: Icon(Icons.arrow_back),
              onPressed: _loadPreviousPage,
            ),
            Text('Page $_currentPage / $_totalPages'),
            IconButton(
              icon: Icon(Icons.arrow_forward),
              onPressed: _loadNextPage,
            ),
          ],
        ),
      ],
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
                  child: Container(color: Colors.grey[300]),
                ),
                SizedBox(height: 8),
                Container(height: 10, width: double.infinity),
                Container(height: 10, width: 100, color: Colors.grey[300]),
                SizedBox(height: 4),
                Container(height: 10, width: 150, color: Colors.grey[300]),
              ],
            ),
          );
        },
        itemCount: 8,
      ),
    );
  }

  Future<void> _logout() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.remove('token');
    await pref.remove('userId');
    Navigator.of(context).pushReplacementNamed('/init');
  }

  void _navigateToDashboard() {
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => Dashboard()), (route) => false);
  }

  void _navigateToProfile() {
    // Navigator.of(context).push(MaterialPageRoute(
    //   builder: (context) => UserProfileScreen(),
    // ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Gestionnaire',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: _logout,
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'Menu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Dashboard'),
              onTap: _navigateToDashboard,
            ),
            ListTile(
              leading: Icon(Icons.wysiwyg),
              title: Text('Profile'),
              onTap: _navigateToProfile,
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Bienvenue, $_userName!',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          _buildSearchBar(),
          if (_dateRange != null)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Filtré par date: ${DateFormat('dd/MM/yyyy').format(_dateRange!.start)} - ${DateFormat('dd/MM/yyyy').format(_dateRange!.end)}',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshProducts,
              child: FutureBuilder<Map<String, dynamic>>(
                future: _futureProducts,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildShimmerEffect();
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('Erreur: ${snapshot.error}'),
                          ElevatedButton(
                            onPressed: _refreshProducts,
                            child: Text('Réessayer'),
                          ),
                        ],
                      ),
                    );
                  } else if (!snapshot.hasData ||
                      snapshot.data!['items'].isEmpty) {
                    return Center(child: Text('Aucun produit trouvé'));
                  } else {
                    return _buildProductList(snapshot.data!);
                  }
                },
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 6.0,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.home),
              onPressed: _navigateToDashboard,
            ),
          ],
        ),
      ),
    );
  }
}

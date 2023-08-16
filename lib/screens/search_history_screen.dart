import 'package:flutter/material.dart';
import 'package:prc_app/components/product_card.dart';
import 'package:prc_app/models/product.dart';
import 'package:prc_app/components/product_search_storage.dart';
import 'package:prc_app/screens/product_prices_screen.dart';

class SearchHistoryScreen extends StatefulWidget {
  @override
  _SearchHistoryScreenState createState() => _SearchHistoryScreenState();
}

class _SearchHistoryScreenState extends State<SearchHistoryScreen> {
  List<Product> _searchHistory = [];
  ProductSearchStorage pSearchStorage = new ProductSearchStorage();
  @override
  void initState() {
    super.initState();
    _loadSearchHistory();
  }

  Future<void> _loadSearchHistory() async {
    final searchHistory = await pSearchStorage.getSearchHistory();
    setState(() {
      _searchHistory = searchHistory;
    });
  }

  void _navigateToProductPricesScreen(Product product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductPricesScreen(product: product),
      ),
    );
  }

  void _clearSearchHistory(){
    setState(() {
      _searchHistory.clear();
      pSearchStorage.clearSearchHistory();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search History'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.delete_outline),
            onPressed: () => _clearSearchHistory(),
          )
        ],
      ),
      body: ListView.builder(
        itemCount: _searchHistory.length,
        itemBuilder: (context, index) {
          final product = _searchHistory[index];
          return ProductCard(
            product: product,
            onPressed: () => _navigateToProductPricesScreen(product),
          );
        },
      ),
    );
  }
}

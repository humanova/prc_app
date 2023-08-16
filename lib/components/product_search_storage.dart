import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:prc_app/models/product.dart';

class ProductSearchStorage {
  static const String _kSearchHistoryKey = 'search_history';

  Future<List<Product>> getSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    final searchHistoryJson = prefs.getString(_kSearchHistoryKey);

    if (searchHistoryJson != null) {
      final searchHistory = jsonDecode(searchHistoryJson);
      final products = <Product>[];

      for (final productJson in searchHistory) {
        products.add(Product.fromJson(productJson));
      }

      return products;
    }

    return [];
  }

  Future<void> saveSearch(Product product) async {
    final prefs = await SharedPreferences.getInstance();
    final searchHistoryJson = prefs.getString(_kSearchHistoryKey);

    if (searchHistoryJson != null) {
      final searchHistory = jsonDecode(searchHistoryJson).toList();

      // remove the product from the search history if it already exists
      searchHistory.removeWhere((p) => p['name'] == product.name);

      // add the product to the beginning of the search history
      searchHistory.insert(0, product.toJson());
      prefs.setString(_kSearchHistoryKey, jsonEncode(searchHistory));
    } else {
      prefs.setString(_kSearchHistoryKey, jsonEncode([product.toJson()]));
    }
  }

  Future<void> clearSearchHistory() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(_kSearchHistoryKey);
  }
}

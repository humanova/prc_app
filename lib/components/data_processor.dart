import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prc_app/models/product.dart';

class DataResponse {
  final bool isSuccess;
  final dynamic data;

  DataResponse({this.isSuccess, this.data});
}

class DataProcessor {
  final String apiUrl = 'http://localhost:8001/api/price';

  Future<DataResponse> getPrices(String imageBase64) async {
    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'image': imageBase64}),
      );

      return DataResponse(
          isSuccess: response.statusCode == 200, data: response.body);
    } catch (e) {
      return DataResponse(isSuccess: false, data: e.toString());
    }
  }

  Product parseProduct(dynamic jsonData) {
    final String name = jsonData['name'];
    final String image = jsonData['image'];
    final List<dynamic> pricesData = jsonData['prices'];

    final List<Price> prices = pricesData.map((data) {
      final String store = data['store'];
      final double price = data['price'];
      return Price(store: store, price: price);
    }).toList();

    return Product(name: name, image: image, prices: prices);
  }
}

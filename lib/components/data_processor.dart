import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:prc_app/models/product.dart';

class DataResponse {
  final bool isSuccess;
  final dynamic data;

  DataResponse({this.isSuccess, this.data});
}

class DataProcessor {
  final String apiUrl = 'https://humanova.space/api/price';

  Future<DataResponse> getPricesByImage(String imageBase64) async {
    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'image': imageBase64}),
      );

      return DataResponse(
          isSuccess: response.statusCode == 200,
          data: json.decode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      return DataResponse(isSuccess: false, data: e.toString());
    }
  }

  Future<DataResponse> getPricesByQuery(String query) async {
    try {
      final response = await http.post(
        apiUrl,
        headers: {
          'Content-Type': 'application/json',
        },
        body: json.encode({'text': query}),
      );

      return DataResponse(
          isSuccess: response.statusCode == 200,
          data: json.decode(utf8.decode(response.bodyBytes)));
    } catch (e) {
      return DataResponse(isSuccess: false, data: e.toString());
    }
  }

  Product parseProduct(dynamic jsonData) {
    final String name = jsonData['name'];
    final String image = jsonData['image'];
    final String query = jsonData['query'];
    final List<dynamic> pricesData = jsonData['prices'];

    final List<Price> prices = pricesData
        .map((dynamic priceData) => Price(
              store: priceData['store'],
              price: priceData['price'].toDouble(),
            ))
        .toList();

    return Product(name: name, image: image, query: query, prices: prices);
  }
}

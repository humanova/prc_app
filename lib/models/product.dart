class Product {
  final String name;
  final String image;
  final String query;
  final List<Price> prices;

  Product({this.name, this.image, this.query, this.prices});

  factory Product.fromJson(Map<String, dynamic> json) {
    var priceList = json['prices'] as List;
    List<Price> prices = priceList.map((priceJson) => Price.fromJson(priceJson)).toList();

    return Product(
      name: json['name'] as String,
      image: json['image'] as String,
      query: json['query'] as String,
      prices: prices,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['query'] = this.query;
    data['prices'] = this.prices.map((price) => price.toJson()).toList();
    return data;
  }
}

class Price {
  final String store;
  final double price;

  Price({this.store, this.price});

  factory Price.fromJson(Map<String, dynamic> json) {
    return Price(
      store: json['store'] as String,
      price: json['price'] as double,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'store': store,
      'price': price,
    };
  }
}

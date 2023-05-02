import 'package:flutter/material.dart';
import 'package:prc_app/models/product.dart';

class ProductPricesScreen extends StatefulWidget {
  final Product product;

  ProductPricesScreen({this.product});

  @override
  _ProductPricesScreenState createState() => _ProductPricesScreenState();
}

class _ProductPricesScreenState extends State<ProductPricesScreen> {
  List<Price> _prices;

  @override
  void initState() {
    super.initState();
    setState(() {
      _prices = widget.product.prices;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product.name),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_prices == null) {
      return Center(
        child: CircularProgressIndicator(),
      );
    } else if (_prices.isEmpty) {
      return Center(
        child: Text('No prices found'),
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 250.0,
            width: 200.0,
            child: Image.network(
              widget.product.image,
              fit: BoxFit.contain,
              width: 200.0,
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _prices.length,
              itemBuilder: (context, index) {
                final price = _prices[index];

                return ListTile(
                  title: Text(price.store),
                  subtitle: Text(price.price.toString()),
                );
              },
            ),
          ),
        ],
      );
    }
  }
}

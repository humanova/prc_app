import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:prc_app/components/data_processor.dart';
import 'package:prc_app/components/product_search_storage.dart';
import 'package:prc_app/models/product.dart';

import 'package:prc_app/screens/product_prices_screen.dart';

class ImageScreen extends StatefulWidget {
  @override
  _ImageScreenState createState() => _ImageScreenState();
}

class _ImageScreenState extends State<ImageScreen> {
  File _image;
  bool _isLoading = false;
  final dataProcessor = DataProcessor();
  final pSearchStorage = ProductSearchStorage();

  Future<void> _getImageFromCamera() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getImageFromGallery() async {
    final pickedFile =
        await ImagePicker().getImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _getPricesFromAPI() async {
    setState(() {
      _isLoading = true;
    });

    final response = await dataProcessor
        .getPricesByImage(base64Encode(_image.readAsBytesSync()));

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      Product product = dataProcessor.parseProduct(response.data);

      // Prompt the user to confirm the product
      bool confirmProduct = await showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Confirm the Product'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Center(
                child: Image.network(
                  product.image,
                  height: 100,
                ),
              ),
              SizedBox(height: 15),
              Text(product.name),
              Text('\nIs this the product you are looking for?'),
            ],
          ),
          actions: [
            FlatButton(
              onPressed: () {
                Navigator.of(context).pop(true); // User confirms the product
              },
              child: Text('Yes'),
            ),
            FlatButton(
              onPressed: () {
                Navigator.of(context)
                    .pop(false); // User wants to rewrite the query
              },
              child: Text('No'),
            ),
          ],
        ),
      );

      if (confirmProduct == true) {
        pSearchStorage.saveSearch(product);

        Navigator.of(context).push(MaterialPageRoute(
          builder: (_) => ProductPricesScreen(product: product),
        ));
      } else if (confirmProduct == false) {
        // User wants to rewrite the query
        String rewrittenQuery = await showDialog(
          context: context,
          builder: (_) {
            TextEditingController queryController =
                TextEditingController(text: product.query);

            return AlertDialog(
              title: Text('Rewrite the query'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: queryController,
                      onChanged: (value) {
                        // Handle the query text change
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close the dialog
                  },
                  child: Text('Cancel'),
                ),
                FlatButton(
                  onPressed: () {
                    String rewrittenQuery = queryController
                        .text; // Get the rewritten query from the TextField
                    Navigator.of(context)
                        .pop(rewrittenQuery); // Pass the rewritten query back
                  },
                  child: Text('Confirm'),
                ),
              ],
            );
          },
        );

        if (rewrittenQuery != null) {
          // Send getPricesByQuery request with the rewritten query
          final queryResponse =
              await dataProcessor.getPricesByQuery(rewrittenQuery);

          if (queryResponse.isSuccess) {
            Product rewrittenProduct =
                dataProcessor.parseProduct(queryResponse.data);
            pSearchStorage.saveSearch(rewrittenProduct);

            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => ProductPricesScreen(product: rewrittenProduct),
            ));
          } else {
            // Show error message for query response failure
            showDialog(
              context: context,
              builder: (_) => AlertDialog(
                title: Text('Error'),
                content: Text('Failed to get prices for the rewritten query.'),
              ),
            );
          }
        }
      }
    } else {
      // Show error message for image response failure
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to get prices.'),
        ),
      );
    }
  }

@override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(
      title: Text('Search For Product Prices'),
    ),
    body: Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_image != null)
              Image.file(
                _image,
                width: 200,
                height: 420,
              ),
            SizedBox(height: 20),
            if (_image == null)
              Column(
                children: [
                  ElevatedButton.icon(
                    onPressed: _getImageFromCamera,
                    icon: Icon(Icons.camera_alt),
                    label: Text('Take A Picture'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                  SizedBox(height: 10),
                  ElevatedButton.icon(
                    onPressed: _getImageFromGallery,
                    icon: Icon(Icons.photo_library),
                    label: Text('Choose From Gallery'),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      textStyle: TextStyle(fontSize: 20),
                    ),
                  ),
                ],
              ),
            SizedBox(height: 20),
            Opacity(
              opacity: _isLoading ? 0.0 : 1.0, // Make the button invisible when loading
              child: ElevatedButton(
                onPressed: _image == null ? null : _getPricesFromAPI,
                child: Text('Get Prices'),
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
                  textStyle: TextStyle(fontSize: 24),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  elevation: 4,
                  primary: Colors.blue, // Customize the button color
                  onPrimary: Colors.white, // Customize the text color
                ),
              ),
            ),
            if (_isLoading)
              SizedBox(
                height: 24,
                width: 24,
                child: CircularProgressIndicator(),
              ),
          ],
        ),
      ),
    ),
  );
}

}

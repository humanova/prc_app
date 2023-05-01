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
    final pickedFile = await ImagePicker().getImage(source: ImageSource.gallery);

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
    
    final response = await dataProcessor.getPrices(base64Encode(_image.readAsBytesSync()));

    setState(() {
      _isLoading = false;
    });

    if (response.isSuccess) {
      Product product = dataProcessor.parseProduct(response.data);
      pSearchStorage.saveSearch(product);

      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => ProductPricesScreen(product: product),
      ));
    } else {
      // Show error message
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text('Error'),
          content: Text('Failed to get prices.'),
        ),
      );
      //Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Image Screen'),
      ),
      body: Center(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _getImageFromCamera,
                  child: Text('Take Picture'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _getImageFromGallery,
                  child: Text('Choose from Gallery'),
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _image == null ? null : _getPricesFromAPI,
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text('Get Prices'),
            ),
          ],
        ),
      ),
    );
  }
}

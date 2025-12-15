import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:shopping_app/models/products_model.dart';

class ProductServices {
  final String _baseurl = 'https://fakestoreapi.com/products';

  Future<List<Products>> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse(_baseurl));
      
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        return data.map((product) => Products.fromJson(product)).toList();
      } else {
        throw Exception("Failed to load products: ${response.statusCode}");
      }
    } on SocketException {
      throw Exception("No internet connection");
    } on HttpException {
      throw Exception("Unable to fetch products");
    } on FormatException {
      throw Exception("Bad response format");
    } catch (e) {
      throw Exception("Unexpected error: $e");
    }
  }
}
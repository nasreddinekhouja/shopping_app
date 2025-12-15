import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:shopping_app/models/products_model.dart';
import 'package:shopping_app/views/products.dart';

class ProductDetails extends StatefulWidget {
  final Products product;

  const ProductDetails({super.key, required this.product});

  @override
  State<ProductDetails> createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Products get product => widget.product;
  int quantity = 1;

  void _showAddToCartDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add to Cart'),
          content: Text(
            'Add $quantity item(s) to your cart?\n'
            'Total: \$${(widget.product.price * quantity).toStringAsFixed(2)}',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Added to cart')),
                );
              },
              child: Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffb394e4),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            Image.network(
              product.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            Text(
              product.title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '\$${product.price}',
              style: TextStyle(
                fontSize: 20,
                color: Colors.white70,
              ),
            ),
            Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                product.description,
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              'Category: ${product.category}',
              style: TextStyle(color: Colors.white),
            ),
            Text(
              'Rating: ${product.rating}',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(height: 20),
            SizedBox(
              width: 120,
              child: SpinBox(
                min: 1,
                max: 10,
                value: quantity.toDouble(),
                readOnly: true,
                iconSize: 18,
                spacing: 6,
                textStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(6),
                  filled: true,
                  fillColor: Colors.transparent,
                ),
                onChanged: (value) {
                  setState(() {
                    quantity = value.toInt();
                  });
                },
              ),
            ),
            SizedBox(height: 12),
            Text(
              'Total: \$${(product.price * quantity).toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                _showAddToCartDialog(context);
              },
              icon: Icon(Icons.shopping_cart),
              label: Text("Add to Cart"),
            ),
            SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Productscreen(
                              products: [],
                            )));
              },
              icon: Icon(Icons.arrow_back),
              label: Text("Back"),
            ),
          ],
        ),
      ),
    );
  }
}

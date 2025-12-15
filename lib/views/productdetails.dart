import 'package:flutter/material.dart';
import 'package:flutter_spinbox/flutter_spinbox.dart';
import 'package:shopping_app/models/products_model.dart';
import 'package:shopping_app/views/products.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/shoppingcartProvider.dart';
import 'package:shopping_app/views/shoppingcart.dart';

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
      backgroundColor: const Color(0xffb394e4),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.network(
                  product.image,
                  height: 300,
                  width: double.infinity,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 20),
                Text(
                  product.title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '\$${product.price}',
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.white70,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Text(
                    product.description,
                    style: const TextStyle(color: Colors.white),
                    textAlign: TextAlign.center,
                  ),
                ),
                Text(
                  'Category: ${product.category}',
                  style: const TextStyle(color: Colors.white),
                ),
                Text(
                  'Rating: ${product.rating}',
                  style: const TextStyle(color: Colors.white),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: 120,
                  child: SpinBox(
                    min: 1,
                    max: 10,
                    value: quantity.toDouble(),
                    readOnly: true,
                    iconSize: 18,
                    spacing: 6,
                    textStyle: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                    decoration: const InputDecoration(
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
                const SizedBox(height: 12),
                Text(
                  'Total: \$${(product.price * quantity).toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Provider.of<ShoppingCart>(context, listen: false)
                        .addItem(product, quantity);

                    _showAddToCartDialog(context);
                  },
                  icon: const Icon(Icons.shopping_cart),
                  label: const Text("Add to Cart"),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Productscreen(
                          products: [],
                        ),
                      ),
                    );
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text("Back"),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
          Positioned(
            top: 30,
            right: 16,
            child: Consumer<ShoppingCart>(
              builder: (context, cart, child) {
                return Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        // ignore: deprecated_member_use
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(
                          Icons.shopping_cart,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ShoppingcartScreen()));
                        },
                      ),
                    ),
                    if (cart.itemCount > 0)
                      Positioned(
                        right: 6,
                        top: 6,
                        child: Container(
                          padding: const EdgeInsets.all(4),
                          decoration: const BoxDecoration(
                            color: Colors.red,
                            shape: BoxShape.circle,
                          ),
                          constraints: const BoxConstraints(
                            minWidth: 18,
                            minHeight: 18,
                          ),
                          child: Text(
                            cart.itemCount.toString(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/shoppingcartProvider.dart';
import 'package:shopping_app/views/products.dart';

class ShoppingcartScreen extends StatefulWidget {
  const ShoppingcartScreen({super.key});

  @override
  State<ShoppingcartScreen> createState() => _ShoppingcartScreenState();
}

class _ShoppingcartScreenState extends State<ShoppingcartScreen> {
  void _showCheckoutConfirmation(BuildContext context, ShoppingCart cart) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          title: const Text(
            'Confirm Checkout',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Are you sure you want to proceed with checkout?'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total Amount:',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                    Text(
                      '\$${cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xffb394e4),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
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
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xffb394e4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
                _processCheckout(context, cart);
              },
              child: const Text('Confirm'),
            ),
          ],
        );
      },
    );
  }

  void _processCheckout(BuildContext context, ShoppingCart cart) {
    cart.clearCart();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order placed successfully!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => Productscreen(
          products: [],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffb394e4),
      appBar: AppBar(
        backgroundColor: const Color(0xffb394e4),
        elevation: 0,
        title: const Text(
          'My Cart',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Consumer<ShoppingCart>(
        builder: (context, cart, child) {
          if (cart.items.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.shopping_cart_outlined,
                    size: 80,
                    color: Colors.white70,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your cart is empty',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 24),
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
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Back to Products'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xffb394e4),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(12),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final cartItem = cart.items[index];

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Image.network(
                          cartItem.product.image,
                          width: 50,
                          height: 50,
                          fit: BoxFit.contain,
                        ),
                        title: Text(
                          cartItem.product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 6),
                            Text(
                              '\$${cartItem.product.price.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Quantity: ${cartItem.quantity}',
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          icon: const Icon(
                            Icons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            cart.removeItem(cartItem);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: Colors.white.withOpacity(0.15),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total: \$${cart.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _showCheckoutConfirmation(context, cart);
                      },
                      child: const Text('Checkout'),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

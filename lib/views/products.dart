import 'package:flutter/material.dart';
import 'package:shopping_app/models/products_model.dart';
import 'package:shopping_app/services/product_service.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shopping_app/views/productdetails.dart';
import 'package:provider/provider.dart';
import 'package:shopping_app/viewmodels/shoppingcartProvider.dart';
import 'package:shopping_app/views/shoppingcart.dart';

class Productscreen extends StatefulWidget {
  const Productscreen({super.key, required List products});

  @override
  State<Productscreen> createState() => _ProductscreenState();
}

class _ProductscreenState extends State<Productscreen> {
  late Future<List<Products>> _products;
  List<Products> _filterProducts = [];
  List<Products> _allProducts = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _products = ProductServices().fetchProducts();
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    final products = await _products;
    setState(() {
      _allProducts = products;
      _filterProducts = products;
    });
  }

  void _filterProductsList() {
    setState(() {
      if (_searchController.text.isEmpty) {
        _filterProducts = _allProducts;
      } else {
        _filterProducts = _allProducts
            .where((product) => product.title
                .toLowerCase()
                .contains(_searchController.text.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffb394e4),
        title: Text(
          'Fake Store Products',
          style: GoogleFonts.lobster(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
      backgroundColor: const Color(0xffb394e4),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Search products...',
                      // ignore: deprecated_member_use
                      hintStyle:
                          // ignore: deprecated_member_use
                          TextStyle(color: Colors.white.withOpacity(0.7)),
                      prefixIcon: const Icon(Icons.search, color: Colors.white),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon:
                                  const Icon(Icons.clear, color: Colors.white),
                              onPressed: () {
                                _searchController.clear();
                                _filterProductsList();
                              },
                            )
                          : null,
                      filled: true,
                      // ignore: deprecated_member_use
                      fillColor: Colors.white.withOpacity(0.2),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        // ignore: deprecated_member_use
                        borderSide:
                            // ignore: deprecated_member_use
                            BorderSide(color: Colors.white.withOpacity(0.3)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide:
                            const BorderSide(color: Colors.white, width: 2),
                      ),
                    ),
                    onChanged: (value) => _filterProductsList(),
                  ),
                ),
                const SizedBox(width: 12),
                Consumer<ShoppingCart>(
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
                                      builder: (context) =>
                                          ShoppingcartScreen()));
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
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Products>>(
              future: _products,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  );
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline,
                            size: 60, color: Colors.white),
                        const SizedBox(height: 16),
                        Text(
                          'Error: ${snapshot.error}',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(
                    child: Text(
                      'No products found',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                final productsToDisplay =
                    _filterProducts.isEmpty && _searchController.text.isNotEmpty
                        ? []
                        : _filterProducts;

                if (productsToDisplay.isEmpty) {
                  return const Center(
                    child: Text(
                      'No matching products',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  );
                }

                return ListView.builder(
                  itemCount: productsToDisplay.length,
                  padding: const EdgeInsets.all(8),
                  itemBuilder: (context, index) {
                    final product = productsToDisplay[index];
                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.symmetric(
                          vertical: 8, horizontal: 4),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            product.image,
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return const SizedBox(
                                width: 60,
                                height: 60,
                                child: Center(
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                width: 60,
                                height: 60,
                                color: Colors.grey[300],
                                child: const Icon(Icons.error),
                              );
                            },
                          ),
                        ),
                        title: Text(
                          product.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                        subtitle: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: Text(
                            '\$${product.price.toStringAsFixed(2)}',
                            style: GoogleFonts.roboto(
                              fontWeight: FontWeight.bold,
                              color: Color(0xffb394e4),
                              fontSize: 16,
                            ),
                          ),
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ProductDetails(product: product)));
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

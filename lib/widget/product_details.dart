import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart'; // Add this dependency to your pubspec.yaml
import 'package:shared_preferences/shared_preferences.dart'; // Import the shared_preferences package

class ProductDetailPage extends StatelessWidget {
  final Map product;

  ProductDetailPage({required this.product});

  // Method to save product to SharedPreferences
  Future<void> _addToCart(BuildContext context) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? cartJson = prefs.getStringList('cart') ?? [];

    // Assuming product contains the necessary details
    String productJson = jsonEncode(product);
    if (!cartJson.contains(productJson)) {
      cartJson.add(productJson);
      await prefs.setStringList('cart', cartJson);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product added to cart!'),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Product is already in the cart.'),
        ),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text(product['title'],style: TextStyle(color: Colors.white),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Product Images Slider
            Container(
              padding: EdgeInsets.all(16),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 400,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
                items: [
                  product['image'], // Assuming only one image
                  // Add more images if available
                ].map((imageUrl) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
            ),

            // Product Details
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] ?? 'Product Title',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '\$${product['price'] ?? '0.00'}',
                    style: TextStyle(fontSize: 20, color: Colors.red),
                  ),
                  SizedBox(height: 8),
                  RatingBarIndicator(
                    rating: product['rating']['rate'] ?? 0.0,
                    itemBuilder: (context, index) => Icon(
                      Icons.star,
                      color: Colors.amber,
                    ),
                    itemCount: 5,
                    itemSize: 24.0,
                    direction: Axis.horizontal,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Description',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      product['description'] ?? 'Product description goes here.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () => _addToCart(context),
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                              padding: MaterialStateProperty.all(EdgeInsets.zero), // Remove padding
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Square corners
                                ),
                              ),
                              elevation: MaterialStateProperty.all(10),
                            ),
                            child: Text('Add to Cart', style: TextStyle(fontSize: 16,color: Colors.white)),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Buy now functionality
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.green),
                              padding: MaterialStateProperty.all(EdgeInsets.zero), // Remove padding
                              shape: MaterialStateProperty.all(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(0), // Square corners
                                ),
                              ),
                              elevation: MaterialStateProperty.all(10),
                            ),
                            child: Text('Add to Favourite', style: TextStyle(fontSize: 16,color: Colors.white)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

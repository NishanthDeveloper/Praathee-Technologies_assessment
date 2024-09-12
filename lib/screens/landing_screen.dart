import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:praathee_technologies_assessment/screens/cart_screen.dart';

import 'package:praathee_technologies_assessment/widget/caategory_card.dart';
import 'package:praathee_technologies_assessment/widget/countdown_timer.dart';
import 'package:praathee_technologies_assessment/widget/flash_sale.dart';
import 'package:praathee_technologies_assessment/widget/product_card.dart';

class EcommerceLandingPage extends StatefulWidget {
  @override
  _EcommerceLandingPageState createState() => _EcommerceLandingPageState();
}

class _EcommerceLandingPageState extends State<EcommerceLandingPage> {
  List products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(Uri.parse('https://fakestoreapi.com/products'));

      if (response.statusCode == 200) {
        setState(() {
          products = json.decode(response.body);
          isLoading = false;
        });
      } else {
        // Handle server errors (e.g., 404 or 500)
        print('Failed to load products. Status code: ${response.statusCode}');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      // Handle other types of errors (e.g., network issues)
      print('Error fetching products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: Row(
          children: [

            SizedBox(width: 20),
            Expanded(
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Search for products',
                  border: InputBorder.none,
                  filled: true,
                  fillColor: Colors.white,
                  prefixIcon: Icon(Icons.search, color: Colors.red),
                ),
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite,color: Colors.white,),
            onPressed: () {

            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart,color: Colors.white,),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CartPage()));
            },
          ),
          IconButton(
            icon: Icon(Icons.person,color: Colors.white,),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Carousel Slider Section
            Container(
              padding: EdgeInsets.all(16),
              child: CarouselSlider(
                options: CarouselOptions(
                  height: 200,
                  autoPlay: true,
                  enlargeCenterPage: true,
                  aspectRatio: 16 / 9,
                  viewportFraction: 0.8,
                ),
                items: [
                  'https://www.shutterstock.com/image-vector/summer-sale-template-banner-vector-260nw-656471581.jpg',
                  'https://www.shutterstock.com/image-vector/flash-sale-promotion-banner-25-260nw-2159885029.jpg',
                  'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQ9vXaFlfyFlTBRYOOyV1HWDZcHI-U9jCiBRXDmRNY1cjllc50kVm9rdJ_tsutlixpU3cc&usqp=CAU',
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

            // Flash Sales Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Flash Sales",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      CountdownTimer(targetDate: DateTime(2024, 12, 31, 23, 59, 59)),

                      Spacer(),
                      ElevatedButton(
                        onPressed: () {},
                        style: ButtonStyle(

                          backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          shape: MaterialStateProperty.all(RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          )),
                          elevation: MaterialStateProperty.all(0),
                          padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 12)),
                          textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        child: Text('View All'),
                      )

                    ],
                  ),
                  SizedBox(height: 10),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : Container(
                    height: 250,
                    child: ListView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: products.length,
                      itemBuilder: (context, index) {
                        return FlashSaleCard(product: products[index]);
                      },
                    ),
                  ),
                ],
              ),
            ),

            // Browse by Category Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Browse by Category",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: 80,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        CategoryCard(icon: Icons.phone, label: "Phones"),
                        CategoryCard(icon: Icons.computer, label: "Computers"),
                        CategoryCard(icon: Icons.watch, label: "Smartwatch"),
                        CategoryCard(icon: Icons.camera_alt, label: "Cameras"),
                        CategoryCard(icon: Icons.headphones, label: "Headphones"),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Best Selling Products Section
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Best Selling Products",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  isLoading
                      ? Center(child: CircularProgressIndicator())
                      : GridView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return ProductCard(product: products[index]);
                    },
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
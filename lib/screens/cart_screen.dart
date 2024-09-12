import 'package:flutter/material.dart';
import 'package:praathee_technologies_assessment/screens/check_out_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonEncode and jsonDecode

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<Map<String, dynamic>> cartItems = [];

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    List<Map<String, dynamic>> items = await getCartData();
    setState(() {
      cartItems = items;
    });
  }

  Future<List<Map<String, dynamic>>> getCartData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJsonList = prefs.getStringList('cart');
    if (cartJsonList != null) {
      List<Map<String, dynamic>> cartList = [];
      for (var itemJson in cartJsonList) {
        var decodedItem = jsonDecode(itemJson);
        if (decodedItem is Map<String, dynamic>) {
          // Add a quantity field if not present (assuming quantity is 1 for simplicity)
          decodedItem.putIfAbsent('quantity', () => 1);
          cartList.add(decodedItem);
        } else {
          print('Item is not a Map: $decodedItem');
        }
      }
      return cartList;
    }
    return [];
  }

  Future<void> saveCartData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> cartJsonList = cartItems.map((item) => jsonEncode(item)).toList();
    await prefs.setStringList('cart', cartJsonList);
  }

  void handleCheckout() async {
    // Save cart data to SharedPreferences
    await saveCartData();

    // Implement checkout functionality
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confrim your cart'),
        content: Text('Confrim your cart to procced checkout!'),
        actions: [
          TextButton(
            onPressed: () {
           Navigator.push(context, MaterialPageRoute(builder: (context)=>CheckoutPage()));
              // Navigate to another page or clear cart, etc.
            },
            child: Text('Confrim'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('Shopping Cart',style: TextStyle(color: Colors.white),),
      ),
      body: cartItems.isEmpty
          ? Center(child: Text('Your cart is empty'))
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cart Items List
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    child: ListTile(
                      leading: Image.network(
                        item['image'],
                        width: 100,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item['title']),
                      subtitle: Text('Price: \$${item['price']}'),
                      trailing: Text('Quantity: ${item['quantity']}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),
            // Cart Summary
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Cart Summary',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total Items: ${cartItems.fold<int>(0, (sum, item) => sum + (item['quantity'] as int))}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Total Price: \$${cartItems.fold<double>(0.0, (sum, item) {
                      double price = (item['price'] as num).toDouble();
                      int quantity = item['quantity'] as int;
                      return sum + (price * quantity);
                    }).toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 16, color: Colors.red),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                           Navigator.pop(context);
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blue),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(5),
                          ),
                          child: Text('Continue Shopping', style: TextStyle(fontSize: 16,color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            handleCheckout();
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.green),
                            padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15)),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            elevation: MaterialStateProperty.all(5),
                          ),
                          child: Text('Proceed to Checkout', style: TextStyle(fontSize: 16,color: Colors.white)),
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

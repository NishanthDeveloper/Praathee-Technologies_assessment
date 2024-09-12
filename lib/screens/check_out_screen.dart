import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For jsonDecode

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Map<String, dynamic>> cartItems = [];
  final TextEditingController _addressController = TextEditingController();
  String _paymentMethod = 'Credit/Debit Card';

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cartJsonList = prefs.getStringList('cart');
    if (cartJsonList != null) {
      List<Map<String, dynamic>> items = cartJsonList.map((itemJson) {
        return jsonDecode(itemJson) as Map<String, dynamic>;
      }).toList();

      setState(() {
        cartItems = items;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double totalPrice = cartItems.fold<double>(0.0, (sum, item) {
      return sum + (item['price'] as double) * (item['quantity'] as int);
    });

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.red,
        title: Text('Checkout',style: TextStyle(color: Colors.white),),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Shipping Address
            Text(
              'Shipping Address',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter your address',
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16),

            // Order Summary
            Text(
              'Order Summary',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8),
                    elevation: 5,
                    child: ListTile(
                      leading: item['image'] != null
                          ? Image.network(
                        item['image'],
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      )
                          : SizedBox(width: 80, height: 80), // Placeholder if image URL is not available
                      title: Text(item['title']),
                      subtitle: Text('Price: \$${item['price']}'),
                      trailing: Text('Qty: ${item['quantity']}'),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 16),

            // Payment Method
            Text(
              'Payment Method',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _paymentMethod,
              items: ['Credit/Debit Card', 'Cash on Delivery'].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _paymentMethod = newValue!;
                });
              },
            ),
            SizedBox(height: 16),

            // Total Price
            Text(
              'Total Price: \$${totalPrice.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 16),

            // Place Order Button
            ElevatedButton(
              onPressed: () {
                // Implement place order functionality
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: Text('Order Placed'),
                    content: Text('Thank you for your purchase!'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          // Navigate to home or another page
                        },
                        child: Text('OK'),
                      ),
                    ],
                  ),
                );
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
                padding: MaterialStateProperty.all(EdgeInsets.symmetric(vertical: 15, horizontal: 30)),
                shape: MaterialStateProperty.all(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                elevation: MaterialStateProperty.all(5),
                textStyle: MaterialStateProperty.all(TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
              child: Text('Place Order',style: TextStyle(color: Colors.white),),
            ),
          ],
        ),
      ),
    );
  }
}

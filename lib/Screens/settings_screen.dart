import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: ListView.builder(
        itemCount: 10, // Replace with the actual number of orders
        itemBuilder: (context, index) {
          return ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Order #$index'), // Replace with order details
            subtitle:
                Text('Order details go here'), // Replace with order details
            onTap: () {
              // Handle tapping on an order item
              // You can navigate to a specific order details screen here
            },
          );
        },
      ),
    );
  }
}

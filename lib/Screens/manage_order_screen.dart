import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ManageOrdersScreen extends StatefulWidget {
  final String token;

  ManageOrdersScreen({required this.token});

  @override
  _ManageOrdersScreenState createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  List<OrderItem> orderItems = [];

  @override
  void initState() {
    super.initState();
    // Fetch data from the API when the screen is initialized
    fetchData();
  }

  Future<void> fetchData() async {
    final apiUrl =
        'https://menu.scoopup.app/api/v2/vendor/orders?api_token=${widget.token}';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['status'] == true) {
          final orders = data['data'];
          setState(() {
            // Parse and add order data to the list
            orderItems = List<OrderItem>.from(
                orders.map((order) => OrderItem.fromJson(order)));
          });
        } else {
          // Handle API error or display a message to the user
          // You can show a Snackbar or AlertDialog with an error message
        }
      } else {
        // Handle HTTP error or display a message to the user
        // You can show a Snackbar or AlertDialog with an error message
      }
    } catch (error) {
      // Handle network or other errors
      // You can show a Snackbar or AlertDialog with an error message
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage Orders'),
      ),
      body: ListView.builder(
        itemCount: orderItems.length,
        itemBuilder: (context, index) {
          return _buildOrderCard(orderItems[index]);
        },
      ),
    );
  }

  Widget _buildOrderCard(OrderItem order) {
    // Define a variable to hold the delivery method icon
    IconData deliveryMethodIcon;

    // Determine the delivery method based on the order response
    switch (order.deliveryMethod) {
      case 1:
        deliveryMethodIcon = Icons.restaurant_outlined; // Dine In
        break;
      case 2:
        deliveryMethodIcon = Icons.shopping_bag_outlined; // Takeaway
        break;
      case 3:
        deliveryMethodIcon = Icons.local_shipping_outlined; // Delivery
        break;
      default:
        deliveryMethodIcon =
            Icons.info; // Default icon for an unknown delivery method
    }

    return Card(
      elevation: 2.0,
      margin: EdgeInsets.all(16.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Row(
        // Use a Row widget to align the ListTile and delivery method icon
        children: [
          Expanded(
            child: ListTile(
              title: Text('Order #${order.id}',
                  style:
                      TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Restaurant: ${order.restaurantName}'),
                  Text('Created at: ${order.createdAt}'),
                  Text('Payment Status: ${order.paymentStatus}'),
                  Text('Price: OMR ${order.orderPrice.toStringAsFixed(2)}'),
                ],
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.all(4.0),
            decoration: BoxDecoration(
              color: Colors.green,
              shape: BoxShape.circle,
            ),
            child: Icon(
              deliveryMethodIcon, // Use the determined icon
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderItem {
  final int id;
  final String restaurantName;
  final String createdAt;
  final String paymentStatus;
  final double orderPrice;
  final int deliveryMethod; // Added delivery method field

  OrderItem({
    required this.id,
    required this.restaurantName,
    required this.createdAt,
    required this.paymentStatus,
    required this.orderPrice,
    required this.deliveryMethod,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      id: json['id'],
      restaurantName: json['restorant']['name'],
      createdAt: json['created_at'],
      paymentStatus: json['payment_status'],
      orderPrice: json['order_price'].toDouble(),
      deliveryMethod: json['delivery_method'] ?? 0, // Parse delivery method
    );
  }
}

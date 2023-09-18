import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:scoopup_app/Screens/earning_screen.dart';
import 'package:scoopup_app/Screens/manage_order_screen.dart';
import 'notifications_screen.dart';
import 'settings_screen.dart';

class ManageScreen extends StatefulWidget {
  @override
  _ManageScreenState createState() => _ManageScreenState();
}

class _ManageScreenState extends State<ManageScreen> {
  late String token; // Declare the token variable

  late List<GridItem> gridItems; // Declare the gridItems variable

  @override
  void initState() {
    super.initState();
    // Load the token from shared preferences when the widget is initialized
    _loadTokenFromSharedPreferences();

    // Initialize the gridItems list inside the initState
    gridItems = [
      GridItem(
        icon: Icons.work,
        title: 'Manage Orders',
        subtext: 'View and manage orders',
        screen: () => ManageOrdersScreen(token: token), // Pass the token here
      ),
      GridItem(
        icon: Icons.attach_money,
        title: 'Earnings',
        subtext: 'View earnings and statistics',
        screen: () => EarningsScreen(), // Pass the token here
      ),
      GridItem(
        icon: Icons.notifications,
        title: 'Notifications',
        subtext: 'Manage notifications',
        screen: () => NotificationsScreen(), // Pass the token here
      ),
      GridItem(
        icon: Icons.settings,
        title: 'Settings',
        subtext: 'Configure app settings',
        screen: () => SettingsScreen(), // Pass the token here
      ),
    ];
  }

  // Function to load the token from shared preferences
  _loadTokenFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      token = prefs.getString('token') ??
          ''; // Replace 'token' with your actual key
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Manage'),
      ),
      body: GridView.builder(
        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 200.0,
          mainAxisSpacing: 16.0,
          crossAxisSpacing: 16.0,
          childAspectRatio: 1.2,
        ),
        padding: EdgeInsets.all(16.0),
        itemCount: gridItems.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildGridItem(context, gridItems[index]);
        },
      ),
    );
  }

  Widget _buildGridItem(BuildContext context, GridItem item) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: InkWell(
        onTap: () {
          // Navigate to the respective screen when a grid item is tapped
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => item.screen()),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(item.icon, size: 48.0, color: Colors.blue),
            SizedBox(height: 8.0),
            Text(
              item.title,
              style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 4.0),
            Text(
              item.subtext,
              style: TextStyle(fontSize: 14.0, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class GridItem {
  final IconData icon;
  final String title;
  final String subtext;
  final Function() screen; // Accept token as an argument

  GridItem({
    required this.icon,
    required this.title,
    required this.subtext,
    required this.screen,
  });
}

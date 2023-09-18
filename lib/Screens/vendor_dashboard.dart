import 'package:flutter/material.dart';
import 'package:scoopup_app/Screens/manage_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class VendorDashboard extends StatefulWidget {
  final String token;

  VendorDashboard({required this.token});

  @override
  _VendorDashboardState createState() => _VendorDashboardState();
}

class _VendorDashboardState extends State<VendorDashboard> {
  String name = ''; // Initialize with an empty string
  String email = ''; // Initialize with an empty string

  @override
  void initState() {
    super.initState();
    // Retrieve user's name and email from SharedPreferences
    loadUserData();
  }

  void loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? ''; // Use default value if not found
      email = prefs.getString('email') ?? ''; // Use default value if not found
    });
  }

  void logout() async {
    // Clear stored data (token, name, email) and navigate back to the login page
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vendor Dashboard'),
      ),
      drawer: Drawer(
        child: ListView(
          children: <Widget>[
            UserAccountsDrawerHeader(
              accountName: Text(name), // Display user's name here
              accountEmail: Text(email), // Display user's email here
              currentAccountPicture: CircleAvatar(
                backgroundColor: Colors.white,
                child: Icon(Icons.person),
              ),
            ),
            ListTile(
              title: Text(
                  'Your Token: ${widget.token}'), // Display user's token here
            ),
            Divider(), // Add a divider for better visual separation
            ListTile(
              title: Text('Log Out'),
              onTap: logout,
            ),
          ],
        ),
      ),
      body: Center(
        child: Text('Earnings panel with graphs will go here.'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.manage_accounts),
            label: 'Manage',
          ),
        ],
        onTap: (int index) {
          if (index == 1) {
            // Navigate to the ManageScreen when "Manage" tab is selected
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => ManageScreen()));
          }
        },
      ),
    );
  }
}

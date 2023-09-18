import 'package:flutter/material.dart';
import 'package:scoopup_app/Screens/login_page.dart';
import 'package:scoopup_app/Screens/vendor_dashboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Your App Name',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => LoginPage(),
        '/vendorDashboard': (context) {
          final Map<String, dynamic> args = ModalRoute.of(context)
              ?.settings
              .arguments as Map<String, dynamic>;
          final String token = args['token'];

          return VendorDashboard(
            token: token,
          );
        },
      },
    );
  }
}

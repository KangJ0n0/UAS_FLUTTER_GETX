import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../views/dashboard_view.dart';
import '../views/cashier_view.dart';

class Sidebar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('POS App',
                style: TextStyle(color: Colors.white, fontSize: 24)),
          ),
          ListTile(
            leading: Icon(Icons.dashboard),
            title: Text('Dashboard'),
            onTap: () => Get.off(() => DashboardPage()),
          ),
          ListTile(
            leading: Icon(Icons.shopping_cart),
            title: Text('Kasir'),
            onTap: () => Get.off(() => CashierPage()),
          ),
          ListTile(
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => Get.offAllNamed('/login'),
          ),
        ],
      ),
    );
  }
}
